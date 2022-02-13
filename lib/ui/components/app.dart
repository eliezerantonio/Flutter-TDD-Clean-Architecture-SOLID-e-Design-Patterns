import 'package:flutter/material.dart';
import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
