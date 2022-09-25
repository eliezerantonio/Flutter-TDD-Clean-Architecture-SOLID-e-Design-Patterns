import 'package:meta/meta.dart';

class SurveyViewModel{

  final String id;
  final String question;
  final String dateTime;
  final bool didAnswer;

  SurveyViewModel({ @required this.id,@required this.question,@required this.dateTime,@required this.didAnswer});
  
  @override
  List<Object> get props => ['id', 'question', 'dateTime','didAnswer'];

}