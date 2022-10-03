import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/data/cache/chache.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/usecases.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('Load', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveys sut;
    List<Map> data;

    List<Map> mockValidData() => [
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2012-02-27T00:00:00Z',
            'didAnswer': 'false',
          },
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2019-02-27T00:00:00Z',
            'didAnswer': 'true',
          },
        ];

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });
    test('Should call cacheStorage  with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
            id: data[0]['id'],
            question: data[0]['question'],
            dateTime: DateTime.utc(2012, 02, 27),
            didAnswer: false),
        SurveyEntity(
            id: data[1]['id'],
            question: data[1]['question'],
            dateTime: DateTime.utc(2019, 02, 27),
            didAnswer: false)
      ]);
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invlaid date',
          'didAnswer': 'false',
        },
      ]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch([
        {
          'question': faker.randomGenerator.string(10),
          'date': '2012-02-27T00:00:00Z',
        },
      ]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if  cache throw ', () async {
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('Validate', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveys sut;
    List<Map> data;

    List<Map> mockValidData() => [
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2012-02-27T00:00:00Z',
            'didAnswer': 'false',
          },
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2019-02-27T00:00:00Z',
            'didAnswer': 'true',
          },
        ];

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));
    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });
    test('Should call cacheStorage  with correct key', () async {
      await sut.validate();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should call delete cache if it is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invlaid date',
          'didAnswer': 'false',
        },
      ]);

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should call delete cache if it is incomplete', () async {
      mockFetch([
        {
          'date': '2019-02-27T00:00:00Z',
          'didAnswer': 'false',
        },
      ]);

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should call delete cache if it is throw', () async {
      mockFetchError();

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });
  });


  group('Save', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveys sut;
    List<SurveyEntity>surveys;



    List<SurveyEntity>mockSurveys()=>[

      SurveyEntity(id:faker.guid.guid(), dateTime: DateTime.utc(2022,2,2), didAnswer: true, question: faker.randomGenerator.string(10),),
      SurveyEntity(id:faker.guid.guid(), dateTime: DateTime.utc(2022,2,1), didAnswer: false, question: faker.randomGenerator.string(10),),
    ];

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      surveys=mockSurveys();
    });


  PostExpectation mockSaveCall() => when(cacheStorage.save(key:anyNamed('key'), value:anyNamed('value')));

   

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    test('Should call cacheStorage  with correct values', () async {
      final list=[

          {
            'id': surveys[0].id,
            'question': surveys[0].question,
            'date': '2022-02-02T00:00:00.000Z',
            'didAnswer': 'true',
          },
           {
            'id': surveys[1].id,
            'question': surveys[1].question,
            'date': '2022-02-01T00:00:00.000Z',
            'didAnswer': 'false',
          },
      ];
      await sut.save(surveys);

      verify(cacheStorage.save(key:'surveys', value:list)).called(1);
    });
    
    
     test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();
     final  future= sut.save(surveys);

     expect(future, throwsA(DomainError.unexpected));
    });

  });
}
