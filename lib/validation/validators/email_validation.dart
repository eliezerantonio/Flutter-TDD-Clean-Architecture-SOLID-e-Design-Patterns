import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;
  EmailValidation(this.field);

  ValidationError validate(String value) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);

    return isValid ? null : ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field];
}
