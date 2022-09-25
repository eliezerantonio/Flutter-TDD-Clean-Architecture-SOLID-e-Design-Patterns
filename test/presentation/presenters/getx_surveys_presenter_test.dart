import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';

class GetxSurveysPresenter {
  final LoadSurveys loadSurveys;
  final _isLoading = true.obs;
  final _surveys = Rx<List<SurveyViewModel>>([]);

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<SurveyViewModel>> get loadSurveysStrem => _surveys.stream;

  GetxSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    _isLoading.value = true;
    final surveys = await loadSurveys.load();
    _surveys.value = surveys
        .map((survey) => SurveyViewModel(
            id: survey.id,
            question: survey.question,
            date: DateFormat('dd MMM yyy').format(survey.dateTime),
            didAnswer: survey.didAnswer))
        .toList();

    _isLoading.value = false;
  }
}

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  LoadSurveysSpy loadSurveys;
  GetxSurveysPresenter sut;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2022, 08, 23),
            didAnswer: true),
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2021, 10, 13),
            didAnswer: false)
      ];

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    when(loadSurveys.load()).thenAnswer((_) async => data);
  }

  setUp(() {
    loadSurveys = LoadSurveysSpy();

    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });
  test('Should calll LoadSurveys on loadData', () async {
    await sut.loadData();
    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.loadSurveysStrem.listen(
      expectAsync1(
        (surveys) => expect(
          surveys,
          [
            SurveyViewModel(
                id: surveys[0].id,
                question: surveys[0].question,
                date: '23 Ago 2022',
                didAnswer: surveys[0].didAnswer),
            SurveyViewModel(
                id: surveys[1].id,
                question: surveys[1].question,
                date: '13 Out 2021',
                didAnswer: surveys[1].didAnswer)
          ],
        ),
      ),
    );

    await sut.loadData();
  });
}
