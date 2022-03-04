import 'package:flutter_tdd_clean_architecture/presentation/presenters/protocols/protocols.dart';
import 'package:flutter_tdd_clean_architecture/validation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationComposeite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposeite(this.validations);
  @override
  String validate({String field, String value}) {
    return null;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  ValidationComposeite sut;
  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    sut = ValidationComposeite([validation1, validation2]);
  });
  test('Should return null if all validation return null or empty', () {
    when(validation1.field).thenReturn('any_field');
    when(validation1.validate(any)).thenReturn(null);

    when(validation2.field).thenReturn('any_field');
    when(validation2.validate(any)).thenReturn(null);

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
}
