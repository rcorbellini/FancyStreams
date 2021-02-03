import 'package:fancy_stream/fancy_stream.dart';
import 'package:fancy_stream/src/fancy_imp.dart';

class Example {
  void main(List<String> args) {
    Fancy fancy = FancyImp();
    //listen something on String, with key = "print"
    fancy.listenOn<String>(printWhenDispatchedValue, key: "print");
    fancy.dispatchOn<String>("Print that!", key: "print");

    fancy.listenOn<String>(printWhenDispatchedValue);
    fancy.dispatchOn<String>("Print that without key!");

    final values = fancy.map;
    printWhenDispatchedValue(values.toString());

    ///Clean all Subjects, Subscrtiption and instances generated
    fancy.dispose();
  }

  void printWhenDispatchedValue(String value) {
    print(value);
  }
}
