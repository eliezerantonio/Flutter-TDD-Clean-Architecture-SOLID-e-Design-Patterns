import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tdd_clean_architecture/factories/pages/login/login_page_factory.dart';
import 'package:get/route_manager.dart';

import 'ui/components/componets.dart';
import 'ui/pages/pages.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      theme: makeAppATheme(),
      home: LoginPage(null),
      getPages: [
        GetPage(name: '/login', page: makeLoginPage),
      ],
    );
  }
}
