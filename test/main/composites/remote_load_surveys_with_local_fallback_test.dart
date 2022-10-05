import 'package:faker/faker.dart';
import 'package:flutter_tdd_clean_architecture/data/usecases/usecases.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/entities.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/load_surveys.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteLoadSurveysWithLocalFallback  implements LoadSurveys {
  final RemoteLoadSurveys remoteLoadSurveys;
  final LocalLoadSurveys localLoadSurveys;

  RemoteLoadSurveysWithLocalFallback({@required this.remoteLoadSurveys, @required this.localLoadSurveys});

  Future<List<SurveyEntity>> load() async {
    final surveys= await remoteLoadSurveys.load();
    await  localLoadSurveys.save(surveys);

    return surveys;
  } 
  

}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysSpy remote;
  LocalLoadSurveysSpy local;

  RemoteLoadSurveysWithLocalFallback sut;
  List<SurveyEntity> remoteSurveys;


  List<SurveyEntity> mockSurveys()=>[SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(10), dateTime: faker.date.dateTime(), didAnswer: faker.randomGenerator.boolean())];
  

  void mockRemoteLoad(){
    remoteSurveys=mockSurveys();
    when(remote.load()).thenAnswer((_) async => remoteSurveys);
  }
  
  setUp(() {

    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remoteLoadSurveys: remote, localLoadSurveys:local);


    mockRemoteLoad();

  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  }); 
  
  
  test('Should call  save with remote data', () async {
    await sut.load();

    verify(local.save(remoteSurveys)).called(1);
  }); 
  
   test('Should  return remote data', () async {
    final surveys =await sut.load();

  expect(surveys, remoteSurveys);
  });
}
