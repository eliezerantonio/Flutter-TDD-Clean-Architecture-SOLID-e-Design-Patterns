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
  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;
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

  PostExpectation mockLoadSurveyResultCall() => when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveyResultError(DomainError error) =>  mockLoadSurveyResultCall().thenThrow(error);



  PostExpectation mockSaveSurveyResultCall() => when(saveSurveyResult.save(answer: anyNamed('answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

    void mockSaveSurveyResultError(DomainError error) =>  mockSaveSurveyResultCall().thenThrow(error);

  SurveyResultViewModel mapToViewModel(SurveyResultEntity entity)=>SurveyResultViewModel(
              surveyId: entity.surveyId,
              question: entity.question,
              answers: [
                SurveyAnswerViewModel(
                  image: entity.answers[0].image,
                  answer: entity.answers[0].answer,
                  isCurrentAnswer: entity.answers[0].isCurrentAnswer,
                  percent: '${entity.answers[0].percent}',
                ),
                 SurveyAnswerViewModel(
                  answer: entity.answers[1].answer,
                  isCurrentAnswer: entity.answers[1].isCurrentAnswer,
                  percent: '${entity.answers[1].percent}',
                ),
              ],
            );
  setUp(() {
    surveyId = faker.guid.guid();
    loadSurveyResult = LoadSurveyResultSpy();
    saveSurveyResult=SaveSurveyResultSpy();
    sut = GetxSurveyResultPresenter(loadSurveyResult: loadSurveyResult,saveSurveyResult:saveSurveyResult, surveyId: surveyId);
    answer=faker.lorem.sentence();
    mockLoadSurveyResult(mockValidData());
    mockSaveSurveyResult(mockValidData());
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
      expectAsync1((result) => expect(result,mapToViewModel(loadResult)
          ,
        ),
      ),
    );

    await sut.loadData();
  });

  test('Should emit correct events on failure', () async {
    mockLoadSurveyResultError(DomainError.unexpected);
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
    mockLoadSurveyResultError(DomainError.accessDenied);

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



 test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.surveyResultStream, emitsInOrder([mapToViewModel(loadResult), mapToViewModel(saveResult)]));

    await sut.loadData();
    await sut.save(answer:answer);
  });


 test('Should emit correct events on failure', () async {
    mockSaveSurveyResultError(DomainError.unexpected);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(
      null,
      onError: expectAsync1(
        (error) => expect(error, UIError.unexpected.description),
      ),
    );

   await sut.save(answer:answer);
  });

   test('Should emit correct events on access denied', () async {
    mockSaveSurveyResultError(DomainError.accessDenied);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.save(answer:answer);
  });
 });
}
