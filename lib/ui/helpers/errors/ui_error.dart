enum UIError { unexpected, invalidCredentials, requiredField, invalidField }

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return 'Crendenciais invalidos';
      case UIError.requiredField:
        return 'Campo obrigatorio';
      case UIError.invalidField:
        return 'Campo invalido';
      case UIError.unexpected:
        return 'Deu errado, tente novamente';
        break;
      default:
        return '';
    }
  }
}
