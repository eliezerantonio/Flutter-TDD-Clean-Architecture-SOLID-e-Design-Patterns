import '../i18n/i18n.dart';

enum UIError {
  unexpected,
  invalidCredentials,
  requiredField,
  invalidField,
  emailInUse
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return R.string.msgInvalidCredentials;
      case UIError.requiredField:
        return R.string.msgRequiredField;
      case UIError.invalidField:
        return R.string.msgInvalidField;
      case UIError.unexpected:
        return R.string.msgUnexpectedField;
      case UIError.emailInUse:
        return R.string.msgEmailInUse;

      default:
        return '';
    }
  }
}
