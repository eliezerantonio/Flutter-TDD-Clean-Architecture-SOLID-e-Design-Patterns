import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter{}
void main() {
  SurveysPresenterSpy presenter=SurveysPresenterSpy();
  StreamController<bool> isLoadingController;
  StreamController<List<SurveyViewModel>> loadSurveysController;

  void initStreams() {
  
    isLoadingController= new StreamController<bool>();
    loadSurveysController= new StreamController<List<SurveyViewModel>>();
  }


   void mockStreams() {
  
    when(presenter.isLoadingStream) .thenAnswer((_) => isLoadingController.stream);
    
    when(presenter.loadSurveysStrem).thenAnswer((_) => loadSurveysController.stream);

  }

  void closeStreams() {
 
    isLoadingController.close();
    loadSurveysController.close();
  
  }

  Future<void> loadPage(WidgetTester tester)async{
      presenter=SurveysPresenterSpy();
      initStreams();
      mockStreams();
    final surveysPage = GetMaterialApp(initialRoute: '/surveys',getPages: [GetPage(name: '/surveys', page: () => SurveysPage(presenter))]);
   
    await tester.pumpWidget(surveysPage);

  }

  List<SurveyViewModel>makeSurveys()=>[
  SurveyViewModel(id: '1', question:'Question 1', date:'Any Date', didAnswer:true),
  SurveyViewModel(id: '2', question:'Question 2', date:'Any Date', didAnswer:false),

  ];



  tearDown((){
    closeStreams();
  });

  testWidgets("Should call LoadSurveys on page load",(WidgetTester tester) async {
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

    loadSurveysController.addError(UIError.unexpected.description);

    await tester.pump();

   expect(find.text('Deu errado, tente novamente'), findsOneWidget);
   expect(find.text('Recarregar'), findsOneWidget);
   expect(find.text('Question 1'), findsNothing);


    });

     testWidgets('Should Present list if loadSurveysStream success', (WidgetTester tester)async{
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());

    await tester.pump();

   expect(find.text('Deu errado, tente novamente'), findsNothing);
   expect(find.text('Recarregar'), findsNothing);
   expect(find.text('Question 1'), findsWidgets);
   expect(find.text('Question 2'), findsWidgets);


    });
}
