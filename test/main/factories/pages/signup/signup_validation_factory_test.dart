import 'package:flutter_tdd_clean_architecture/main/factories/pages/signup/signup.dart';
import 'package:flutter_tdd_clean_architecture/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeSignUpValidations();
    expect(validations, [
      RequiredFieldValidation('name'), 
      MinLengthValidation(field:'name',size:3), 
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field:'password',size:3),
      RequiredFieldValidation('passwordConfirmation'),
      CompareFieldsValidation(field:'passwordConfirmation',fieldToCompare: 'password')
    ]);
  });
}
