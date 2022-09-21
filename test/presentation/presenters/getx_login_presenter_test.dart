import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/ui_error.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:flutter_tdd_clean_architecture/presentation/presenters/presenters.dart';
import 'package:flutter_tdd_clean_architecture/presentation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  ValidationSpy validation;
  AuthenticationSpy authentication;
  GetxLoginPresenter sut;
  SaveCurrentAccountSpy saveCurrentAccount;
  String email;
  String password;
  String token;

  PostExpectation mockValidationCall(String field) => when(validation.validate(field: field == null ? anyNamed('field') : field,input: anyNamed('input')));

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  void mockAuthentication({String field, String value}) {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccounCall() =>when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccounCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();

    sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount,
        );

    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();
    mockValidation();
    mockAuthentication();
  });
  test('Should call Validation with correct email', () {
    
  final formData={'email' : email, 'password' : null};


    sut.validateEmail(email);
    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });
  test('Should emit requiredFieldError if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit  null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call validation with correct password', () {
   final formData={'email':null, 'password':password};

    sut.validatePassword(password);

    verify(validation.validate(field: 'password', input: formData)).called(1);
  });
  test('Should call validation with correct password', () {
     final formData={'email':null, 'password':password};
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit password error if validation fails ', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });
  test('Should emit password error if validation fails ', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

//somente o email vai tar com error, espero que o meu email stream retorna r erro
  test('Should disable form button if any field is invalid', () {
    mockValidation(field: 'email', value: ValidationError.invalidField);

    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should enable form button if any fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });
  test('Should call Authentication with correct values ', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authentication.auth(AuthenticationParams(email: email, secret: password))).called(1);
  });
  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });
  test('Should emit currect events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));
    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.auth();
  });

  test('Should emit currect event on InvalidCredentialError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
     expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));
    await sut.auth();
  });
  test('Should emit currect event on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    await sut.auth();
  });


  test('Should go to SignUpPage on link click', (){
    
  sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/signup')));
  sut.goToSignUp();


  });
  
  }
