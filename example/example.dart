import 'package:fancy_stream/fancy_stream.dart';

class Example extends Disposable {
  void main(List<String> args) {
    //listen something on String, with key = "print"
    listenOn<String>(printWhenDispatchedValue, key: "print");
    dispatchOn<String>("Print that!", key: "print");

    listenOn<String>(printWhenDispatchedValue);
    dispatchOn<String>("Print that without key!");

    final values = valuesToMap<String>();
    printWhenDispatchedValue(values.toString());

    ///Clean all Subjects, Subscrtiption and instances generated
    dispose();
  }

  void printWhenDispatchedValue(String value) {
    print(value);
  }
}
