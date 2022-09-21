import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';


class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);
  @override
  ValidationError validate(Map input) {
    return input[field]?.isNotEmpty == true ? null : ValidationError.requiredField;
  }

  @override
  List<Object> get props => [field];
}
