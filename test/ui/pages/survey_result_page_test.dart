
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/errors.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/survey_result/components/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../helpers/helpers.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;

  StreamController<bool> isLoadingController;
  StreamController<bool> isSessionExpiredController;

  StreamController<SurveyResultViewModel> surveyResultController;
  void initStreams() {
  
    isLoadingController= new StreamController<bool>();
    isSessionExpiredController= new StreamController<bool>();
    surveyResultController=new StreamController<SurveyResultViewModel>();
  }


   void mockStreams() {
  
    when(presenter.isLoadingStream) .thenAnswer((_) => isLoadingController.stream);
    when(presenter.isSessionExpiredStream) .thenAnswer((_) => isSessionExpiredController.stream);
    when(presenter.surveyResultStream) .thenAnswer((_) => surveyResultController.stream);
    

  }

  void closeStreams() {
 
    isLoadingController.close();
    surveyResultController.close();
    isSessionExpiredController.close();
  
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    initStreams();
    mockStreams();

    await  mockNetworkImagesFor(() async {
    await tester.pumpWidget(makePage(path:'/survey_result/any_survey_id', page:()=> SurveyResultPage(presenter)));
    });

   
  }


SurveyResultViewModel makeSurveyResult()=>SurveyResultViewModel(surveyId:'Any id' , question: 'Question', answers: [


  SurveyAnswerViewModel(image:'Image 0',answer: 'Answer 0', isCurrentAnswer: true, percent: '60%'),

  SurveyAnswerViewModel(answer: 'Answer 1', isCurrentAnswer: false, percent: '40%'),
]);

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

  testWidgets("Should call LoadSurveyResult on  reload button click",(WidgetTester tester) async {
 
   await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text("Recarregar"));

    verify(presenter.loadData()).called(2);

  });



   testWidgets('Should call LoadSurveyResult on reload button click',(WidgetTester tester)async{

    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
  
    await tester.pump();

   expect(find.text('Deu errado, tente novamente'), findsOneWidget);
   expect(find.text('Recarregar'), findsOneWidget);
   expect(find.text('Question'), findsNothing);
 
  });

  testWidgets('Should present valid data if surveyResultStream succeeds',(WidgetTester tester)async{

    await loadPage(tester);

    surveyResultController.add(makeSurveyResult());
  
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

   expect(find.text('Deu errado, tente novamente'), findsNothing);
   expect(find.text('Recarregar'), findsNothing);
   expect(find.text('Question'), findsOneWidget);
   expect(find.text('Answer 0'), findsOneWidget);
   expect(find.text('Answer 1'), findsOneWidget);
   expect(find.text('60%'), findsOneWidget);
   expect(find.text('40%'), findsOneWidget);
   expect(find.byType(ActiveIcon), findsOneWidget);
   expect(find.byType(DisabledIcon), findsOneWidget);

   final image =tester.widget<Image>(find.byType(Image)).image as NetworkImage;

   expect(image.url, 'Image 0');

  });


  testWidgets('Should logout', (WidgetTester tester)async{
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();

    expect(currentRoute, '/login');
    expect(find.text('fake login'), findsOneWidget);



  });

    testWidgets('Should not change page', (WidgetTester tester)async{
    await loadPage(tester);

  isSessionExpiredController.add(false);
    await tester.pump();

    expect(currentRoute, '/survey_result/any_survey_id');

    isSessionExpiredController.add(null);
    await tester.pump();

    expect(currentRoute, '/survey_result/any_survey_id');

  });


     testWidgets('Should call save on list item click',(WidgetTester tester)async{

    await loadPage(tester);

    surveyResultController.add(makeSurveyResult());

    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    await tester.tap(find.text('Answer 1'));

    verify(presenter.save(answer:'Answer 1')).called(1);
 
  });
 testWidgets('Should not call save on current answer click',(WidgetTester tester)async{

    await loadPage(tester);

    surveyResultController.add(makeSurveyResult());

    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    await tester.tap(find.text('Answer 0'));

    verifyNever(presenter.save(answer:'Answer 0'));
 
  });


}
