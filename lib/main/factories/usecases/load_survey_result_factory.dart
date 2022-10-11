

import '../../../data/usecases/load_survey_result/load_survey_result.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';
import '../http/authorize_http_client_decorator_factory.dart';

LoadSurveyResult makeRemoteLoadSurveyResult( String surveyId) => RemoteLoadSurveyResult(httpClient: makeAuthorizeHttpClientDecorator(), url: makeApiUrl('surveys/$surveyId/results'));


