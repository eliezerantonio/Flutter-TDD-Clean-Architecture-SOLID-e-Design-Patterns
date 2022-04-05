import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/factories/pages/login/login_presenter_factory.dart';

import '../../../ui/pages/pages.dart';

Widget makeLoginPage() {
  return LoginPage(makeGetxLoginPresenter());
}
