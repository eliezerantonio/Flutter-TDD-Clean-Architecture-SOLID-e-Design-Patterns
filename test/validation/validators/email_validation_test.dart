import 'package:flutter_tdd_clean_architecture/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  EmailValidation sut;
  setUp(() {
    sut = EmailValidation('any_field');
  });

  ///se nao tem valor
  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });
  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });
  test('Should return null if email is valid', () {
    expect(sut.validate('eliezer@gmail.com'), null);
  });
  test('Should return null if email is invalid', () {
    expect(sut.validate('eliezer@gmail'), null);
  });
}
