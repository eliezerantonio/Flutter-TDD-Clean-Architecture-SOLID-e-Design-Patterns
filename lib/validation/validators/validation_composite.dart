import 'package:flutter/foundation.dart';

import '../../presentation/presenters/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);
  @override
  String validate({@required String field, @required String value}) {
    String error;

    for (final validation in this.validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if (error?.isNotEmpty == true) {
        return error;
      }
    }
    return error;
  }
}
