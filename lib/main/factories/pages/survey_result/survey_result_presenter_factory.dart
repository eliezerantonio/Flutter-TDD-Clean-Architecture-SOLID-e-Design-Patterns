

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/survey_result/survey_result_presenter.dart';
import '../../factories.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) => GetxSurveyResultPresenter(loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId), surveyId:surveyId, saveSurveyResult: makeRemoteSaveSurveyResult(surveyId));



