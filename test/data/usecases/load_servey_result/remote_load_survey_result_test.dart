import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/load_survey_result/load_survey_result.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/data/http/http.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  Map surveyResult;
  HttpClientSpy httpClient;
  RemoteLoadSurveyResult sut;

  Map mockValidData() => 
        {
          'surveyId': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'answers': [{
            'image':faker.internet.httpUrl(),
            'answer':faker.randomGenerator.string(20),
            'percent':faker.randomGenerator.integer(100),
            'count':faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer':faker.randomGenerator.boolean(),
          },{
            'answer':faker.randomGenerator.string(20),
            'percent':faker.randomGenerator.integer(100),
            'count':faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer':faker.randomGenerator.boolean(),
          },],
          'date': faker.date.dateTime().toIso8601String(),
        }
      ;

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'),method: anyNamed('method'),body: anyNamed('body')));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });

  test('Should calll HttpClient with currect values', () async {
    await sut.loadBySurvey();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveyResult on 200', () async {
    final result = await sut.loadBySurvey();

    expect(result, 
      SurveyResultEntity(
        surveyId: surveyResult['surveyId'],
        question: surveyResult['question'],
        answers: [
          SurveyAnswerEntity(
            image: surveyResult['answers'][0]['image'],
            answer: surveyResult['answers'][0]['answer'],
           isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'], 
          percent: surveyResult['answers'][0]['percent'],
          ),  
          SurveyAnswerEntity(
            answer: surveyResult['answers'][1]['answer'],
           isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'], 
          percent: surveyResult['answers'][1]['percent'],
          ),
        ],
      ),
     
    );
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data ',
      () async {
    mockHttpData(
      {'invalid_key': 'invalid_value'}
    );
    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () {
    mockHttpError(HttpError.notFound);
    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () {
    mockHttpError(HttpError.serverError);
    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () {
    mockHttpError(HttpError.forbidden);
    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
