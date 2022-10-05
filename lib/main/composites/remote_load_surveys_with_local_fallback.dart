import 'package:meta/meta.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remoteLoadSurveys;
  final LocalLoadSurveys localLoadSurveys;

  RemoteLoadSurveysWithLocalFallback({@required this.remoteLoadSurveys, @required this.localLoadSurveys});

  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remoteLoadSurveys.load();
      await localLoadSurveys.save(surveys);

      return surveys;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }

      await localLoadSurveys.validate();
      return  await localLoadSurveys.load();
    }
  }
}