import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '/main/factories/factories.dart';
import 'ui/components/componets.dart';
import 'ui/helpers/i18n/resources.dart';

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
   
    final routeObserver=Get.put<RouteObserver>(RouteObserver<PageRoute>()); 
    
    return GetMaterialApp(
      title: '4Dev',
      navigatorObservers:[routeObserver],
      debugShowCheckedModeBanner: false,
      theme: makeAppATheme(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeSplashPage, transition: Transition.fade),
        GetPage(name: '/login', page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(name: '/signup', page: makeSignUpPage, transition: Transition.fadeIn),
        GetPage(name: '/surveys',page: makeSurveysPage,transition: Transition.fadeIn),
        GetPage(name: '/survey_result/:survey_id',page: makeSurveyResultPage,),
      ],
    );
  }
}
