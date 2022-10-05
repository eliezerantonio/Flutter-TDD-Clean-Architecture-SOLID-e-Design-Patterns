import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/data/usecases/usecases.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';

import 'package:flutter_tdd_clean_architecture/main/composites/composites.dart';





class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysSpy remote;
  LocalLoadSurveysSpy local;

  RemoteLoadSurveysWithLocalFallback sut;
  List<SurveyEntity> remoteSurveys;
  List<SurveyEntity> localSurveys;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: faker.date.dateTime(),
            didAnswer: faker.randomGenerator.boolean())
      ];

  PostExpectation mockRemoteLoadCall() => when(remote.load());

  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockRemoteLoadError(DomainError error) {
    mockRemoteLoadCall().thenThrow(error);
  }



  PostExpectation mockLocalLoadCall() => when(local.load());

  void mockLocalLoad() {
    localSurveys = mockSurveys();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }


  void mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);
  


  

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remoteLoadSurveys: remote, localLoadSurveys: local);

    mockRemoteLoad();
    mockLocalLoad();
  });

  test('Should call remote load surveys', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call  save with remote data', () async {
    await sut.load();

    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);
    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);
    await sut.load();

    verify(local.validate()).called(1); //validar o cache
    verify(local.load()).called(1);
  }); 
  
  test('Should return local surveys', () async {
    mockRemoteLoadError(DomainError.unexpected);
   final surveys= await sut.load();

 expect(surveys, localSurveys);
  });


   test('Should throw UnexpectedError if remote and local throws ', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

   final future=  sut.load();

   expect(future, throwsA(DomainError.unexpected));
  });
}
