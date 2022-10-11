import 'package:flutter/foundation.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:get/state_manager.dart';

import '../../domain/helpers/helpers.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/signup/signup_presenter.dart';
import '../mixins/mixins.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController with FormManager, LoadingManager,NavigationManager implements SignUpPresenter {
  GetxSignUpPresenter(
      {@required this.validation, this.addAccount, this.saveCurrentAccount});

  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _name;
  String _password;
  String _passwordConfirmation;

  var _emailError = Rx<UIError>(null);
  var _nameError = Rx<UIError>(null);
  var _mainError = Rx<UIError>(null);
  var _passwordError = Rx<UIError>(null);
  var _passwordConfirmationError = Rx<UIError>(null);
 

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get passwordConfirmationErrorStream =>_passwordConfirmationError.stream;

  Stream<UIError> get mainErrorStream => _mainError.stream;


  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email', );
    _validadeForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField( 'name',) ;
    _validadeForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField( 'password', );
    _validadeForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField( 'passwordConfirmation',);
    _validadeForm();
  }

  UIError _validateField(String field, ) {
    final formData={'name':_name,'email': _email, 'password': _password, 'passwordConfirmation':_passwordConfirmation};
    final error = validation.validate(field: field, input: formData);

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
    isFormValid = _emailError.value == null
     && _passwordError.value == null 
     && _passwordConfirmationError.value == null 
     && _nameError.value == null
     && _email != null 
     &&  _name != null 
     &&_password != null
     && _passwordConfirmation != null;
  }

  Future<void> signUp() async {
   
   try {
      _mainError.value=null;
      isLoading=true;
    final account = await addAccount.add(AddAccountParams(
        name: _name,
        email: _email,
        password: _password,
        passwordConfirmation: _passwordConfirmation));
        
    await saveCurrentAccount.save(account);

 navigateTo = "/surveys";
   }on DomainError catch (error) {

    switch(error){
      case DomainError.invalidCredentials:_mainError.value=UIError.invalidCredentials;break;
      default:_mainError.value=UIError.unexpected;
    }
    isLoading=false;
     
   }
  }
  
  @override
  void goToLogin() {
  navigateTo = "/login";
  }
}
