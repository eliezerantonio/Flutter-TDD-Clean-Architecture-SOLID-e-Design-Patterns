import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/components/componets.dart';

import '../../helpers/i18n/i18n.dart';
import '../pages.dart';

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

          presenter.loadData();
          return StreamBuilder<dynamic>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {


                if (snapshot.hasError) {
                return ReloadScreen(error:snapshot.error, reload:presenter.loadData,);
              }
              if (snapshot.hasData) {
                  return ListView.builder(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                        padding: EdgeInsets.only(
                            top: 40, bottom: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor.withAlpha(90),
                        ),
                        child: Text("Qual e seu framework web favorito"));
                  }
          
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Image.network('http://fordevs.herokuapp.com/static/img/logo-angular.png', width:40),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Angular",
                                style: TextStyle(fontSize: 16),
                              ),
                            )),
                            Text(
                              "100%",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(Icons.check_circle,
                                  color: Theme.of(context).highlightColor),
                            )
                          ],
                        ),
                      ),
                      Divider(height: 1)
                    ],
                  );
                },
                itemCount: 4,
              );
              }
             

             return SizedBox(height: 0,);
            }
          );
        },
      ),
    );
  }
}
