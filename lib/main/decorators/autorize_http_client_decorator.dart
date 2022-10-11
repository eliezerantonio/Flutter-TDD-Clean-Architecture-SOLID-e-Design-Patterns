import 'package:meta/meta.dart';

import '../../data/cache/chache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator  implements HttpClient{
  final FetchSecureCacheStorage fetchCacheStorage;
  final DeleteSecureCacheStorage deleteCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({@required this.fetchCacheStorage,@required this.deleteCacheStorage, @required this.decoratee});

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
    
  }) async {
   try {
  
    final token= await fetchCacheStorage.fetch('token');
    final authorizedHeaders= headers?? {}..addAll( {'x-access-token':token});
    return  await decoratee.request(url: url, method: method, body:body, headers:authorizedHeaders);
   }
    catch (error) {
      if(error is HttpError && error !=HttpError.forbidden){
         rethrow;
      }
  await deleteCacheStorage.delete('token');
    
   throw HttpError.forbidden;

}
  }
}
