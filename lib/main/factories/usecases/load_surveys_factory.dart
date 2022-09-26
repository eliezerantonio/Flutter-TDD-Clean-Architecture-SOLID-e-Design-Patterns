
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';
import '../http/authorize_http_client_decorator_factory.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(httpClient: makeAuthorizeHttpClientDecorator(), url: makeApiUrl('surveys'));
