import 'package:flutter/material.dart';

import '../../components/componets.dart';
import '../../helpers/i18n/resources.dart';
import 'components/components.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currectFocus = FocusScope.of(context);
      if (!currectFocus.hasPrimaryFocus) {
        currectFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(builder: (context) {
        return GestureDetector(
          onTap: _hideKeyboard,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1("Login"),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    child: Column(
                      children: [
                        NameInput(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: EmailInput(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 32),
                          child: PasswordInput(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 32),
                          child: PasswordConfirmationInput(),
                        ),
                        SignupButton(),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.exit_to_app,
                              color: Theme.of(context).primaryColor),
                          label: Text(
                            R.string.login,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
