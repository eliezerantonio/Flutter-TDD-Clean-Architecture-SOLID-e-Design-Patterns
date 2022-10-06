import 'package:meta/meta.dart';

class SurveyAnswerEntitiy{


  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  SurveyAnswerEntitiy({this.image,@required this.answer,@required this.isCurrentAnswer,@required this.percent});


}