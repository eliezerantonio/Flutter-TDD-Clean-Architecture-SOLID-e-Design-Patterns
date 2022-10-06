
import '../entities/entities.dart';

abstract class LoadSurveyResult{

  Future<List<SurveyResultEntity>> loadBySurvey({String surveyId});
  
}