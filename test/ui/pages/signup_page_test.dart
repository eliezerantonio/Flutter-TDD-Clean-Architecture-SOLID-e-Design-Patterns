import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/errors.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> nameErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;
  StreamController<String> navigateToController;

  void initStreams() {
    nameErrorController = new StreamController<UIError>();
    emailErrorController = new StreamController<UIError>();
    passwordErrorController = new StreamController<UIError>();
    mainErrorController = new StreamController<UIError>();
    passwordConfirmationErrorController = new StreamController<UIError>();
    isFormValidController=new StreamController<bool>();
    isLoadingController= new StreamController<bool>();
    navigateToController= new StreamController<String>();
  }

  void mockStreams() {
    when(presenter.nameErrorStream).thenAnswer((_) => nameErrorController.stream);


    when(presenter.emailErrorStream) .thenAnswer((_) => emailErrorController.stream);

    when(presenter.passwordErrorStream) .thenAnswer((_) => passwordErrorController.stream);

    when(presenter.passwordConfirmationErrorStream) .thenAnswer((_) => passwordConfirmationErrorController.stream);
    
    when(presenter.isFormValidStream) .thenAnswer((_) => isFormValidController.stream);

    when(presenter.isLoadingStream) .thenAnswer((_) => isLoadingController.stream);
    
    when(presenter.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();
    final sigUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter)),
        GetPage(  name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
      ],
    );
    await tester.pumpWidget(sigUpPage);
  }

  tearDown(() {
    closeStreams();
  });


  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar Senha'), password);
    verify(presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Should present error if email Error',(WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo invalido'), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),findsWidgets);
  });

  testWidgets('Should present error if name Error',(WidgetTester tester) async {
    await loadPage(tester);

    nameErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo invalido'), findsOneWidget);

    nameErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    nameErrorController.add(null);
    await tester.pump();
    expect( find.descendant(of: find.bySemanticsLabel('Nome'), matching:find.byType(Text)),findsWidgets);
  });

  testWidgets('Should present error if Password Error',(WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo invalido'), findsOneWidget);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)), findsWidgets);
  });

  testWidgets('Should present error if Password Error',(WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo invalido'), findsOneWidget);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),findsWidgets);
  });

  testWidgets('Should present error if Confirm Password Error',(WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo invalido'), findsOneWidget);

    passwordConfirmationErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    passwordConfirmationErrorController.add(null);
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Confirmar Senha'), matching: find.byType(Text)),findsWidgets);
  });

    testWidgets('Should enable button if form is valid',(WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      final button =tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Should disabled button if form is invalid',(WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);
      await tester.pump();

      final button =tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, null);
    });


    testWidgets('Sould call SingUp on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    final button=find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.signUp()).called(1);

    });

    testWidgets('Should presenter loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });


  testWidgets('Should present error message if singnup fails', (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.emailInUse);
    await tester.pump();

    expect(find.text('Email ja esta ser utilizado'), findsOneWidget);
  });


  testWidgets('Should present error message if signUp throw', (WidgetTester tester)async{

    await loadPage(tester);

    mainErrorController.add(UIError.unexpected);
    await tester.pump();

    expect(find.text('Deu errado, tente novamente'), findsOneWidget);


  });

   testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/signup');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/signup');
  });
  

   testWidgets('Should call Login on link click', (WidgetTester tester) async{
    await loadPage(tester);

    final button = find.text('Login');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToLogin()).called(1);
   });
}
