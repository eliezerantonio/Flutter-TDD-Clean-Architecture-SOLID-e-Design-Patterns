import '../../domain/entities/entities.dart';
import 'package:meta/meta.dart';

import '../http/http.dart';

class RemoteSurveyAnswerModel {
  final String image;
  final bool isCurrentAccountAnswer;
  final String answer;
  final int percent;

  RemoteSurveyAnswerModel({
     this.image,
    @required this.answer,
    @required this.isCurrentAccountAnswer,
    @required this.percent,
  });

  factory RemoteSurveyAnswerModel.fromJson(Map json) {
   if(!json.keys.toSet().containsAll(['answer','isCurrentAccountAnswer','percent'])){

    throw HttpError.invalidData;


   }

    return RemoteSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      percent: json['percent'],
      isCurrentAccountAnswer: json['isCurrentAccountAnswer'],
    );
  }

  

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAccountAnswer,
        percent: percent,
      );
}
