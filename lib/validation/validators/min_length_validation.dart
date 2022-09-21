import 'package:flutter/material.dart';

import '../../presentation/protocols/protocols.dart';

class MinLengthValidation implements FieldValidation {
  MinLengthValidation({@required this.field,@required  this.size});
  final String field;
  final int size;

  @override
  ValidationError validate(String value) {
    return value!=null && value.length >= size ? null: ValidationError.invalidField;
  }
}