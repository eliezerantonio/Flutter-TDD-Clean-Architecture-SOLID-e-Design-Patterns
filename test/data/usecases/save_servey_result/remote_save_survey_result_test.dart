import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/data/usecases/save_survey_result/save_survey_result.dart';
import 'package:flutter_tdd_clean_architecture/data/http/http.dart';


class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
 String answer;
  HttpClientSpy httpClient;
  RemoteSaveSurveyResult sut;


  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'),method: anyNamed('method'),body: anyNamed('body')));



  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }
setUp(() {
    url = faker.internet.httpUrl();
    answer = faker.lorem.sentence();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
  });

  test('Should calll HttpClient with currect values', () async {
    await sut.save(answer:answer);

    verify(httpClient.request(url: url, method: 'put', body: {'answer': answer}));
  });



  test('Should throw UnexpectedError if HttpClient returns 404', () {
    mockHttpError(HttpError.notFound);
    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () {
    mockHttpError(HttpError.serverError);
    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () {
    mockHttpError(HttpError.forbidden);
    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.accessDenied));
  });

}
