import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/componets.dart';
import '../pages.dart';
import 'components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage(this.presenter);

  final LoginPresenter presenter;

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
        presenter.isLoadingStream.listen(
          (isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          },
        );

        presenter.mainErrorStream.listen((error) {
          if (error != null) {
            showErrorMessage(context, error);
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
                              onPressed: () {},
                              icon: Icon(Icons.person,
                                  color: Theme.of(context).primaryColor),
                              label: Text(
                                'Criar conta',
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
