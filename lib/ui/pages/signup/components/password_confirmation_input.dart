import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:provider/provider.dart';

import '../../../helpers/errors/errors.dart';
import '../../../helpers/i18n/resources.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.passwordConfirmationErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            obscureText: true,
            onChanged: presenter.validatePasswordConfirmation,
            decoration: InputDecoration(
              labelText: R.string.confirmPassword,
              errorText: !snapshot.hasData ? null : snapshot.data.description,
              icon:
                  Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
            ),
          );
        });
  }
}
