import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/load_survey_result/load_survey_result.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/save_survey_result/save_survey_result.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/data/http/http.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
 String answer;
  HttpClientSpy httpClient;
  RemoteSaveSurveyResult sut;
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


}
