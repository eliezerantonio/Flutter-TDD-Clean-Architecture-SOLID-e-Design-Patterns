import 'package:flutter_tdd_clean_architecture/presentation/helpers/helpers.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSurveyResultPresenter extends GetxController with SessionManager, LoadingManager, UIErrorManager  implements SurveyResultPresenter {
  GetxSurveyResultPresenter({@required this.loadSurveyResult, @required this.saveSurveyResult, @required this.surveyId});
  
  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel>(null);

  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  Future<void> loadData() async {
    showResultOnAction(() => loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  Future<void> save({@required String answer}) async {
    showResultOnAction(() => saveSurveyResult.save(answer: answer));
  }

  Future<void> showResultOnAction(Future<SurveyResultEntity> action()) async {
    try {
      isLoading = true;
      final surveyResult = await action();

      _surveyResult.subject.add(surveyResult.toViewModel() );
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }
}



