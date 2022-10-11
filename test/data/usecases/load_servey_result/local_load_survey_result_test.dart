import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/load_survey_result/local_load_survey_result.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/data/cache/chache.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('LoadBySurvey', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveyResult sut;
    Map data;
    String surveyId;

    Map mockValidData() => 
          {
            'surveyId': faker.guid.guid(),
            'question': faker.lorem.sentence(),
            'answers': [
              {
                'image':faker.internet.httpUrl(),
                'answer': faker.lorem.sentence(),
                'isCurrentAnswer': 'true',
                'percent': '40',
              }, {
                'image':faker.internet.httpUrl(),
                'answer': faker.lorem.sentence(),
                'isCurrentAnswer': 'false',
                'percent': '60',
              }
            ],
          };
          
        

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId=faker.guid.guid();
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });
    test('Should call cacheStorage  with correct key', () async {
      await sut.loadBySurvey(surveyId:surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return surveyResult on success', () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(
        surveyResult,
        SurveyResultEntity(
          surveyId: data['surveyId'],
          question: data['question'],
          answers: [
            SurveyAnswerEntity(
                image: data['answers'][0]['image'],
                answer: data['answers'][0]['answer'],
                isCurrentAnswer: true,
                percent: 40),
            SurveyAnswerEntity(
                answer: data['answers'][1]['answer'],
                isCurrentAnswer: false,
                percent: 60)
          ],
        ),
      );
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch({});

      final future = sut.loadBySurvey(surveyId:surveyId );

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);

      final future = sut.loadBySurvey(surveyId:surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(
        {
            'surveyId': faker.guid.guid(),
            'question': faker.lorem.sentence(),
            'answers': [
              {
                'image':faker.internet.httpUrl(),
                'answer': faker.lorem.sentence(),
                'isCurrentAnswer': 'invalid bool',
                'percent': 'invalid int',
              }
            ],
          },
      );

      final future = sut.loadBySurvey(surveyId:surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(
         {
            'surveyId': faker.guid.guid(),
            'question': faker.lorem.sentence(),
            
          },
      );

      final future = sut.loadBySurvey(surveyId:surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if  cache throw ', () async {
      mockFetchError();

      final future = sut.loadBySurvey(surveyId:surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  
}
