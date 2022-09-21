import 'package:flutter_tdd_clean_architecture/presentation/protocols/validation.dart';
import 'package:flutter_tdd_clean_architecture/validation/protocols/field_validation.dart';
import 'package:test/test.dart';

class MinLengthValidation implements FieldValidation {
  MinLengthValidation({this.field, this.size});
  final String field;
  final int size;

  @override
  ValidationError validate(String value) {
    return ValidationError.invalidField;
  }
}

void main() {

  MinLengthValidation sut;


  setUp(() {

    sut= MinLengthValidation(field: 'any_field', size: 6);
  });
  test('Should return error if value is empty', () {
    

    expect(sut.validate('value'), ValidationError.invalidField);
  });
  test('Should return error if value is null', () {
    

    expect(sut.validate(null), ValidationError.invalidField);
  });
}
