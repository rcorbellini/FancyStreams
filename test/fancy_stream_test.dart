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

  test('streamValues return right values, with object key', () async {
    dummyClass.dispatchOn<String>('Rafael', key: keyTest.name);
    dummyClass.dispatchOn<String>('Rafael2', key: keyTest.name);
    dummyClass.dispatchOn<String>('JinglleBell', key: keyTest.nickname);
    //never emit just for test
    dummyClass.streamOf<String>(key: keyTest.dummy);

    final map = dummyClass.valuesToMap<keyTest>();
    print(map);
    expect(map[keyTest.name], 'Rafael2');
    expect(map[keyTest.nickname], 'JinglleBell');
    expect(map[keyTest.dummy], null);
  });
}

class DummyClass extends Disposable {}


enum keyTest{
   name, nickname , dummy

}