
import 'package:flutter_tdd_clean_architecture/presentation/protocols/protocols.dart';
import 'package:flutter_tdd_clean_architecture/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {

  CompareFieldsValidation sut;

  setUp(() {

    sut= CompareFieldsValidation(field: 'any_field', fieldToCompare: 'other_field');
  });

  test('Should return error if values are not equal', () {

    final formData ={'any_field':'any_value','other_field':'other_field'};
    expect(sut.validate(formData), ValidationError.invalidField);
  });
  
   test('Should return null on invalid cases', () {

    expect(sut.validate({'any_field':'any_value',}), null);
    expect(sut.validate({'other_field':'other_field'}), null);
    expect(sut.validate({}), null);
  });


  test('Should return null if values are equal', () {
   
   final formData ={'any_field':'any_value','other_field':'any_value'};
    expect(sut.validate(formData), null);

  });
 
}
