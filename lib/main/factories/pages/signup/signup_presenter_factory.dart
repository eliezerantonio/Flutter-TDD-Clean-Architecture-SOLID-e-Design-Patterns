

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';
import 'signup_validation_factory.dart';

SignUpPresenter makeGetxSignUpPresenter() {
  return GetxSignUpPresenter(
    addAccount: makeRemoteAddAccount(),
    validation: makeSignUpValidation(),
    saveCurrentAccount: makeLocalCurrentAccount(),
  );
}
