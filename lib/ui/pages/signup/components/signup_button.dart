import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:provider/provider.dart';

import '../../../helpers/i18n/resources.dart';

class SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data == true ? presenter.signUp : null,
            child: Text(R.string.addAccount),
          );
        });
  }
}
