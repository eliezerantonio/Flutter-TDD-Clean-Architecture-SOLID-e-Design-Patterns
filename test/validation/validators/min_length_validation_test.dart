
import 'package:flutter_tdd_clean_architecture/presentation/protocols/protocols.dart';
import 'package:flutter_tdd_clean_architecture/validation/validators/validators.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';



void main() {

  MinLengthValidation sut;


  setUp(() {

    sut= MinLengthValidation(field: 'any_field', size: 6);
  });
  test('Should return error if value is empty', () {
    

    expect(sut.validate({'any_field':''}), ValidationError.invalidField);
  });
  test('Should return error if value is null', () {
    

    expect(sut.validate({'any_field':null}), ValidationError.invalidField);
  }); 
  
  test('Should return error if value is less then size', () {
    

    expect(sut.validate({'any_field':faker.randomGenerator.string(5,min:1)}), ValidationError.invalidField);
  }); 
  test('Should return null if value is equal then min size', () {
    

    expect(sut.validate({'any_field':faker.randomGenerator.string(6,min:6)}), null);
  });
  
  test('Should return null if value is bigger then min size', () {
    

    expect(sut.validate({'any_field':faker.randomGenerator.string(10,min:6)}), null);
  });
}
