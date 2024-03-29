import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/signup/signup_presenter.dart';
import 'package:provider/provider.dart';

import '../../components/componets.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';

class SignUpPage extends StatelessWidget  with KeyboardManager,LoadingManager, UIErrorManager,NavigationManager {
  SignUpPage(this.presenter);

  SignUpPresenter presenter;
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Builder(builder: (context) {
       handleLoading(context, presenter.isLoadingStream);

       handleMainError(context, presenter.mainErrorStream);

       handleNavigation(presenter.navigateToStream, clear:true);
       
        return GestureDetector(
          onTap: ()=>hideKeyboard(context),
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
