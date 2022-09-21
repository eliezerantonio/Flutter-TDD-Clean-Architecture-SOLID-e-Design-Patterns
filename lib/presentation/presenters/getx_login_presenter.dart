import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';

import '../../domain/helpers/helpers.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  GetxLoginPresenter(
      {@required this.authentication,
      @required this.validation,
      @required this.saveCurrentAccount});

  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;
  String _email;
  String _password;
  var _emailError = Rx<UIError>(null);
  var _passwordError = Rx<UIError>(null);
  var _mainError = Rx<UIError>(null);
  var _navigateTo = RxString('');
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;

  Stream<UIError> get passwordErrorStream => _passwordError.stream;

  Stream<UIError> get mainErrorStream => _mainError.stream;

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;

  Stream<bool> get isFormValidStream => _isFormValid.stream;


  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email',);
    _validadeForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password', );
    _validadeForm();
  }

  UIError _validateField(String field, ) {
    final formData={'email': _email, 'password': _password,};

    final error = validation.validate(field: field, input: formData);

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
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    try {
      _mainError.value=null;
      _isLoading.value = true;
      final account = await authentication.auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);
      _navigateTo.value = "/surveys";
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;

        default:
          _mainError.value = UIError.unexpected;
      }
      _isLoading.value = false;
    }
  }

  void dispose() {}
  
  @override
  void goToSignUp() {
      _navigateTo.value = "/signup";
  }
}
