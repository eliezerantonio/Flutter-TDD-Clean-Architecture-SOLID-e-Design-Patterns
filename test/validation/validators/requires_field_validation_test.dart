import 'package:flutter_test/flutter_test.dart';

abstract class FieldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);
  @override
  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatorio';
  }
}

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });
  //se tiver vazio retorna null aka success
  test('Should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  //se o campo estiver vazio retorna erro

  test('Should return error if value is  empty', () {
    expect(sut.validate(''), 'Campo obrigatorio');
  });

//se o campo estiver null retorna erro
  test('Should return error if value is  null', () {
    expect(sut.validate(null), 'Campo obrigatorio');
  });
}
