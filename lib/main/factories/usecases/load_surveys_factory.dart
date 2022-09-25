
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(httpClient: makeHttpAdapter(), url: makeApiUrl('surveys'));
