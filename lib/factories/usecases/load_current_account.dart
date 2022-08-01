import 'package:flutter_tdd_clean_architecture/data/usecases/load_current_account/load_current_account.dart';
import 'package:flutter_tdd_clean_architecture/factories/cache/cache.dart';

import '../../domain/usecases/usecases.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
      fechSecureCacheStorage: makeLocalStorageAdapter());
}
