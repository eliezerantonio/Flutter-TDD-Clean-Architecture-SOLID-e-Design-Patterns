import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';
import 'package:flutter_tdd_clean_architecture/presentation/presenters/presenters.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/errors.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}
class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  LoadSurveyResultSpy loadSurveyResult;
  SaveSurveyResultSpy saveSurveyResult;
  GetxSurveyResultPresenter sut;
  SurveyResultEntity surveyResult;
  String surveyId;
  String answer;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
        answers: [
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          ),
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          ),
        ],
        question: faker.lorem.sentence(),
        surveyId: faker.guid.guid(),
      );

  PostExpectation mockLoadSurveyResultCall() =>
      when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveyResultError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);
 void mockAccessDeniedError() => mockLoadSurveyResultCall().thenThrow(DomainError.accessDenied);
  setUp(() {
    surveyId = faker.guid.guid();
    loadSurveyResult = LoadSurveyResultSpy();
    saveSurveyResult=SaveSurveyResultSpy();
    sut = GetxSurveyResultPresenter(loadSurveyResult: loadSurveyResult,saveSurveyResult:saveSurveyResult, surveyId: surveyId);
    mockLoadSurveyResult(mockValidData());
    answer=faker.lorem.sentence();
  });
 
 group('LoadData', (){

   test('Should calll LoadSurveyResult on loadData', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    await sut.loadData();
    verify(loadSurveyResult.loadBySurvey(surveyId:surveyId)).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveyResultStream.listen(
      expectAsync1((result) => expect(result,SurveyResultViewModel(
              surveyId: surveyResult.surveyId,
              question: surveyResult.question,
              answers: [
                SurveyAnswerViewModel(
                  image: surveyResult.answers[0].image,
                  answer: surveyResult.answers[0].answer,
                  isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
                  percent: '${surveyResult.answers[0].percent}',
                ),
                 SurveyAnswerViewModel(
                  answer: surveyResult.answers[1].answer,
                  isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
                  percent: '${surveyResult.answers[1].percent}',
                ),
              ],
            )
          ,
        ),
      ),
    );

    await sut.loadData();
  });

  test('Should emit correct events on failure', () async {
    mockLoadSurveyResultError();
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(
      null,
      onError: expectAsync1(
        (error) => expect(error, UIError.unexpected.description),
      ),
    );

    await sut.loadData();
  });

   test('Should emit correct events on access denied', () async {
    mockAccessDeniedError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });
 });
 
  group('Save', (){

   test('Should calll SaveSurveyResult on save', () async {
    await sut.save(answer:answer);
    verify(saveSurveyResult.save(answer:answer)).called(1);
  });

 });
}
