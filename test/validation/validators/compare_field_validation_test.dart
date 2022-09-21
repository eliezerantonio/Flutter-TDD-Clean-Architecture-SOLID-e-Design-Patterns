
import 'package:flutter_tdd_clean_architecture/presentation/protocols/protocols.dart';
import 'package:flutter_tdd_clean_architecture/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {

  CompareFieldValidation sut;

  setUp(() {

    sut= CompareFieldValidation(field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if values are not equal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });


  test('Should return null if values are equal', () {

    expect(sut.validate('any_value'), null);

  });
 
}
