import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import '/factories/factories.dart';
import 'ui/components/componets.dart';
import 'utils/i18n/resources.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  R.load(Locale('en', 'US'));
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
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeSplashPage, transition: Transition.fade),
        GetPage(
            name: '/login', page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(
            name: '/surveys',
            page: () => Scaffold(body: Text("Enquetes")),
            transition: Transition.fadeIn),
      ],
    );
  }
}
