import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;

  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<String> mainErrroController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void initStreams() {
    emailErrorController = new StreamController<String>();
    passwordErrorController = new StreamController<String>();
    mainErrroController = new StreamController<String>();
    isFormValidController = new StreamController<bool>();
    isLoadingController = new StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);

    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.mainErrroStream)
        .thenAnswer((_) => mainErrroController.stream);

    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);

    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrroController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();

    initStreams();
    mockStreams();

    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets(
    'Should load with correcrt initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

      //procurando todos filhos de um componente
      final emailTextChildren = find.descendant(
          of: find.bySemanticsLabel("Email"), matching: find.byType(Text));

      expect(
        emailTextChildren,
        findsOneWidget,
        reason:
            'When  a TextFormField has only one text child, means it has no error, since one of the childs is always th hint text',
      );

      //fazendo o mesmo na passwrod
      final passwordTextChildren = find.descendant(
          of: find.bySemanticsLabel("Senha"), matching: find.byType(Text));

      expect(passwordTextChildren, findsOneWidget,
          reason:
              'when a TextFormField has only one text child, means it has no errors, since one of the childs is always th hint text');

      //testando button

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(button.onPressed, null);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'Should call validate with correct values',
    (WidgetTester tester) async {
      await loadPage(tester);
//test email
      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel("Email"), email);

      verify(presenter.validateEmail(email));

//test password
      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel("Senha"), password);

      verify(presenter.validatePassword(password));
    },
  );

  testWidgets(
    'Should present error if email is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('any error');
      await tester.pump(); //reload

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets('Should present no error if email is valid ',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(null);
    await tester.pump(); //reload

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present no error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);
    emailErrorController.add('');
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget);
  });

// validando a   password

  testWidgets('should present no error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if password is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(null);
    await tester.pump(); //reaload

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present no error if password is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add('');
    await tester.pump(); //reload;

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  ///habilitar botao se formulario for valido
  ///
  testWidgets('Should enabled button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);

    await tester.pump(); //reload

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disables  if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);

    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, null);
  });

  testWidgets('Should call authentication on form submit ',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    //testando acao do botao
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(presenter.auth()).called(1);
  });

  testWidgets("Should hide loading", (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present erro message', (WidgetTester tester) async {
    await loadPage(tester);

    mainErrroController.add('main error');
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });

  testWidgets('Should cloase streams on dispose', (WidgetTester tester) async {
    await loadPage(tester);

    addTearDown(() {
      verify(presenter.dispose()).called(1);
    });
  });
}
