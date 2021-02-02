import 'dart:async';

import 'package:fancy_stream/src/fancy.dart';
import 'package:test/test.dart';

import 'package:fancy_stream/fancy_stream.dart';

void main() {
  Fancy dummyClass;

  setUp(() {
    dummyClass = Fancy();
  });

  tearDown(() => dummyClass.dispose());

  test('DispatchOn ListtenOn type, with key', () async {
    expect(dummyClass.streamOf<String>(key: "key_test"), emits("ok"));

    dummyClass.dispatchOn<String>("ok", key: "key_test");
  });

  test('DispatchOn ListtenOn type, without key', () async {
    expect(dummyClass.streamOf<String>(), emits("ok"));

    dummyClass.dispatchOn<String>("ok");
  });

  test('addTransformOn with/without key', () async {
    final transformer =
        StreamTransformer<int, String>.fromHandlers(handleData: (campo, sink) {
      sink.add(campo.toString());
    });

    dummyClass.addTransformOn(transformer);
    dummyClass.addTransformOn(transformer, key: 'test');

    expect(dummyClass.streamOf<String>(), emits('1'));
    expect(dummyClass.streamOf<String>(key: 'test'), emits('2'));

    dummyClass.dispatchOn<int>(1);
    dummyClass.dispatchOn<int>(2, key: 'test');
  });

  test('streamValues return right values, with object key', () async {
    dummyClass.dispatchOn<String>('Rafael', key: keyTest.name);
    dummyClass.dispatchOn<String>('Rafael2', key: keyTest.name);
    dummyClass.dispatchOn<String>('JinglleBell', key: keyTest.nickname);
    //never emit just for test
    dummyClass.streamOf<String>(key: keyTest.dummy);

    final map = dummyClass.map;
    print(map);
    expect(map[keyTest.name], 'Rafael2');
    expect(map[keyTest.nickname], 'JinglleBell');
    expect(map[keyTest.dummy], null);
  });
}


enum keyTest { name, nickname, dummy }
