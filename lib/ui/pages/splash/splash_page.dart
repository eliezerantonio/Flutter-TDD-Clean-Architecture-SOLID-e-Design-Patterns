import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/splash/splash.dart';

import '../../mixins/mixins.dart';

class SplashPage extends StatelessWidget with NavigationManager{
  const SplashPage({Key key, @required this.presenter}) : super(key: key);
  final SplashPresenter presenter;
  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      appBar: AppBar(
          title: Text("4Dev"),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(136, 14, 79, 1)),
      body: Builder(builder: (context) {
        handleNavigation(presenter.navigateToStream, clear:true);

        return Center(
            child: CircularProgressIndicator(
                color: Color.fromRGBO(136, 14, 79, 1)));
      }),
    );
  }
}
