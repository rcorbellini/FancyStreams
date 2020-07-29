import 'dart:async';

import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'disposable.dart';

///Give all power of Fancy Streans to Disposable class.
///All power are based on Type of generic function, that type can
/// be combined with a key name, that power are:
/// - [listenOn] to listen a stream, without boiler plate of subjec and cancel
/// subscription.
/// - [dispatchOn] to add some value to sink, without any outer code.
/// - [dispatchAllOn] like dispatch, but for multiple values.
/// - [streamOf]  get directly instance of stream, without  any boiler
/// plate of subjec.
/// - [cleanAll] will close/cancel everything created.
extension FancyStreamsPower on Disposable {
  StreamSubscription<T> listenOn<T>(void Function(T) onData,
      {Function onError,
      void Function() onDone,
      bool cancelOnError,
      String key}) {
    final subscription =
        streamOf<T>(key: key).listen(onData, onError: onError, onDone: onDone);
    //adding on subcription, to clean on future.
    _loadedSubscription.add(subscription);

    return subscription;
  }

  void dispatchOn<T>(T value, {String key}) {
    _behaviorSubjectOf<T>(key: key).sink.add(value);
  }

  void dispatchAllOn<T>(Stream<T> values, {String key}) {
    _behaviorSubjectOf<T>(key: key).sink.addStream(values);
  }

  Stream<T> streamOf<T>({String key}) {
    try {
      return _injector.get<Stream<T>>(key: key);
    } on InjectorException {
      _injector.map<Stream<T>>((i) => _behaviorSubjectOf<T>(key: key).stream,
          isSingleton: true, key: key);
      return streamOf<T>(key: key);
    }
  }

  BehaviorSubject<T> _behaviorSubjectOf<T>({String key}) {
    try {
      final subject = _injector.get<BehaviorSubject<T>>(key: key);

      assert(
          _loadedSubjects[key ?? getDefaultKeyName(subject)] == null ||
              _loadedSubjects[key ?? getDefaultKeyName(subject)] == subject,
          'Must be the first or the same subject already loaded for type+key');

      //adding on subjects, to clean on future.
      _loadedSubjects[key ?? getDefaultKeyName(subject)] = subject;
      return subject;
    } on InjectorException {
      _injector.map<BehaviorSubject<T>>((i) => BehaviorSubject<T>(),
          isSingleton: true, key: key);

      return _behaviorSubjectOf<T>(key: key);
    }
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

  Map<String, dynamic> valuesToMap() {
    return _loadedSubjects.map<String, dynamic>(
        (String key, BehaviorSubject s) =>
            MapEntry<String, dynamic>(key, s.value));
  }

  ///Get instance of injector based on instance (hashcode) of the class called.
  Injector get _injector =>
      Injector.getInjector(identityHashCode(this).toString());

  ///Clean/close all necessary (loaded) objects.
  void cleanAll() {
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
