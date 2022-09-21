import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/errors/errors.dart';
import '../../../helpers/i18n/resources.dart';
import '../../pages.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.nameErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validateName,
            decoration: InputDecoration(
              labelText: R.string.name,
              errorText: !snapshot.hasData ? null : snapshot.data.description,
              icon: Icon(Icons.person,
                  color: Theme.of(context).primaryColorLight),
            ),
          );
        });
  }
}
