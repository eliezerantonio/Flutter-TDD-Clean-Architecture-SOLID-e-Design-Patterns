import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/domain_error.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:flutter_tdd_clean_architecture/presentation/presenters/presenters.dart';
import 'package:flutter_tdd_clean_architecture/presentation/presenters/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  ValidationSpy validation;
  AuthenticationSpy authentication;
  StreamLoginPresenter sut;
  String email;
  String password;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  void mockAuthentication({String field, String value}) {
    mockAuthenticationCall()
        .thenAnswer((_) => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(
        validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });
  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit  if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });
  test('Should emit  null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call validation with correct password', () {
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', value: password)).called(1);
  });
  test('Should call validation with correct password', () {
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails ', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });
  test('Should emit password error if validation fails ', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

//somente o email vai tar com error, espero que o meu email stream retorna r erro
  test('Should emit password error if validation fails ', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });
  test('Should emit password error if validation fails ', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });
  test('Should call Authentication with correct values ', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authentication
            .auth(AuthenticationParams(email: email, secret: password)))
        .called(1);
  });
  test('Should emit currect events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    await sut.auth();
  });

  test('Should emit currect event on InvalidCredentialError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, 'Crendenciais invalidos')));
    await sut.auth();
  });
  test('Should emit currect event on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, 'Deu errado, tente novamente')));
    await sut.auth();
  });
  test('Should not emit efter dispose', () async {
    expectLater(sut.emailErrorStream, neverEmits(null));

    sut.dispose();
    sut.validateEmail(email);
  });
}
