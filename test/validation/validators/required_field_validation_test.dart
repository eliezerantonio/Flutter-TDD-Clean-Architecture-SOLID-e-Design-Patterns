import 'package:flutter_tdd_clean_architecture/presentation/protocols/validation.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/errors.dart';
import 'package:flutter_tdd_clean_architecture/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });
  //se tiver vazio retorna null aka success
  test('Should return null if value is not empty', () {
    expect(sut.validate({'any_field':'any_value'}), null);
  });

  //se o campo estiver vazio retorna erro

  test('Should return error if value is  empty', () {
    expect(sut.validate({'any_field':''}), ValidationError.requiredField);
  });

//se o campo estiver null retorna erro
  test('Should return error if value is  null', () {
    expect(sut.validate({'any_field':null}), ValidationError.requiredField);
  });
}
