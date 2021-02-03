import 'dart:async';

import 'package:fancy_stream/src/fancy.dart';
import 'package:fancy_stream/src/fancy_imp.dart';
import 'package:meta/meta.dart';


///A abstraction of  something can be disposable, everything can be disosable
/// has all of power of fancy stream (extesion functions over Disposable).
/// This class only have a [dispose] function, when you no need more
/// yours streams you MUST call it.
class FancyDelegate implements Fancy {
  final Fancy fancy;

  FancyDelegate({Fancy fancy}) : fancy = fancy ?? FancyImp();

  ///Must call when your imlpementation of this class are being disposed.
  @mustCallSuper
  void dispose() {
    fancy.dispose();
  }

  @override
  StreamSubscription<T> listenOn<T>(void Function(T) onData,
      {Function onError,
        void Function() onDone,
        bool cancelOnError,
        Object key}) =>
      fancy.listenOn(onData,
          onDone: onDone,
          onError: onError,
          cancelOnError: cancelOnError,
          key: key);

  @override
  void dispatchOn<T>(T value, {Object key}) =>
      fancy.dispatchOn(value, key: key);

  @override
  void dispatchAllOn<T>(Stream<T> values, {Object key}) =>
      fancy.dispatchOn(values, key: key);

  @override
  Stream<T> streamOf<T>({Object key}) => fancy.streamOf(key: key);

  @override
  void addTransformOn<T, S>(StreamTransformer<T, S> streamTransformer,
      {Object key}) =>
      fancy.addTransformOn(streamTransformer, key: key);

  Map<K, dynamic> valuesToMap<K>() => fancy.map;

  @override
  Map get map => fancy.map;

  ///Clean/close all necessary (loaded) objects.
  void cleanAll() => fancy.dispose();
}
