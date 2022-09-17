import 'package:flutter/material.dart';

import '../../../helpers/i18n/resources.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: R.string.confirmPassword,
        icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
      ),
    );
  }
}
