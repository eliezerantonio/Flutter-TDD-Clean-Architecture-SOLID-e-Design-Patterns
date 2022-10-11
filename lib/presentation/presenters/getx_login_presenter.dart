import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';

import '../../domain/helpers/helpers.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController with LoadingManager,NavigationManager, FormManager,UIErrorManager implements LoginPresenter {
  GetxLoginPresenter({
    @required this.authentication,
    @required this.validation,
    @required this.saveCurrentAccount,
  });

  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;
  String _email;
  String _password;
  var _emailError = Rx<UIError>(null);
  var _passwordError = Rx<UIError>(null);


  Stream<UIError> get emailErrorStream => _emailError.stream;

  Stream<UIError> get passwordErrorStream => _passwordError.stream;


  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(
      'email',
    );
    _validadeForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(
      'password',
    );
    _validadeForm();
  }

  UIError _validateField(
    String field,
  ) {
    final formData = {
      'email': _email,
      'password': _password,
    };

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
    isFormValid = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await authentication
          .auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);
      navigateTo = "/surveys";
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;

        default:
          mainError = UIError.unexpected;
      }
      isLoading = false;
    }
  }

  @override
  void goToSignUp() {
    navigateTo = "/signup";
  }
}
