

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/survey_result/survey_result_presenter.dart';
import '../../usecases/load_survey_result_factory.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) => GetxSurveyResultPresenter(loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId), surveyId:surveyId);



