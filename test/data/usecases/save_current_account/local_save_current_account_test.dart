import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/save_current_account.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});

  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(
          key: 'token', value: account.token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({@required String key, @required String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  test('Should call SaveCacheStorage with currect values', () async {
    final saveCachedStorage = SaveSecureCacheStorageSpy();
    final sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveCachedStorage);
    final account = AccountEntity(faker.guid.guid());

    await sut.save(account);

    verify(saveCachedStorage.saveSecure(key: 'token', value: account.token));
  });
  test(
      'Should throw UnexpectedError if SaveSecureCacheStorage with correct values',
      () async {
    final saveSecureCachedStorage = SaveSecureCacheStorageSpy();
    final sut = LocalSaveCurrentAccount(
        saveSecureCacheStorage: saveSecureCachedStorage);
    final account = AccountEntity(faker.guid.guid());
    when(saveSecureCachedStorage.saveSecure(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
