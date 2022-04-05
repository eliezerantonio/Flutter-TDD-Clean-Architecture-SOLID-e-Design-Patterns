import '../../../main/builders/builders.dart';

import '../../../presentation/presenters/protocols/protocols.dart';
import '../../../validation/protocols/protocols.dart';
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
