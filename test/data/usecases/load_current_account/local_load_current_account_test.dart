import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FechSecureCacheStorage fechSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fechSecureCacheStorage});
  Future<AccountEntity> load() async {
    try {
      final token = await fechSecureCacheStorage.fetchSecure('token');
      return AccountEntity(token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class FechSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class FechSecureCacheStorageSpy extends Mock implements FechSecureCacheStorage {
}

void main() {
  LocalLoadCurrentAccount sut;
  FechSecureCacheStorageSpy fechSecureCacheStorage;
  String token;
  PostExpectation mockSecureCall() =>
      when(fechSecureCacheStorage.fetchSecure(any));
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
    verify(fechSecureCacheStorage.fetchSecure('token'));
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
