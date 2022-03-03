
import '../protocols/field_validation.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);
  @override
  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatorio';
  }
}
