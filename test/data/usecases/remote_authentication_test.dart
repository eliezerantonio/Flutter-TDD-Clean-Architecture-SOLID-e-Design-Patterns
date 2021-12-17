import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  RemoteAuthentication({@required this.httpClient, this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required String method,
  });
}

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
    await sut.auth();

    verify(httpCliente.request(url: url, method: 'post'));
  });
}
