
import 'package:flutter_tdd_clean_architecture/main/composites/composites.dart';
import 'package:flutter_tdd_clean_architecture/main/factories/cache/cache.dart';

import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';
import '../http/authorize_http_client_decorator_factory.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(httpClient: makeAuthorizeHttpClientDecorator(), url: makeApiUrl('surveys'));



LoadSurveys makeLocalLoadSurveys() => LocalLoadSurveys(cacheStorage:makeLocalStorageAdapter());


LoadSurveys makeRemoteLoadSurveysWithLocalFallback() => RemoteLoadSurveysWithLocalFallback(remoteLoadSurveys: makeRemoteLoadSurveys(), localLoadSurveys: makeLocalLoadSurveys());
