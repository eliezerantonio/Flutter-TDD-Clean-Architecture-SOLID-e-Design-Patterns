import 'package:flutter/foundation.dart';
import 'package:flutter_tdd_clean_architecture/presentation/presenters/protocols/protocols.dart';
import 'package:flutter_tdd_clean_architecture/validation/protocols/protocols.dart';
import 'package:flutter_tdd_clean_architecture/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;

  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  FieldValidationSpy validation3;

  void mockValidation1(String error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(String error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation3(String error) {
    when(validation3.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('other_field');
    mockValidation1(null);

    validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    mockValidation2(null);

    validation3 = FieldValidationSpy();
    when(validation3.field).thenReturn('any_field');
    mockValidation3(null);
    sut = ValidationComposite([validation1, validation2, validation3]);
  });
  test('Should return null if all validation return null or empty', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
  test('Should return null if all validation return empty', () {
    mockValidation2('');

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
  test('Should return first error', () {
    mockValidation1('error_1');

    mockValidation2('error_2');

    mockValidation3('error_3');

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, 'error_3');
  });
}
