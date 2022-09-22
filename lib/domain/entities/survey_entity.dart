import 'package:meta/meta.dart';

class SurveyEntity  {
  final String id;
  final String question;
  final DateTime dateTime;
  final DateTime didAnswer;

  SurveyEntity({ @required this.id,@required this.question,@required this.dateTime,@required this.didAnswer});


}
