

import '../../../data/usecases/load_survey_result/load_survey_result.dart';
import '../../../data/usecases/load_survey_result/local_load_survey_result.dart';
import '../../../domain/usecases/usecases.dart';
import '../../composites/composites.dart';
import '../cache/cache.dart';
import '../factories.dart';
import '../http/authorize_http_client_decorator_factory.dart';

LoadSurveyResult makeRemoteLoadSurveyResult( String surveyId) => RemoteLoadSurveyResult(httpClient: makeAuthorizeHttpClientDecorator(), url: makeApiUrl('surveys/$surveyId/results'));
LoadSurveyResult makeLocalLoadSurveyResult( String surveyId) => LocalLoadSurveyResult(cacheStorage:makeLocalStorageAdapter());
LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback( String surveyId) => RemoteLoadSurveyResultWithLocalFallback(local:makeLocalLoadSurveyResult(surveyId), remote:makeRemoteLoadSurveyResult(surveyId));


