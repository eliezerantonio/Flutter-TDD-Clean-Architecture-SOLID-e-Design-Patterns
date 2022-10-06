import './entities.dart';
import 'package:meta/meta.dart';

class SurveyResultEntitiy{

  final String surveyId;
  final String question;
  final List<SurveyAnswerEntitiy>  answers;


  SurveyResultEntitiy({@required this.surveyId,@required this.question,@required this.answers});}