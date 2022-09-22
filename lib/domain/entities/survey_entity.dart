import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SurveyEntity extends Equatable {
  final String id;
  final String question;
  final DateTime dateTime;
  final bool didAnswer;

  SurveyEntity({ @required this.id,@required this.question,@required this.dateTime,@required this.didAnswer});
  
  @override
  List<Object> get props => ['id', 'question', 'dateTime','didAnswer'];


}
