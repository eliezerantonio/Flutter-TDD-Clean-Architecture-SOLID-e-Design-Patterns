import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter implements SurveyResultPresenter {
  GetxSurveyResultPresenter(
      {@required this.loadSurveyResult, @required this.surveyId});
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;
 final _isSessionExpired = RxBool(null);
  final _isLoading = true.obs;
  final _surveyResult = Rx<SurveyResultViewModel>(null);

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;
 
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveyResult =await loadSurveyResult.loadBySurvey(surveyId: surveyId);

      _surveyResult.value = SurveyResultViewModel(
        surveyId: surveyResult.surveyId,
        question: surveyResult.question,
        answers: surveyResult.answers.map((answer) => SurveyAnswerViewModel(image:answer.image,answer: answer.answer, isCurrentAnswer: answer.isCurrentAnswer, percent: '${answer.percent}',) ).toList()
      );
    }  on DomainError catch(error) {
      if (error == DomainError.accessDenied) {
        _isSessionExpired.value = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }} finally {
      _isLoading.value = false;
    }
  }
}
