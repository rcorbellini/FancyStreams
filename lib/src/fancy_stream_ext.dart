import 'dart:async';

import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'disposable.dart';

extension FancyStreamsPower on Disposable {
  StreamSubscription<T> listenOn<T>(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError, String key}) {
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
      //adding on subjects, to clean on future.
      _loadedBehaviors.add(subject);
      return subject;
    } on InjectorException {
      _injector.map<BehaviorSubject<T>>((i) => BehaviorSubject<T>(),
          isSingleton: true, key: key);

      return _behaviorSubjectOf<T>(key: key);
    }
  }

  ///List with all Subject already loaded
  Set<Subject> get _loadedBehaviors {
    try {
      return _injector.get<Set<Subject>>();
    } on InjectorException {
      //It`s not mapped yet.

      //mapping
      _injector.map<Set<Subject>>((i) => {}, isSingleton: true);

      //now it`s all ready, try again.
      return _loadedBehaviors;
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
      return _loadedSubscription;
    }
  }

  ///Get instance of injector based on instance (hashcode) of the class called.
  Injector get _injector =>
      Injector.getInjector(identityHashCode(this).toString());

  ///Clean/close all necessary (loaded) objects.
  void cleanAll() {
    print("Closing subscription: ${_loadedSubscription.length}");
    _loadedSubscription.forEach((f) {
      f.cancel();
    });

    print("Closing Subjects: ${_loadedBehaviors.length}");
    _loadedBehaviors.forEach((f) {
      if (!f.isClosed) {
        f.close();
      }
    });

    _injector.dispose();
  }
}
