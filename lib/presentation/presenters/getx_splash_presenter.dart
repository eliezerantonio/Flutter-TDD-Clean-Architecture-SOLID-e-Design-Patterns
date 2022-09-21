import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  GetxSplashPresenter({@required this.loadCurrentAccount});
  LoadCurrentAccount loadCurrentAccount;

  var _navigateTo = RxString('');

  @override
  Future<void> checkAccount({int durationInSeconds=2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value = account?.token == null ? '/login' : '/surveys';
    } catch (e) {
      
      _navigateTo.value = '/login';
    }
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;
}
