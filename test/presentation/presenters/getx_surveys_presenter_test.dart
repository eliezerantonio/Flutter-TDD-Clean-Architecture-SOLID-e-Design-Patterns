import 'package:faker/faker.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd_clean_architecture/domain/usecases/usecases.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/helpers/helpers.dart';
import 'package:flutter_tdd_clean_architecture/presentation/presenters/presenters.dart';
import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/errors.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';


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


PostExpectation  mockLoadSurveysCall()=> when(loadSurveys.load());
  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
   mockLoadSurveysCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveysError()=>mockLoadSurveysCall().thenThrow(DomainError.unexpected);

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
  
  test('Should emit correct events on failure', () async {
    mockLoadSurveysError();
    sut.loadSurveysStrem.listen(null,onError:
      expectAsync1(
        (error) => expect(
          error,
          UIError.unexpected.description
        ),
      ),
    );

    await sut.loadData();
  });
}
