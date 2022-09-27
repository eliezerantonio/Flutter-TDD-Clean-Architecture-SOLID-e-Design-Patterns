import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
class LocalLoadSurveys{
final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage,});

  Future<void> load()async{
    fetchCacheStorage.fetch('surveys');

  }
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage{}

abstract class FetchCacheStorage{

Future<void>fetch(String key);

}


 void main(){
  test('Should call fetchCacheStorage  with correct key',()async{
    final fetchCacheStorage =FetchCacheStorageSpy();
    final sut=LocalLoadSurveys(fetchCacheStorage:fetchCacheStorage);

    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);


    });
 }