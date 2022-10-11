import '../../domain/entities/entities.dart';
import 'package:meta/meta.dart';

class LocalSurveyAnswerModel {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  LocalSurveyAnswerModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
  });

  factory LocalSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['isCurrentAnswer', 'percent', 'answer'])) {
      throw Exception();
    }

    return LocalSurveyAnswerModel(
        image: json['image'],
        answer: json['answer'],
        percent: int.parse(json['percent']),
        isCurrentAnswer: bool.fromEnvironment(json['isCurrentAnswer']));
  }

  factory LocalSurveyAnswerModel.fromEntity(SurveyAnswerEntity entity) =>
      LocalSurveyAnswerModel(
        answer: entity.answer,
        isCurrentAnswer: entity.isCurrentAnswer,
        percent: entity.percent,
        image: entity.image,
      );

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        answer: answer,
        image: image,
        isCurrentAnswer: isCurrentAnswer,
        percent: percent,
      );

  Map toJson() => {
        'image': image,
        'answer': answer,
        'isCurrentAnswer': isCurrentAnswer.toString(),
        'percent': percent.toString(),
      };
}
