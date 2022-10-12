import 'package:meta/meta.dart';

import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';

class RemoteSaveSurveyResult {
  RemoteSaveSurveyResult({@required this.url, @required this.httpClient});
  final String url;

  final HttpClient httpClient;

  Future<void> save({String answer}) async {
    try {
      await httpClient.request(url: url, method: 'put', body: {'answer': answer});
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
