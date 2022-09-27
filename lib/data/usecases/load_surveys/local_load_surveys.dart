import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/chache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements LoadSurveys{
  final CacheStorage cacheStorage;

  LocalLoadSurveys({
    @required this.cacheStorage,
  });

  Future<List<SurveyEntity>> load() async {

try {
   final data=await cacheStorage.fetch('surveys');
      if (data?.isEmpty != false) {
        throw Exception();
      }
   return _map(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate()async{

try{
 final data =await cacheStorage.fetch('surveys');



_map(data);
}catch (error) {
  await cacheStorage.delete('surveys');
}
  }

  List<SurveyEntity>_map(List<Map>list)=>list.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
}