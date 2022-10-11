import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/componets.dart';
import '../../components/reload_screen.dart';
import '../../helpers/i18n/i18n.dart';
import 'components/components.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  const SurveysPage(this.presenter);
  @override
  Widget build(BuildContext context) {
 presenter.loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
      ),
      body: Builder(builder: (context) {

        presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          },
        ); 
        
        presenter.isSessionExpiredStream.listen((isExpired) {
            if (isExpired == true) {
              Get.offAllNamed('/login');
            } 
          },
        );

        presenter.navigateToStream.listen((page) {

          if(page?.isNotEmpty==true){
            Get.toNamed(page);
          }
        });
      
      
        return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.loadSurveysStrem,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(error:snapshot.error, reload:presenter.loadData,);
              }
              if (snapshot.hasData) {
                return Provider(
                  create:(_)=>presenter,
                  child: SurveyItems(snapshot.data));
              }

              return Container();
            });
      }),
    );
  }
}
