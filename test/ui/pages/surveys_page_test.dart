import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter = SurveysPresenterSpy();
  StreamController<bool> isLoadingController;
  StreamController<List<SurveyViewModel>> loadSurveysController;
  StreamController<String> navigateToController;

  void initStreams() {
    isLoadingController = new StreamController<bool>();
    loadSurveysController = new StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.loadSurveysStrem)
        .thenAnswer((_) => loadSurveysController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    loadSurveysController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
          name: '/surveys',
          page: () => SurveysPage(presenter),
        ), 
        
        GetPage(
          name: '/any_route',
          page: () =>Text("fake page"),
        ),
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
            id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
        SurveyViewModel(
            id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
      ];

  tearDown(() {
    closeStreams();
  });

  testWidgets("Should call LoadSurveys on page load",
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);
    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should Present error if loadSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);

    await tester.pump();

    expect(find.text('Deu errado, tente novamente'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should Present list if loadSurveysStream success',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());

    await tester.pump();

    expect(find.text('Deu errado, tente novamente'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets("Should call LoadSurveys on  reload button click",
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text("Recarregar"));

    verify(presenter.loadData()).called(2);
  });

  testWidgets("Should call goToSurveyResult on  survey click",
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('Should change page', (WidgetTester tester)async{
await loadPage(tester);

navigateToController.add('/any_route');  
await tester.pumpAndSettle();

expect(Get.currentRoute, '/any_route');
expect(find.text('fake page'), findsOneWidget);



  });
}
