import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class LocalSurveyResultModel {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  factory LocalSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'answers', 'question'])) {
      throw Exception();
    }

    return LocalSurveyResultModel(
        surveyId: json['surveyId'],
        question: json['question'],
        answers: json['answers'].map<LocalSurveyAnswerModel>((answerJson) => LocalSurveyAnswerModel.fromJson(answerJson)).toList());
  }
  factory LocalSurveyResultModel.fromEntity(SurveyResultEntity entity) =>
      LocalSurveyResultModel(
          answers: entity.answers.map<LocalSurveyAnswerModel>((e) => LocalSurveyAnswerModel.fromEntity(e)).toList(),
          question: entity.question,
          surveyId: entity.surveyId);

  SurveyResultEntity toEntity() => SurveyResultEntity(answers: answers.map<SurveyAnswerEntity>((answer) => answer.toEntity()).toList(),
      surveyId: surveyId,
      question: question);


      Map toJson()=>{
        'surveyId':surveyId,
        'question':question,
        'answers':answers.map<Map>((answer) => answer.toJson()).toList(),

      };
}
