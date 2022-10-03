import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';


class LocalStorageAdapter {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }


  Future<void>delete(String key)async{
  await localStorage.deleteItem(key);

  }
  
   Future<void>fetch(String key)async{
 
   localStorage.getItem(key);
  }
}