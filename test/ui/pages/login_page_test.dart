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
  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = new StreamController<String>();

    when(presenter.emailErrorStream)
        .thenAnswer((realInvocation) => emailErrorController.stream);

    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
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
}
