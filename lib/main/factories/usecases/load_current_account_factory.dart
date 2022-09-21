import 'package:flutter_tdd_clean_architecture/data/usecases/load_current_account/load_current_account.dart';

import '../../../domain/usecases/usecases.dart';
import '../cache/cache.dart';


LoadCurrentAccount makeLocalLoadCurrentAccount() => LocalLoadCurrentAccount(fechSecureCacheStorage: makeLocalStorageAdapter());
