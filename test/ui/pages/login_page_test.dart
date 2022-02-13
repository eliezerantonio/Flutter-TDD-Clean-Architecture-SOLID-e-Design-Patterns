import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Should load with correcrt initial state',
    (WidgetTester tester) async {
      final loginPage = MaterialApp(home: LoginPage());
      await tester.pumpWidget(loginPage);

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
}
