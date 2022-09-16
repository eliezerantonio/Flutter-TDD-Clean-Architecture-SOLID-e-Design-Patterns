import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/data/http/http.dart';

import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAddAccount sut;
  HttpClientSpy httpClient;
  String url;
  AddAccountParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
        name: faker.person.name(),
        email: faker.internet.email(),
        password: faker.internet.password(),
        passwordConfirmation: faker.internet.password());
  });
  test(
    'Should call HttpClient with currect Values',
    () async {
      await sut.add(params);

      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {
            'name': params.name,
            'email': params.email,
            'password': params.password,
            'passwordConfirmation': params.passwordConfirmation,
          },
        ),
      );
    },
  );
}
