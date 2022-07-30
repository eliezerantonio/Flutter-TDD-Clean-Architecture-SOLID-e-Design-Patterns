import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/splash/splash.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key, @required this.presenter}) : super(key: key);
  final SplashPresenter presenter;
  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      appBar: AppBar(
        title: Text("4Dev"),
      ),
      body: Builder(builder: (context) {
        presenter.navigateToStream.listen((page) {
          //caso receba pagina nula

          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });

        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}