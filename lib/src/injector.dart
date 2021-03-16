import 'package:get_it/get_it.dart';

abstract class Injector {
  T get<T extends Object>(
      {String? key, Map<String, dynamic>? additionalParameters});

  void map<S extends Object>(InjectorFactory<S> _factory,
      {bool isSingleton = false, String? key});

  void removeMapping<S extends Object>({String? key}) {}
}

class GetItInjector implements Injector {
  final GetIt _instance = GetIt.asNewInstance();

  @override
  T get<T extends Object>(
      {String? key, Map<String, dynamic>? additionalParameters}) {
    try {
      return _instance<T>(instanceName: key);
    } on AssertionError {
      throw InjectorException();
    }
  }

  @override
  void map<S extends Object>(_factory,
      {bool isSingleton = false, String? key}) {
    if (isSingleton) {
      _instance.registerSingleton<S>(_factory(this), instanceName: key);
    } else {
      _instance.registerFactory<S>(() => _factory(this), instanceName: key);
    }
  }

  @override
  void removeMapping<S extends Object>({String? key}) {
    try {
      _instance.unregister<S>(instanceName: key);
    } on AssertionError {
      throw InjectorException();
    }
  }
}

class InjectorException implements Exception {}

///The builder of injector.
// ignore: prefer_generic_function_type_aliases
typedef T InjectorFactory<T>(Injector injector);
