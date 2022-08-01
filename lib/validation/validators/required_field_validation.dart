import 'package:equatable/equatable.dart';

import '../protocols/field_validation.dart';


class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);
  @override
  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatorio';
  }

  @override
  List<Object> get props => [field];
}
