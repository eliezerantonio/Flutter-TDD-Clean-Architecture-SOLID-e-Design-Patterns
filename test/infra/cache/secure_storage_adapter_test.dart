import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tdd_clean_architecture/infra/cache/cache.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  FlutterSecureStorageSpy secureStorage;
  SecureStorageAdapter sut;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('save', () {
    mockSaveSecureError() {


      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());

    }

    test('Should call save secure with currect values', () async {
      await sut.save(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () async {
      mockSaveSecureError();
      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    PostExpectation mockFetchSecureCall() => when(secureStorage.read(key: anyNamed('key')));
    void mockFetchSecure() {
      mockFetchSecureCall().thenAnswer((_) async => value);
    }

    mockFetchSecureError() {
      mockFetchSecureCall().thenThrow(Exception());
    }

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure with correct value', () async {
      sut.fetch(key);

      verify(secureStorage.read(key: key));
    });
    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);

      expect(fetchedValue, value);
    });


    test('Should throw if fetch secure throws', () async {
      mockFetchSecureError();
      final future =  sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });



group('Delete', () {

mockSaveSecureError() {


      when(secureStorage.delete(key: anyNamed('key'),)).thenThrow(Exception());

    }
    test('Should call delete with correct key', () async {
      await sut.delete(key);

      verify(secureStorage.delete(key:key)).called(1);
    });

    test('Should theow if deleteItem throws ', () async {
      mockSaveSecureError();
      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });                                          
}
