import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';

import '../../domain/entities/entities.dart';

extension SurveyResultEntityExtension on SurveyResultEntity {
  SurveyResultViewModel toViewModel() => SurveyResultViewModel(
      surveyId: surveyId,
      question: question,
      answers: answers.map((answer) => answer.toViewModel()).toList());
}

extension SurveyAnswerEntityExtension on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() => SurveyAnswerViewModel(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: '$percent',
      );

}