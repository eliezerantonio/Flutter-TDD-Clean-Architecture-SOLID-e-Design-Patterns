import 'package:meta/meta.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class GetxSurveysPresenter {
  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    await loadSurveys.load();
  }
}

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  test('Should calll LoadSurveys on loadData', () async {
    final loadSurveys = LoadSurveysSpy();

    final sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    await sut.loadData();
    verify(loadSurveys.load()).called(1);
  });
}
