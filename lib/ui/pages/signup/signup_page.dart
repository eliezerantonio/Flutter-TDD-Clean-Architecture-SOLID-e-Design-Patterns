import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/signup/signup_presenter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/componets.dart';
import '../../helpers/errors/ui_error.dart';
import '../../helpers/i18n/resources.dart';
import 'components/components.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage(this.presenter);

  SignUpPresenter presenter;
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
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.mainErrorStream.listen((error) {
          if (error != null) {
            showErrorMessage(context, error.description);
          }
        });

        presenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });
        return GestureDetector(
          onTap: _hideKeyboard,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1("Criar Conta"),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => presenter,
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
                            onPressed: presenter.goToLogin,
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
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
