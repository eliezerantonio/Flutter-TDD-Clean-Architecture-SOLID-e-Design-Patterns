import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';

import '../../domain/helpers/helpers.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController  {
  GetxSignUpPresenter({@required this.validation, });

  final Validation validation;
 
  String _email;
  String _name;
  var _emailError = Rx<UIError>(null);
  var _nameError = Rx<UIError>(null);

  var _isFormValid = false.obs;
 

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;

  Stream<bool> get isFormValidStream => _isFormValid.stream;


  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validadeForm();
  }
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validadeForm();
  }


  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);

    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;

        break;
      default:
        return null;
    }
  }

  void _validadeForm() {
    _isFormValid.value = false;
  }



}
