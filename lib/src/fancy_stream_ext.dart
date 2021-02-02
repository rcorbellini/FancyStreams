import 'dart:async';

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
          Object key}) =>
      fancy.listenOn(onData,
          onDone: onDone,
          onError: onError,
          cancelOnError: cancelOnError,
          key: key);

  void dispatchOn<T>(T value, {Object key}) =>
      fancy.dispatchOn(value, key: key);

  void dispatchAllOn<T>(Stream<T> values, {Object key}) =>
      fancy.dispatchOn(values, key: key);

  Stream<T> streamOf<T>({Object key}) => fancy.streamOf(key: key);

  void addTransformOn<T, S>(StreamTransformer<T, S> streamTransformer,
          {Object key}) =>
      fancy.addTransformOn(streamTransformer, key: key);

  Map<K, dynamic> valuesToMap<K>() => fancy.map;

  ///Clean/close all necessary (loaded) objects.
  void cleanAll() => fancy.dispose();
}
