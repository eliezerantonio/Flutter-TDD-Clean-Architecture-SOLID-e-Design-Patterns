import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/data/usecases/load_survey_result/local_load_survey_result.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/load_survey_result.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/load_survey_result/load_survey_result.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback(
      {@required this.remote, @required this.local});

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
 try {


   final remoteResult = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(surveyId: surveyId, surveyResult: remoteResult);
    return remoteResult;

 }catch(error){
if (error == DomainError.accessDenied) {
        rethrow;
      }
  await local.validate(surveyId);
 return await local.loadBySurvey(surveyId: surveyId);
 }
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  String surveyId;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  RemoteLoadSurveyResultWithLocalFallback sut;

  SurveyResultEntity remoteResult;
  SurveyResultEntity localResult;

  SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
              image: faker.internet.httpUrl(),
              answer: faker.lorem.sentence(),
              isCurrentAnswer: true,
              percent: 40,
            ),
          ]);

  PostExpectation mockRemoteLoadCall() =>when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));
  PostExpectation mockLocalLoadCall() =>when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoad() {
    remoteResult = mockSurveyResult();

    mockRemoteLoadCall().thenAnswer((_) async => remoteResult);
  }
  void mockLocalLoad() {
    localResult = mockSurveyResult();

    mockLocalLoadCall().thenAnswer((_) async => localResult);
  }

  void mockRemoteLoadError(DomainError error) {
    mockRemoteLoadCall().thenThrow(error);
  }

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);

    mockRemoteLoad();
    mockLocalLoad();
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyId: surveyId, surveyResult: remoteResult))
        .called(1);
  });

  test('Should return remote data', () async {
    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, remoteResult);
  });

  test('Should rethrow if remote loadBySurvey throws AccessDeniedError',
      () async {
    mockRemoteLoadError(DomainError.accessDenied);
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });
  
  test('Should call local LoadBySurvey on  remote error',() async {
    mockRemoteLoadError(DomainError.unexpected);
   await  sut.loadBySurvey(surveyId: surveyId);

    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId:surveyId)).called(1);
  }); 
  
   test('Should return local data',() async {
     mockRemoteLoadError(DomainError.unexpected);
  final response= await  sut.loadBySurvey(surveyId: surveyId);

   expect(response, remoteResult);


  });
}
