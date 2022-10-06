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
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          },
        );
      
      
        return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.loadSurveysStrem,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(snapshot.error, style:TextStyle(fontSize: 16,), textAlign: TextAlign.center),
                    SizedBox(height:10),
                    ElevatedButton(onPressed: presenter.loadData, child: Text(R.string.reload))
                  ]),
                );
              }
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CarouselSlider(
                    items: snapshot.data
                        .map((viewModel) => SurveyItem(viewModel))
                        .toList(),
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 1,
                    ),
                  ),
                );
              }

              return Container();
            });
      }),
    );
  }
}
