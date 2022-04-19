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
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  void mockError() {
    when(saveSecureCacheStorage.saveSecure(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('Should call SaveSecureCacheStorage with currect values', () async {
    await sut.save(account);

    verify(
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test(
      'Should throw UnexpectedError if SaveSecureCacheStorage with correct values',
      () async {
    mockError();
    print(account);
    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
