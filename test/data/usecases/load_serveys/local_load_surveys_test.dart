import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/data/models/local_survey_model.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({
    @required this.fetchCacheStorage,
  });

  Future<List<SurveyEntity>> load() async {

try {
   final data=await fetchCacheStorage.fetch('surveys');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return data
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

abstract class FetchCacheStorage {
  Future<dynamic> fetch(String key);
}

void main() {
  FetchCacheStorageSpy fetchCacheStorage;
  LocalLoadSurveys sut;
  List<Map> data;

  List<Map> mockValidData() => [
      {
       'id':faker.guid.guid(),
       'question':faker.randomGenerator.string(10),
       'date':'2012-02-27T00:00:00Z',
       'didAnswer':'false',
      },
       {
       'id':faker.guid.guid(),
       'question':faker.randomGenerator.string(10),
       'date':'2019-02-27T00:00:00Z',
       'didAnswer':'true',
      },
    ];

    PostExpectation mockFetchCall()=> when(fetchCacheStorage.fetch(any));


    void mockFetch(List<Map> list){
    data=list;
   mockFetchCall().thenAnswer((_) async => data);
    } 
    void mockFetchError()=>mockFetchCall().thenThrow(Exception());
    

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    mockFetch(mockValidData());
  });
  test('Should call fetchCacheStorage  with correct key', () async {
    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });

  test('Should return a list of surveys on success', () async {
    
    

    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(id: data[0]['id'], question: data[0]['question'], dateTime: DateTime.utc(2012,02,27), didAnswer: false),
      SurveyEntity(id: data[1]['id'], question: data[1]['question'], dateTime: DateTime.utc(2019,02,27), didAnswer: false)
    ]);
  }); 
  
   test('Should throw UnexpectedError if cache is empty', () async {
    
    mockFetch([]);

    final future =  sut.load();

    expect(future, throwsA(DomainError.unexpected) );
  }); 
  
  test('Should throw UnexpectedError if cache is null', () async {
    
    mockFetch(null);

    final future =  sut.load();

    expect(future, throwsA(DomainError.unexpected) );
  });
  
  test('Should throw UnexpectedError if cache is invalid', () async {
    
    mockFetch([{
       'id':faker.guid.guid(),
       'question':faker.randomGenerator.string(10),
       'date':'invlaid date',
       'didAnswer':'false',
      },]);

    final future =  sut.load();

    expect(future, throwsA(DomainError.unexpected) );
  });
  
  test('Should throw UnexpectedError if cache is incomplete', () async {
    
    mockFetch([{
       'question':faker.randomGenerator.string(10),
       'date':'2012-02-27T00:00:00Z',
     
      },]);

    final future =  sut.load();

    expect(future, throwsA(DomainError.unexpected) );
  });


    test('Should throw UnexpectedError if  cache throw ', () async {
    
    mockFetchError();

    final future =  sut.load();

    expect(future, throwsA(DomainError.unexpected) );
  });
}
