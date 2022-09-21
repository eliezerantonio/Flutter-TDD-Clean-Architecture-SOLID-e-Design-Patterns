
import 'package:flutter_tdd_clean_architecture/presentation/protocols/protocols.dart';
import 'package:test/test.dart';

class CompareFieldValidation implements FieldValidation {

  CompareFieldValidation({this.field, this.valueToCompare});


  @override
  String field ; 

  String valueToCompare ; 

  @override
  ValidationError validate(String value,) {

  return ValidationError.invalidField;

  }

}


void main() {

  CompareFieldValidation sut;


  setUp(() {

    sut= CompareFieldValidation(field: 'any_field', valueToCompare: 'any_value');
  });
  test('Should return error if value is not equal', () {
    

    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });
 
}
