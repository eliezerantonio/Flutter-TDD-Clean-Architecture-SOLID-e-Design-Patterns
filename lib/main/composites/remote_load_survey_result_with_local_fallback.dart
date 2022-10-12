import 'package:meta/meta.dart';

import '../../data/usecases/load_survey_result/load_survey_result.dart';
import '../../data/usecases/load_survey_result/local_load_survey_result.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback(
      {@required this.remote, @required this.local});

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
 try {


   final remoteResult = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(remoteResult);
    return remoteResult;

 }catch(error){
if (error == DomainError.accessDenied) {
        rethrow;
      }
  await local.validate(surveyId);
 return await local.loadBySurvey(surveyId: surveyId);
 }
  }
}
