import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/data/cache/fetch_secure_cache_storage.dart';
import 'package:flutter_tdd_clean_architecture/data/http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class AuthorizeHttpClientDecorator  implements HttpClient{
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage, this.decoratee});

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
    
  }) async {
try {
  
    final token= await fetchSecureCacheStorage.fetchSecure('token');
    final authorizedHeaders= headers?? {}..addAll( {'x-access-token':token});
    return  await decoratee.request(url: url, method: method, body:body, headers:authorizedHeaders);
} on HttpError{
  rethrow;
}

catch (e) {
  throw HttpError.forbidden;
}
  }
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}
class HttpClientSpy extends Mock implements HttpClient {}

void main() {

  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  AuthorizeHttpClientDecorator sut;
  HttpClientSpy  httpClient;
  String url;
  String method;
  Map body;
  String token;
  String httpResponse;

  PostExpectation mockTokenCall()=> when(fetchSecureCacheStorage.fetchSecure(any));
  PostExpectation mockHttpResponseCall()=>
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      ),
    );

  void mockToken() {
    token = faker.guid.guid();

    mockTokenCall().thenAnswer((_) async => token);
  } 
 void mockTokenError() {

     mockTokenCall().thenThrow(Exception());
  } 
  void mockHttpResponseError(HttpError error) {

    mockHttpResponseCall().thenThrow(error);
  }


void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
mockHttpResponseCall().thenAnswer((_) async => httpResponse);
  }


 

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    httpClient=HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage: fetchSecureCacheStorage, decoratee:httpClient);
    url=faker.internet.httpUrl();
    method=faker.randomGenerator.string(10);
    body={'any-key':'any_value'};
    mockToken();
    mockHttpResponse();
  });
  test('Should call FetchSecureCacheStorage with correct key ', () async {
    await sut.request(url:url, method: method,body:body);

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
  
  test('Should call decorateee witg access token on header ', () async {
    await sut.request(url:url, method: method,body:body);
    verify(httpClient.request(url:url, method: method,body:body, headers:{'x-access-token':token})).called(1);   
    
    
    
    await sut.request(url:url, method: method,body:body, headers:{'any_header':'any_value'});
    verify(httpClient.request(url:url, method: method,body:body, headers:{'x-access-token':token,'any_header':'any_value'})).called(1);
  });




  test('Should  return same result a decoratee', () async {
   final response= await sut.request(url:url, method: method,body:body);

    expect(response, httpResponse);
  });


 test('Should  throw forBiddenError if FetchSecureCacheStorage throws', () async {
  mockTokenError();
   final future=  sut.request(url:url, method: method,body:body);

    expect(future, throwsA(HttpError.forbidden));
  }); 
  
  test('Should  rethrow  if decoratee throws', () async {
  mockHttpResponseError(HttpError.badRequest);
   final future=  sut.request(url:url, method: method,body:body);

    expect(future, throwsA(HttpError.badRequest));
  });

}
