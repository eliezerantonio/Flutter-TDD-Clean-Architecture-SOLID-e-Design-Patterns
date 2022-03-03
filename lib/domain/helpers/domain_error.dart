enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Crendenciais invalidos';
      case DomainError.unexpected:
        return 'Deu errado, tente novamente';
        break;
      default:
        return '';
    }
  }
}
