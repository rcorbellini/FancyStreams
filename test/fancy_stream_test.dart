import 'dart:math';

import 'package:test/test.dart';

import 'package:fancy_stream/fancy_stream.dart';

void main() {
  DummyClass dummyClass;

  setUp(() {
    dummyClass = DummyClass();
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

  test('Check value of Streams', () async {
    dummyClass.dispatchOn<String>('Rafael', key: 'name');
    dummyClass.dispatchOn<String>('JinglleBell', key: 'nickname');
    //never emit just for test
    dummyClass.streamOf<String>(key: 'dummy');

    final map = dummyClass.streamValues();
    print(map);
    expect(map['name'], 'Rafael');
    expect(map['nickname'], 'JinglleBell');
    expect(map['dummy'], null);
  });
}

class DummyClass extends Disposable {}
