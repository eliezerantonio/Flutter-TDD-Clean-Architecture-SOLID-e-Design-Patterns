import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/componets.dart';
import '../../helpers/errors/errors.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class LoginPage extends StatelessWidget  with KeyboardManager, LoadingManager, UIErrorManager,NavigationManager{
  const LoginPage(this.presenter);

  final LoginPresenter presenter;

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
                Headline1("Login"),
                Padding(
                    padding: const EdgeInsets.all(32),
                    child: Provider(
                      create: (_) => presenter,
                      child: Form(
                        child: Column(
                          children: [
                            EmailInput(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8, bottom: 32),
                              child: PasswordInput(),
                            ),
                            LoginButton(),
                            TextButton.icon(
                              onPressed: presenter.goToSignUp,
                              icon: Icon(Icons.person,
                                  color: Theme.of(context).primaryColor),
                              label: Text(
                                R.string.addAccount,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
