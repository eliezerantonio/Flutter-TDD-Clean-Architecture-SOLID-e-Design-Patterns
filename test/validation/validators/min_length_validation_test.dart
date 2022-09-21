import 'package:flutter_tdd_clean_architecture/presentation/protocols/validation.dart';
import 'package:flutter_tdd_clean_architecture/validation/protocols/field_validation.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:faker/faker.dart';

class MinLengthValidation implements FieldValidation {
  MinLengthValidation({@required this.field,@required  this.size});
  final String field;
  final int size;

  @override
  ValidationError validate(String value) {
    return value?.length==size?null: ValidationError.invalidField;
  }
}

void main() {

  MinLengthValidation sut;


  setUp(() {

    sut= MinLengthValidation(field: 'any_field', size: 6);
  });
  test('Should return error if value is empty', () {
    

    expect(sut.validate('value'), ValidationError.invalidField);
  });
  test('Should return error if value is null', () {
    

    expect(sut.validate(null), ValidationError.invalidField);
  }); 
  
  test('Should return error if value is less then size', () {
    

    expect(sut.validate(faker.randomGenerator.string(5,min:1)), ValidationError.invalidField);
  }); 
  test('Should return null if value is equal then min size', () {
    

    expect(sut.validate(faker.randomGenerator.string(6,min:6)), null);
  });
}
