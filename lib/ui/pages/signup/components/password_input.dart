import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/errors/errors.dart';
import '../../../helpers/i18n/resources.dart';
import '../signup.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            obscureText: true,
            onChanged: presenter.validatePassword,
            decoration: InputDecoration(
              labelText: R.string.password,
              errorText: !snapshot.hasData ? null : snapshot.data.description,
              icon:
                  Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
            ),
          );
        });
  }
}
