import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/ui_error.dart';
import 'package:flutter_tdd_clean_architecture/presentation/presenters/presenters.dart';
import 'package:flutter_tdd_clean_architecture/presentation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}
class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  ValidationSpy validation;
   AddAccountSpy addAccount;
  GetxSignUpPresenter sut;
  SaveCurrentAccountSpy saveCurrentAccount;
  String email;
  String name;
  String password;
  String passwordConfirmation;
  String token;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      input: anyNamed('input')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }
  PostExpectation  mockAddAccountCall()=> when(addAccount.add(any));

  void mockAddAccount(){
    mockAddAccountCall().thenAnswer((_)async=>AccountEntity(token));
  }
  PostExpectation mockSaveCurrentAccounCall() =>
      when(saveCurrentAccount.save(any));

    void mockSaveCurrentAccountError() {
    mockSaveCurrentAccounCall().thenThrow(DomainError.unexpected);
  }
 PostExpectation mockAuthenticationCall() => when(addAccount.add(any));
  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }
  setUp(() {
    validation = ValidationSpy();
    addAccount=AddAccountSpy();
    saveCurrentAccount=SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(validation: validation,addAccount:addAccount,saveCurrentAccount:saveCurrentAccount);
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    token=faker.guid.guid();
    mockValidation();
    mockAddAccount();
  });

//email

  test('Should call Validation with correct email', () {

      final formData={'name': null, 'email' : email, 'password' : null, 'passwordConfirmation' : null};

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

//name

  test('Should call Validation with correct name', () {
     final formData={'name': name, 'email' : null, 'password' : null, 'passwordConfirmation' : null};

    sut.validateName(name);
    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });
  test('Should emit requiredFieldError if name is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));

    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit  null if validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });
//password

  test('Should call validation with correct password', () {
         final formData={'name': null, 'email' : null, 'password' : password, 'passwordConfirmation' : null};

    sut.validatePassword(password);
    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should call validation with correct password', () {
   final formData={'name': null, 'email' : null, 'password' : password, 'passwordConfirmation' : null};

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

  //passwordConfirmation

  test('Should call validation with correct passwordConfirmation', () {
      final formData={'name': null, 'email' : null, 'password' : null, 'passwordConfirmation' : passwordConfirmation};

    sut.validatePasswordConfirmation(passwordConfirmation);
    verify(validation.validate(field: 'passwordConfirmation', input: formData)).called(1);
  });

  test('Should call validation with correct passwordConfirmation', () {
    final formData={'name': null, 'email' : null, 'password' : null, 'passwordConfirmation' : passwordConfirmation};

    sut.validatePasswordConfirmation(passwordConfirmation);
    verify(validation.validate(field: 'passwordConfirmation', input: formData)).called(1);
  });

  test('Should emit passwordConfirmation error if validation fails ', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });
  test('Should emit passwordConfirmation error if validation fails ', () {
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

//

  test('Should enable form button if any fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);

  });

  test('Should call AddAccount with correct values ', () async {
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(addAccount.add(AddAccountParams(name:name,email: email, password: password,passwordConfirmation:passwordConfirmation))).called(1);
  });

  test("Should call SaveCurrentAccount with corret value",()async{

  await sut.signUp();
  verify(saveCurrentAccount.save(AccountEntity(token))).called(1);

  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', ()async{
    mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    

    await sut.signUp();
  });


  test('Should emit correct events on AddAccount success',()async{
      sut.validateEmail(email);
      sut.validateName(name);
      sut.validatePassword(password);
      sut.validatePasswordConfirmation(passwordConfirmation);
      expectLater(sut.isLoadingStream, emits(true));

    await sut.signUp();
  });

  test('Should change page on success', () async {

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.signUp();

  });

  test('Should emit currect event on InvalidCredentialError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
     sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));
    await sut.signUp();
  });
  

test('Should emit currect event on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    await sut.signUp();
  });

   test('Should go to LoginPage on link click', (){
    
  sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
  sut.goToLogin();


  });
}




