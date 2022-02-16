import 'package:flutter/material.dart';

import '../../components/componets.dart';
import '../pages.dart';

class LoginPage extends StatelessWidget {
  const LoginPage(this.presenter);

  final LoginPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            Headline1("Login"),
            Padding(
              padding: const EdgeInsets.all(32),
              child: StreamBuilder<String>(
                  stream: presenter.emailErrorStream,
                  builder: (context, snapshot) {
                    return Form(
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: presenter.validateEmail,
                            decoration: InputDecoration(
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data,
                              labelText: 'Email',
                              icon: Icon(Icons.email,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            child: StreamBuilder(
                                stream: presenter.passwordErrorStream,
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    obscureText: true,
                                    onChanged: presenter.validatePassword,
                                    decoration: InputDecoration(
                                      labelText: 'Senha',
                                      errorText: snapshot.data,
                                      icon: Icon(Icons.lock,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                  );
                                }),
                          ),
                          ElevatedButton(
                            onPressed: null,
                            child: Text("Senha".toUpperCase()),
                          ),
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
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
