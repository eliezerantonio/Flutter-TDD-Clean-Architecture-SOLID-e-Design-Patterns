import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/chache.dart';

class SecureStorageAdapter implements SaveSecureCacheStorage, FetchSecureCacheStorage, DeleteSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorageAdapter({@required this.secureStorage});
  @override
  Future<void> save({String key, String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String> fetch(String key) async {
    return await secureStorage.read(key: key);
  }
   @override
  Future<void> delete(String key) async {
     await secureStorage.delete(key: key);
  }
}
