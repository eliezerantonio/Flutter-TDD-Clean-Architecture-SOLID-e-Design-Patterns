import 'package:flutter_tdd_clean_architecture/data/cache/fetch_secure_cache_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class AuthorizeHttpClientDecorator{

  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage});

  Future<void>request()async{
    fetchSecureCacheStorage.fetchSecure('token');


  }
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage

{

}
void main(){

  test('Should call FetchSecureCacheStorage with correct key ',()async{
  final fetchSecureCacheStorage= FetchSecureCacheStorageSpy();
  final sut=AuthorizeHttpClientDecorator(fetchSecureCacheStorage:fetchSecureCacheStorage);

  await sut.request();

  verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}