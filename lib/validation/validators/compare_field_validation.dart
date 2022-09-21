import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {

  CompareFieldsValidation({this.field, this.fieldToCompare});


  @override
  String field ; 

  String fieldToCompare ; 

  @override
  ValidationError validate(Map input,) => input[field] !=null &&   input[fieldToCompare]!=null &&  input[field] !=input[fieldToCompare] ?    ValidationError.invalidField:null;
  
  @override
  List<Object> get props => [field, fieldToCompare];

  

}