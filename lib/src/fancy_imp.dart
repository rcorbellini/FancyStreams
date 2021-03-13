import 'dart:async';

import 'package:fancy_stream/fancy_stream.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:rxdart/rxdart.dart';

///Give all power of Fancy Streans to Disposable class.
///All power are based on Type of generic function, that type can
/// be combined with a key name, that power are:
/// - [listenOn] to listen a stream, without boiler plate of subjec and cancel
/// subscription.
/// - [dispatchOn] to add some value to sink, without any outer code.
/// - [dispatchAllOn] like dispatch, but for multiple values.
/// - [streamOf]  get directly instance of stream, without  any boiler
/// plate of subjec.
/// - [dispose] will close/cancel everything created.
class FancyImp implements Fancy {
  StreamSubscription<T> listenOn<T>(void Function(T) onData,
      {Function? onError,
      void Function()? onDone,
      bool? cancelOnError,
      Object? key}) {
    final subscription =
        streamOf<T>(key: key).listen(onData, onError: onError, onDone: onDone);
    //adding on subcription, to clean on future.
    _loadedSubscription.add(subscription);

    return subscription;
  }

  void dispatchOn<T>(T value, {Object? key}) {
    _behaviorSubjectOf<T>(key: key).sink.add(value);
  }

  void dispatchErrorOn<T>(Object value, {Object? key}) {
    _behaviorSubjectOf<T>(key: key).sink.addError(value);
  }

  void dispatchAllOn<T>(Stream<T> values, {Object? key}) {
    _behaviorSubjectOf<T>(key: key).sink.addStream(values);
  }

  Stream<T> streamOf<T>({Object? key}) {
    try {
      return _injector.get<Stream<T>>(key: _objetcToKey(key));
    } on InjectorException {
      _injector.map<Stream<T>>((i) => _behaviorSubjectOf<T>(key: key).stream,
          isSingleton: true, key: _objetcToKey(key));
      return streamOf<T>(key: key);
    }
  }

  void addTransformOn<T, S>(StreamTransformer<T, S> streamTransformer,
      {Object? key}) {
    final stream = streamOf<T>(key: key);
    //removing the old one
    _injector.removeMapping<Stream<T>>(key: _objetcToKey(key));

    final streamTransformed = stream.transform(streamTransformer);
    try {
      _injector.removeMapping<Stream<S>>(key: _objetcToKey(key));
    } on InjectorException {
      //"its all righ, the new one doesn't exist, or already removed";
    }
    _injector.map<Stream<S>>((i) => streamTransformed,
        isSingleton: true, key: _objetcToKey(key));
  }

  BehaviorSubject<T> _behaviorSubjectOf<T>({Object? key}) {
    try {
      final subject = _injector.get<BehaviorSubject<T>>(key: _objetcToKey(key));

      assert(
          _loadedSubjects[key ?? getDefaultKeyName(subject)] == null ||
              _loadedSubjects[key ?? getDefaultKeyName(subject)] == subject,
          'Must be the first or the same subject already loaded for type+key');

      //adding on subjects, to clean on future.
      _loadedSubjects[_objetcToKey(key) ?? getDefaultKeyName(subject)] =
          subject;
      return subject;
    } on InjectorException {
      _injector.map<BehaviorSubject<T>>((i) => BehaviorSubject<T>(),
          isSingleton: true, key: _objetcToKey(key));

      return _behaviorSubjectOf<T>(key: key);
    }
  }

  String? _objetcToKey(Object? key) {
    if (key == null) {
      return null;
    }
    final stringKey = key.toString();
    _keys[stringKey] = key;
    return stringKey;
  }

  String getDefaultKeyName<T>(T instance) {
    final cleanName = instance
        .toString()
        .replaceFirst('Instance of ', '')
        .replaceAll('\'', '');
    return '$cleanName::${identityHashCode(instance)}';
  }

  ///List with all Subject already loaded
  Map<String, BehaviorSubject> get _loadedSubjects {
    try {
      return _injector.get<Map<String, BehaviorSubject>>();
    } on InjectorException {
      //It`s not mapped yet.

      //mapping
      _injector.map<Map<String, BehaviorSubject>>((i) => {}, isSingleton: true);

      //now it`s all ready, try again.
      // ignore: recursive_getters
      return _loadedSubjects;
    }
  }

  Set<StreamSubscription> get _loadedSubscription {
    try {
      return _injector.get<Set<StreamSubscription>>();
    } on InjectorException {
      //It`s not mapped yet.

      //mapping
      _injector.map<Set<StreamSubscription>>((i) => {}, isSingleton: true);

      //now it`s all ready, try again.
      // ignore: recursive_getters
      return _loadedSubscription;
    }
  }

  Map<String, Object> get _keys {
    try {
      return _injector.get<Map<String, Object>>();
    } on InjectorException {
      //It`s not mapped yet.

      //mapping
      _injector.map<Map<String, Object>>((i) => {}, isSingleton: true);

      //now it`s all ready, try again.
      // ignore: recursive_getters
      return _keys;
    }
  }

  Map<dynamic, dynamic> get map {
    return _loadedSubjects.map<dynamic, dynamic>(
        (String key, BehaviorSubject s) =>
            MapEntry<dynamic, dynamic>(_keys[key], s.value));
  }

  operator [](Object key) => map[key];

  ///Get instance of injector based on instance (hashcode) of the class called.
  Injector get _injector => Injector(identityHashCode(this).toString());

  ///Clean/close all necessary (loaded) objects.
  void dispose() {
    print('Closing subscription: ${_loadedSubscription.length}');
    _loadedSubscription.forEach((f) {
      f.cancel();
    });

    print('Closing Subjects: ${_loadedSubjects.length}');
    _loadedSubjects.forEach((k, v) {
      if (!v.isClosed) {
        v.close();
      }
    });

    _injector.dispose();
  }
}
