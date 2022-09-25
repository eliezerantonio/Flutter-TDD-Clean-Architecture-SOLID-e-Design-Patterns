import '../pages.dart';

abstract class SurveysPresenter{
Stream <bool> get isLoadingStream;
Stream <List<SurveyViewModel>>  loadSurveysStrem;


Future<void>loadData();
}