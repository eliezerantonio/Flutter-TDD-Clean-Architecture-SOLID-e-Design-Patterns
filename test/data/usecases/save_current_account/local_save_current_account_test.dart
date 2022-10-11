import 'package:faker/faker.dart';

import 'package:flutter_tdd_clean_architecture/data/cache/chache.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/usecases.dart';

import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';



class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveCacheStorage;
  AccountEntity account;

  setUp(() {
    saveCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveCacheStorage: saveCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  void mockError() {
    when(saveCacheStorage.save(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('Should call SaveSecureCacheStorage with currect values', () async {
    await sut.save(account);

    verify(
        saveCacheStorage.save(key: 'token', value: account.token));
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
