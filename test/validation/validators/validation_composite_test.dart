import 'package:flutter_tdd_clean_architecture/presentation/presenters/protocols/protocols.dart';
import 'package:flutter_tdd_clean_architecture/validation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationComposeite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposeite(this.validations);
  @override
  String validate({String field, String value}) {
    String error;
    for (final validation in this.validations) {
      error = validation.validate(value);
    }
    return error;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  ValidationComposeite sut;

  void mockValidation1(String error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(String error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    sut = ValidationComposeite([validation1, validation2]);
  });
  test('Should return null if all validation return null or empty', () {
    when(validation1.field).thenReturn('any_field');
    mockValidation1(null);

    when(validation2.field).thenReturn('any_field');
    mockValidation2(null);

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
  test('Should return null if all validation return empty', () {
    mockValidation2('');

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
  test('Should return null if all validation return null or empty', () {
    mockValidation1('error_1');

    mockValidation2('error_2');

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, 'error_1');
  });
}
