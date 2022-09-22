import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/data/http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteLoadSurveys {
  RemoteLoadSurveys({@required this.url, @required this.httpClient});
  final String url;

  final HttpClient httpClient;

  Future<void> load() async {
    await httpClient.request(url: url, method: 'get');
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  HttpClientSpy httpClient;
  RemoteLoadSurveys sut;

  setUp(() {
   url= faker.internet.httpUrl();
   httpClient=HttpClientSpy();
   sut= RemoteLoadSurveys(url: url, httpClient: httpClient);
  });

  test('Should calll HttpClient with currect values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });
}
