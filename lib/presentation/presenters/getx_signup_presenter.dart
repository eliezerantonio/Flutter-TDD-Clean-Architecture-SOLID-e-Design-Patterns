import 'package:flutter/foundation.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:get/state_manager.dart';

import '../../ui/helpers/errors/errors.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController  {
  GetxSignUpPresenter({@required this.validation,this.addAccount });

  final Validation validation;
  final AddAccount addAccount;
 
  String _email;
  String _name;
  String _password;
  String _passwordConfirmation;

  var _emailError = Rx<UIError>(null);
  var _nameError = Rx<UIError>(null);
  var _passwordError = Rx<UIError>(null);
  var _passwordConfirmationError = Rx<UIError>(null);

  var _isFormValid = false.obs;
 

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;

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
   void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validadeForm();
  }
  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(field: 'passwordConfirmation', value: passwordConfirmation);
    _validadeForm();
  }


  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);

    switch (error) {

      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }

  }

      void _validadeForm() {

        _isFormValid.value = _emailError.value == null 
        && _passwordError.value == null 
        && _passwordConfirmationError.value == null
        && _nameError.value == null 
        && _email != null 
        && _name != null 
        && _password != null
        && _passwordConfirmation != null;

      }

      Future<void> signUp()async{
        await addAccount.add(AddAccountParams(name:_name, email: _email, password: _password, passwordConfirmation: _passwordConfirmation));

      }

}
