import 'package:meta/meta.dart';

import 'survey_result.dart';

abstract class SurveyResultPresenter{
Stream <bool> get isSessionExpiredStream;
  Stream <bool> get isLoadingStream;
  Stream <SurveyResultViewModel> get surveyResultStream;
  

  Future<void> loadData();
  Future<void> save({@required String answer});
}