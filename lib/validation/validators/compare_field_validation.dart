import '../../presentation/protocols/protocols.dart';

class CompareFieldValidation implements FieldValidation {

  CompareFieldValidation({this.field, this.fieldToCompare});


  @override
  String field ; 

  String fieldToCompare ; 

  @override
  ValidationError validate(Map input,) {

   return  input[field].contains(input[fieldToCompare]) ? null: ValidationError.invalidField;

  }

}