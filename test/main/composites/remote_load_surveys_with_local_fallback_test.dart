import 'package:flutter_tdd_clean_architecture/data/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
class RemoteLoadSurveysWithLocalFallback{

  final RemoteLoadSurveys remoteLoadSurveys;

  RemoteLoadSurveysWithLocalFallback({@required this.remoteLoadSurveys});

  Future<void> load()async{
    remoteLoadSurveys.load();
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys{

}

 void main(){
  test('Should call remote load',()async{

    final remote =RemoteLoadSurveysSpy();

    final sut=RemoteLoadSurveysWithLocalFallback(remoteLoadSurveys:remote);

    await sut.load();

    verify(remote.load()).called(1);
    });
 }