import 'package:meta/meta.dart';
import 'fancy_stream_ext.dart';

///A abstraction of  something can be disposable, everything can be disosable
/// has all of power of fancy stream (extesion functions over Disposable).
/// This class only have a [dispose] function, when you no need more 
/// yours streams you MUST call it. 
abstract class Disposable {

  ///Must call when your imlpementation of this class are being disposed.
  @mustCallSuper
  void dispose() {
    cleanAll();
  }
}
