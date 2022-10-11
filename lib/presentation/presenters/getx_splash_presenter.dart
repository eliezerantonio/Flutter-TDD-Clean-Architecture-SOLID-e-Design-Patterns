import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSplashPresenter extends  GetxController with NavigationManager implements SplashPresenter {
  GetxSplashPresenter({@required this.loadCurrentAccount});
  LoadCurrentAccount loadCurrentAccount;



  @override
  Future<void> checkAccount({int durationInSeconds=2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();
      navigateTo = account?.token == null ? '/login' : '/surveys';
    } catch (e) {
      
      navigateTo = '/login';
    }
  }

  
}
