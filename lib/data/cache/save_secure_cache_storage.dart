import 'package:flutter/foundation.dart';

abstract class SaveSecureCacheStorage {
  Future<void> save({@required String key, @required String value});
}
