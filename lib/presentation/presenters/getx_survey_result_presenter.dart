import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSurveyResultPresenter extends  GetxController with SessionManager, LoadingManager, UIErrorManager implements SurveyResultPresenter {
  GetxSurveyResultPresenter({@required this.loadSurveyResult,@required this.saveSurveyResult, @required this.surveyId});
  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;
 
  final _surveyResult = Rx<SurveyResultViewModel>(null);

  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;
 
  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveyResult =await loadSurveyResult.loadBySurvey(surveyId: surveyId);

      _surveyResult.value = SurveyResultViewModel(
        surveyId: surveyResult.surveyId,
        question: surveyResult.question,
        answers: surveyResult.answers.map((answer) => SurveyAnswerViewModel(image:answer.image,answer: answer.answer, isCurrentAnswer: answer.isCurrentAnswer, percent: '${answer.percent}',) ).toList()
      );
    }  on DomainError catch(error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }} finally {
      isLoading = false;
    }
  }

    Future<void> save({@required String answer}) async{

    await saveSurveyResult.save(answer: answer);

    }
}
