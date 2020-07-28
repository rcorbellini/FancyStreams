import 'package:meta/meta.dart';
import 'fancy_stream_ext.dart';

abstract class Disposable {
  @mustCallSuper
  void dispose() {
    cleanAll();
  }
}
