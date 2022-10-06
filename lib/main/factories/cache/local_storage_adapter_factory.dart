
import 'package:localstorage/localstorage.dart';

import '../../../infra/cache/cache.dart';




LocalStorageAdapter makeLocalStorageAdapter() {
  

  return LocalStorageAdapter(localStorage: LocalStorage('fordev'));
}
