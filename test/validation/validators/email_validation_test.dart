import 'package:flutter_tdd_clean_architecture/validation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';

class EmailValidation implements FieldValidation {
  final String field;
  EmailValidation(this.field);

  String validate(String value) {
    return null;
  }
}

void main() {
  EmailValidation sut;
  setUp(() {
    sut = EmailValidation('any_field');
  });

  ///se nao tem valor
  test('Should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, null);
  });
  test('Should return null if email is null', () {
    final error = sut.validate(null);

    expect(error, null);
  });
}
