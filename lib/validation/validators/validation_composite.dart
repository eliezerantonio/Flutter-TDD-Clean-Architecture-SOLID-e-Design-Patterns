import 'package:flutter/foundation.dart';

import '../../presentation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);
  @override
  ValidationError validate({@required String field, @required String value}) {
    ValidationError error;

    for (final validation in this.validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if (error != null) {
        return error;
      }
    }
    return error;
  }
}
