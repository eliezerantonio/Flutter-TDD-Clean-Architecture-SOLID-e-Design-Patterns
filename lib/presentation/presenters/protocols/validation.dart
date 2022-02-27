import 'package:flutter/foundation.dart';

abstract class Validation {
  String validate({@required String field, @required String value});
}
