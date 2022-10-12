

import '../../../data/usecases/save_survey_result/save_survey_result.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';
import '../http/authorize_http_client_decorator_factory.dart';

SaveSurveyResult makeRemoteSaveSurveyResult( String surveyId) => RemoteSaveSurveyResult(httpClient: makeAuthorizeHttpClientDecorator(), url: makeApiUrl('surveys/$surveyId/results'));
