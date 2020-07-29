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

  test('streamValues return right values', () async {
    dummyClass.dispatchOn<String>('Rafael', key: 'name');
    dummyClass.dispatchOn<String>('Rafael2', key: 'name');
    dummyClass.dispatchOn<String>('JinglleBell', key: 'nickname');
    //never emit just for test
    dummyClass.streamOf<String>(key: 'dummy');

    final map = dummyClass.valuesToMap();
    print(map);
    expect(map['name'], 'Rafael2');
    expect(map['nickname'], 'JinglleBell');
    expect(map['dummy'], null);
  });
}

class DummyClass extends Disposable {}
