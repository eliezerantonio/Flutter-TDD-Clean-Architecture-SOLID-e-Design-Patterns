import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/ui_error.dart';
import 'package:provider/provider.dart';

import '../../../helpers/i18n/resources.dart';


class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return TextFormField(
          keyboardType: TextInputType.emailAddress,
          
          decoration: InputDecoration(
            labelText: R.string.email,
            icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
          ),
        );
  }
}
