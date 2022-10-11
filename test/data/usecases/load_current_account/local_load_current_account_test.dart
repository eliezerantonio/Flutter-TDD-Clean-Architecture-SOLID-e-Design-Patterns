import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'package:flutter_tdd_clean_architecture/data/cache/chache.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/usecases.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';

class FechSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  LocalLoadCurrentAccount sut;
  FechSecureCacheStorageSpy fechSecureCacheStorage;
  String token;
  PostExpectation mockSecureCall() =>
      when(fechSecureCacheStorage.fetch(any));
  void mockFetchSecure() {
    mockSecureCall().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    mockSecureCall().thenThrow(Exception);
  }

  setUp(() {
    fechSecureCacheStorage = FechSecureCacheStorageSpy();
    sut =
        LocalLoadCurrentAccount(fechSecureCacheStorage: fechSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecure();
  });

  test('Should call FetchSecureCaheStorage with currect value', () async {
    await sut.load();
    verify(fechSecureCacheStorage.fetch('token'));
  });
  test('Should return an AccountEntity', () async {
    final account = await sut.load();
    expect(account, AccountEntity(token));
  });
  test('Should throw UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    mockFetchSecureError();
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
