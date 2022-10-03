import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/cache/cache.dart';



SecureStorageAdapter makeSecureStorageAdapter() {
  final secureStorage = FlutterSecureStorage();

  return SecureStorageAdapter(secureStorage: secureStorage);
}
