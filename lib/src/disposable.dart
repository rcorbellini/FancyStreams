import 'package:fancy_stream/src/fancy.dart';
import 'package:meta/meta.dart';

///A abstraction of  something can be disposable, everything can be disosable
/// has all of power of fancy stream (extesion functions over Disposable).
/// This class only have a [dispose] function, when you no need more
/// yours streams you MUST call it.
abstract class Disposable {
  final Fancy fancy = Fancy();

  ///Must call when your imlpementation of this class are being disposed.
  @mustCallSuper
  void dispose() {
    fancy.dispose();
  }
}
