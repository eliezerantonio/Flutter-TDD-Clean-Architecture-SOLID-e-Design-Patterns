import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/field_validation.dart';


class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);
  @override
  ValidationError validate(String value) {
    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }

  @override
  List<Object> get props => [field];
}
