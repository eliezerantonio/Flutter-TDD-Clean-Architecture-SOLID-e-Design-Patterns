import '../../../main/builders/builders.dart';

import '../../../presentation/protocols/protocols.dart';
import '../../../presentation/protocols/protocols.dart';
import '../../../validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().build()
  
  ];
}
