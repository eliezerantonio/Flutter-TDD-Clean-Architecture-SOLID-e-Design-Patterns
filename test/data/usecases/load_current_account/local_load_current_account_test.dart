import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalLoadCurrentAccount {
  final FechSecureCacheStorage fechSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fechSecureCacheStorage});
  Future<void> load() async {
    await fechSecureCacheStorage.fetchSecure('token');
  }
}

abstract class FechSecureCacheStorage {
  Future<void> fetchSecure(String key);
}

class FechSecureCacheStorageSpy extends Mock implements FechSecureCacheStorage {
}

void main() {
  test('Should call FetchSecureCaheStorage with currect value', () async {
    final fechSecureCacheStorage = FechSecureCacheStorageSpy();
    final sut = LocalLoadCurrentAccount(fechSecureCacheStorage: fechSecureCacheStorage);
    await sut.load();
    verify(fechSecureCacheStorage.fetchSecure('token'));
  });
}
