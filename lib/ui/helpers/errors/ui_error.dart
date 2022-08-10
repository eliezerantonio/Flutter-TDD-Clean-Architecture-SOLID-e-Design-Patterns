import '../i18n/i18n.dart';

enum UIError { unexpected, invalidCredentials, requiredField, invalidField }

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return R.strings.msgInvalidCredentials;
      case UIError.requiredField:
        return R.strings.msgRequiredField;
      case UIError.invalidField:
        return R.strings.msgInvalidField;
      case UIError.unexpected:
        return R.strings.msgUnexpectedField;
        break;
      default:
        return '';
    }
  }
}
