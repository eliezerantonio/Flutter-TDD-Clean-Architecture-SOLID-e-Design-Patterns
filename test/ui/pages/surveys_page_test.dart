import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter{}
void main() {
  SurveysPresenterSpy presenter=SurveysPresenterSpy();
  StreamController<bool> isLoadingController;

  void initStreams() {
  
    isLoadingController= new StreamController<bool>();
  }


   void mockStreams() {
  
    when(presenter.isLoadingStream) .thenAnswer((_) => isLoadingController.stream);
    

  }

  void closeStreams() {
 
    isLoadingController.close();
  
  }

  Future<void> loadPage(WidgetTester tester)async{
      presenter=SurveysPresenterSpy();
      initStreams();
      mockStreams();
    final surveysPage = GetMaterialApp(initialRoute: '/surveys',getPages: [GetPage(name: '/surveys', page: () => SurveysPage(presenter))]);
   
    await tester.pumpWidget(surveysPage);

  }

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
}
