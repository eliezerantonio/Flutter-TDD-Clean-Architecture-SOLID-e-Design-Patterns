import 'package:flutter/material.dart';

import '../../../helpers/i18n/resources.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: R.string.name,
        icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
      ),
    );
  }
}
