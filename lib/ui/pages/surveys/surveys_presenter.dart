import '../pages.dart';

abstract class SurveysPresenter{
Stream <bool> get isLoadingStream;
Stream <List<SurveyViewModel>> get loadSurveysStrem;


Future<void>loadData();

}