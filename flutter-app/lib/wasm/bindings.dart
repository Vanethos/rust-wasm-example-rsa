// ignore_for_file: use_function_type_syntax_for_parameters

@JS()
library bindings;

import 'package:js/js.dart';

@JS()
abstract class Promise<T> {
  external factory Promise(
      void executor(void resolve(T result), Function reject));
  external Promise then(void onFulfilled(T result), [Function onRejected]);
}

@JS('init')
external Promise<void> init();

@JS('sign')
external List<int> sign(String data);