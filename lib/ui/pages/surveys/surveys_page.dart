import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';

import '../../components/componets.dart';
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
          if (isLoading==true) {
            showLoading(context);
          }else{
            hideLoading(context);
          }
        });


        return StreamBuilder<List<SurveyViewModel>>(

          stream: presenter.loadSurveysStrem,
          builder: (context, snapshot) {
            if(snapshot.hasError){

              return Column(children:[
              Text(snapshot.error),
              ElevatedButton(onPressed:null, child: Text(R.string.reload))

              ]);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CarouselSlider(
                items: [
                  SurveyItem(),
                  SurveyItem(),
                  SurveyItem(),
                ],
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  aspectRatio: 1,
                ),
              ),
            );
          }
        );
      }),
    );
  }
}
