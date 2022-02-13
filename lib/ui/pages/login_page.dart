import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image(
                image: AssetImage("lib/ui/assets/logo.png"),
              ),
            ),
            Text("Login".toUpperCase()),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.lock),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Entrar".toUpperCase()),
                  ),
                 TextButton.icon(onPressed: (){}, icon: Icon(Icons.person), label:Text('Criar conta') )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
