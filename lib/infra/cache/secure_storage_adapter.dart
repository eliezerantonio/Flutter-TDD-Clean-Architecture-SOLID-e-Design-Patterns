import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/chache.dart';

class SecureStorageAdapter implements SaveSecureCacheStorage, FetchSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorageAdapter({@required this.secureStorage});
  @override
  Future<void> saveSecure({String key, String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String> fetchSecure(String key) async {
    return await secureStorage.read(key: key);
  }
}
