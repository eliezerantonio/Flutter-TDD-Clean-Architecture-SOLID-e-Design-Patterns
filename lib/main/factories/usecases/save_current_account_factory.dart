

import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../cache/cache.dart';


SaveCurrentAccount makeLocalCurrentAccount() {
  return LocalSaveCurrentAccount(
    saveSecureCacheStorage: makeLocalStorageAdapter(),
  );
}
