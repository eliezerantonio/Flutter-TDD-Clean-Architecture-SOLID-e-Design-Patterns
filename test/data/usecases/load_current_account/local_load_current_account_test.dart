import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FechSecureCacheStorage fechSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fechSecureCacheStorage});
  Future<AccountEntity> load() async {
    final token = await fechSecureCacheStorage.fetchSecure('token');

    return new AccountEntity(token);
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

  void mockFetchSecure() {
    when(fechSecureCacheStorage.fetchSecure(any))
        .thenAnswer((_) async => token);
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
}
