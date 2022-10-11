import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/load_survey_result/load_survey_result.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteLoadSurveyResultWithLocalFallback {
  final RemoteLoadSurveyResult remote;

  RemoteLoadSurveyResultWithLocalFallback({@required this.remote});


  Future<void> loadBySurvey({String surveyId}) async {
    remote.loadBySurvey(surveyId:surveyId);
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

void main() {
  test('Should call remote LoadBySurvey', () async {
    final String surveyId = faker.guid.guid();
    final remote = RemoteLoadSurveyResultSpy();
    final sut = RemoteLoadSurveyResultWithLocalFallback(remote:remote);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });
}
