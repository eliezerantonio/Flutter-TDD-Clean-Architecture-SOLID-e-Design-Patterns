import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/chache.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fechSecureCacheStorage;

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
