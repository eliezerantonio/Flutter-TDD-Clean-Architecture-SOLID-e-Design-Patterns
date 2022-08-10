import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/ui_error.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<UIError>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
          decoration: InputDecoration(
            errorText: snapshot.hasData ? snapshot.data.description : null,
            labelText: 'Email',
            icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
          ),
        );
      },
    );
  }
}
