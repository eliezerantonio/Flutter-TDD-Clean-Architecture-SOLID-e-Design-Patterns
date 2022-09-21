import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../presentation/protocols/protocols.dart';

class MinLengthValidation  extends Equatable implements FieldValidation {
  MinLengthValidation({@required this.field,@required  this.size});
  final String field;
  final int size;

  @override
  ValidationError validate(String value) {
    return value!=null && value.length >= size ? null: ValidationError.invalidField;
  }
  
  @override
  
  List<Object> get props => [field, size];
}