import 'package:flutter_tdd_clean_architecture/main/decorators/autorize_http_client_decorator.dart';
import 'package:flutter_tdd_clean_architecture/main/factories/cache/local_storage_adapter_factory.dart';
import 'package:flutter_tdd_clean_architecture/main/factories/http/http_client_factory.dart';

import '../../../data/http/http.dart';


HttpClient makeAuthorizeHttpClientDecorator() {


  return AuthorizeHttpClientDecorator(decoratee:makeHttpAdapter(), fetchSecureCacheStorage: makeLocalStorageAdapter());
}
