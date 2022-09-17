import 'package:flutter/material.dart';

import '../../../helpers/i18n/resources.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: R.string.password,
        icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
      ),
    );
  }
}
