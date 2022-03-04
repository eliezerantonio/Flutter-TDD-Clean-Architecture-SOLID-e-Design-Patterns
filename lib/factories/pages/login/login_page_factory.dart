import 'package:flutter/material.dart';

import '../../../presentation/presenters/presenters.dart';
import '../../../ui/pages/pages.dart';

Widget makeLoginPage() {

  final ValidationComposite = new ValidationComposite()
  final streamLoginPresenter = StreamLoginPresenter(
    authentication: remoteAuthentication,
    validation: validationComposite,
  );

  return LoginPage(streamLoginPresenter);
}
