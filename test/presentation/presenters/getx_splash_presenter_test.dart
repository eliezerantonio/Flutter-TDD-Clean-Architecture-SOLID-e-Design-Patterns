import 'package:flutter_tdd_clean_architecture/domain/usecases/load_current_account.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/state_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class GetxSplashPresenter implements SplashPresenter {
  GetxSplashPresenter({@required this.loadCurrentAccount});
  LoadCurrentAccount loadCurrentAccount;

  var _navigateTo = RxString('');

  @override
  Future<void> checkAccount() async {
    await loadCurrentAccount.load();
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });
  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(loadCurrentAccount.load()).called(1);
  });
}
