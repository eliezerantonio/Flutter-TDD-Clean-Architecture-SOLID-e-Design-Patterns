import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/save_current_account.dart';
import '../../cache/chache.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveCacheStorage;

  LocalSaveCurrentAccount({@required this.saveCacheStorage});

  Future<void> save(AccountEntity account) async {
    try {
      await saveCacheStorage.save(
          key: 'token', value: account.token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
