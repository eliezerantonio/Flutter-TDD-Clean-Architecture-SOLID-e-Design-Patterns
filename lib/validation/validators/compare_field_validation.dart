import '../../presentation/protocols/protocols.dart';

class CompareFieldValidation implements FieldValidation {

  CompareFieldValidation({this.field, this.fieldToCompare});


  @override
  String field ; 

  String fieldToCompare ; 

  @override
  ValidationError validate(Map input,) => input[field] !=null &&   input[fieldToCompare]!=null &&  input[field] !=input[fieldToCompare] ?    ValidationError.invalidField:null;

  

}