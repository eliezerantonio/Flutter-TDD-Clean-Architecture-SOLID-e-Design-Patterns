import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/componets.dart';
import '../pages.dart';
import 'components/components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(this.presenter);

  final LoginPresenter presenter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter.isLoadingStream.listen(
          (isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          },
        );

        widget.presenter.mainErrroStream.listen((error) {
          if (error != null) {
            showErrorMessage(context, error);
          }
        });

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginHeader(),
              Headline1("Login"),
              Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_)=>widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            child: StreamBuilder(
                                stream: widget.presenter.passwordErrorStream,
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    obscureText: true,
                                    onChanged: widget.presenter.validatePassword,
                                    decoration: InputDecoration(
                                      labelText: 'Senha',
                                      errorText: snapshot.data?.isEmpty == true
                                          ? null
                                          : snapshot.data,
                                      icon: Icon(Icons.lock,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                  );
                                }),
                          ),
                          StreamBuilder<bool>(
                              stream: widget.presenter.isFormValidStream,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                  onPressed: snapshot.data == true
                                      ? widget.presenter.auth
                                      : null,
                                  child: Text("Senha".toUpperCase()),
                                );
                              }),
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
        );
      }),
    );
  }
}
