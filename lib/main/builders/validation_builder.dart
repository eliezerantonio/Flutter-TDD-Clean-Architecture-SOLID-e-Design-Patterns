import 'package:flutter_tdd_clean_architecture/validation/validators/validators.dart';

import '../../validation/protocols/field_validation.dart';

class ValidationBuilder {
  
  static ValidationBuilder _instance;
  String fieldName;
  List<FieldValidation> validations = [];
  ValidationBuilder._();

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._();
    _instance.fieldName = fieldName;

    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));

    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(fieldName));

    return this;
  }

  ValidationBuilder sameAs(String fieldToCompare) {
    validations.add(CompareFieldsValidation(field: fieldName, fieldToCompare: fieldToCompare));
    return this;
  }

  ValidationBuilder min(int size) {
    validations.add(MinLengthValidation(field:fieldName, size:size));

    return this;
  }

  List<FieldValidation> build() => validations;
}
