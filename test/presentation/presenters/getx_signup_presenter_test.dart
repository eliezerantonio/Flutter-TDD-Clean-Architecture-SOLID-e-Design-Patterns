import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/ui_error.dart';
import 'package:flutter_tdd_clean_architecture/presentation/presenters/presenters.dart';
import 'package:flutter_tdd_clean_architecture/presentation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  ValidationSpy validation;
  GetxSignUpPresenter sut;
  String email;
  String name;
  String password;
  String passwordConfirmation;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(validation: validation);
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    mockValidation();
  });

//email

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
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
    sut.validateName(name);
    verify(validation.validate(field: 'name', value: name)).called(1);
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
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should call validation with correct password', () {
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', value: password)).called(1);
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
    sut.validatePasswordConfirmation(passwordConfirmation);
    verify(validation.validate(field: 'passwordConfirmation', value: passwordConfirmation)).called(1);
  });

  test('Should call validation with correct passwordConfirmation', () {
    sut.validatePasswordConfirmation(passwordConfirmation);
    verify(validation.validate(field: 'passwordConfirmation', value: passwordConfirmation)).called(1);
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
}
