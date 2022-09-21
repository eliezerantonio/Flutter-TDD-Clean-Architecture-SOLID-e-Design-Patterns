import '../../presentation/protocols/protocols.dart';

class CompareFieldValidation implements FieldValidation {

  CompareFieldValidation({this.field, this.valueToCompare});


  @override
  String field ; 

  String valueToCompare ; 

  @override
  ValidationError validate(String value,) {

   return  value.contains(valueToCompare) ? null: ValidationError.invalidField;

  }

}