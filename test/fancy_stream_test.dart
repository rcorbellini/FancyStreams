import 'package:test/test.dart';

import 'package:fancy_stream/fancy_streams.dart';

void main() {
  DummyClass dummyClass;

  setUp(() {
    dummyClass = DummyClass();
  });

  tearDown(() => dummyClass.dispose());

  test('DispatchOn ListtenOn type, with key', () async {
    expect(dummyClass.streamOf<String>(key: "key_test"),
        emits("ok"));
        
   dummyClass.dispatchOn<String>("ok", key: "key_test");
  });

  test('DispatchOn ListtenOn type, without key', () async {
    expect(dummyClass.streamOf<String>(),
        emits("ok"));
        
   dummyClass.dispatchOn<String>("ok");
  });
}

class DummyClass extends Disposable {}
