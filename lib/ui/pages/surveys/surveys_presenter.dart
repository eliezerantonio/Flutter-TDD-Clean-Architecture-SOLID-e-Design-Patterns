import '../pages.dart';

abstract class SurveysPresenter{
Stream <bool> get isLoadingStream;
Stream <List<SurveyViewModel>> get loadSurveysStrem;
Stream  <String> get navigateToStream;


Future<void>loadData();

void goToSurveyResult(String surveyId);

}