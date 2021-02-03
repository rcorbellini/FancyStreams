import 'dart:async';

abstract class Fancy {
  StreamSubscription<T> listenOn<T>(void Function(T) onData,
      {Function onError,
      void Function() onDone,
      bool cancelOnError,
      Object key});

  void dispatchOn<T>(T value, {Object key});

  void dispatchAllOn<T>(Stream<T> values, {Object key});

  Stream<T> streamOf<T>({Object key});

  void addTransformOn<T, S>(StreamTransformer<T, S> streamTransformer,
      {Object key});

  Map<dynamic, dynamic> get map;

  void dispose();
}
