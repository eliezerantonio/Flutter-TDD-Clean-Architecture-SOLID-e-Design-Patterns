import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:meta/meta.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult{
  RemoteSaveSurveyResult({@required this.url, @required this.httpClient});
  final String url;

  final HttpClient httpClient;

  Future<SurveyResultEntity> save({String answer}) async {
    try {
   final json=   await httpClient.request(url: url, method: 'put', body: {'answer': answer});
   
    return  RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
