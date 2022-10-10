
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;

  StreamController<bool> isLoadingController;

  StreamController<dynamic> surveyResultController;
  void initStreams() {
  
    isLoadingController= new StreamController<bool>();
    surveyResultController=new StreamController<dynamic>();
  }


   void mockStreams() {
  
    when(presenter.isLoadingStream) .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveyResultStream) .thenAnswer((_) => surveyResultController.stream);
    

  }

  void closeStreams() {
 
    isLoadingController.close();
    surveyResultController.close();
  
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(name: '/survey_result/:survey_id',page: () => SurveyResultPage(presenter),
        ),
      ],
    );

  await  provideMockedNetworkImages(() async {
       await tester.pumpWidget(surveysPage);
    });

   
  }


tearDown(() {

  closeStreams();
})
;
  testWidgets("Should call LoadSurveyResult on page load",(WidgetTester tester) async {

    await loadPage(tester);

    verify(presenter.loadData()).called(1);

  });

  testWidgets('Should handle loading correctly',(WidgetTester tester)async{
 
 
  await loadPage(tester);
  isLoadingController.add(true);
  await tester.pump();
  expect(find.byType(CircularProgressIndicator), findsOneWidget );

  isLoadingController.add(false);
  await tester.pump();
  expect(find.byType(CircularProgressIndicator), findsNothing );


  isLoadingController.add(true);
  await tester.pump();
  expect(find.byType(CircularProgressIndicator), findsOneWidget );

  isLoadingController.add(null);
  await tester.pump();
  expect(find.byType(CircularProgressIndicator), findsNothing );


  });


testWidgets('Should Present error if loadSurveysStream fails', (WidgetTester tester)async{
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);

    await tester.pump();

   expect(find.text('Deu errado, tente novamente'), findsOneWidget);
   expect(find.text('Recarregar'), findsOneWidget);
   expect(find.text('Question 1'), findsNothing);


    });



}
