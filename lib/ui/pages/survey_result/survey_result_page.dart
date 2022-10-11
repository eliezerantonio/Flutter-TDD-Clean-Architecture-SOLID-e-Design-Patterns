import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/ui/components/componets.dart';

import '../../helpers/i18n/i18n.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveyResultPage extends StatelessWidget {
  SurveyResultPage(this.presenter);

  final SurveyResultPresenter presenter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
      ),
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

  presenter.isSessionExpiredStream.listen((isExpired) {
            if (isExpired == true) {
              Get.offAllNamed('/login');
            } 
          },
        );
          presenter.loadData();
          return StreamBuilder<dynamic>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {


                if (snapshot.hasError) {
                return ReloadScreen(error:snapshot.error, reload:presenter.loadData,);
              }
              if (snapshot.hasData) {
                  return SurveyResult(snapshot.data);
              }
             

             return SizedBox(height: 0,);
            }
          );
        },
      ),
    );
  }
}

