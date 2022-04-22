import 'package:flutter_tdd_clean_architecture/factories/cache/cache.dart';

import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/save_current_account.dart';

SaveCurrentAccount makeLocalCurrentAccount() {
  return LocalSaveCurrentAccount(
    saveSecureCacheStorage: makeLocalStorageAdapter(),
  );
}
