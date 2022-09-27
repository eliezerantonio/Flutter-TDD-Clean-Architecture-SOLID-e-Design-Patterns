import 'package:flutter/cupertino.dart';

abstract class CacheStorage {
  Future<dynamic> fetch(String key);
  Future<ViewportBuilder> delete(String key);
}
