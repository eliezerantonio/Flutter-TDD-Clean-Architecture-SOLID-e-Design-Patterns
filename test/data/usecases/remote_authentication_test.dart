import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/data/usecases/remote_authentication.dart';

import 'package:flutter_tdd_clean_architecture/data/http/http.dart';

import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';




class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpCliente;
  String url;
  setUp(() {
    httpCliente = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpCliente, url: url);
  });
  test('Should call HttpClient with currect Values', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth(params);

    verify(httpCliente.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret}));
  });
}
