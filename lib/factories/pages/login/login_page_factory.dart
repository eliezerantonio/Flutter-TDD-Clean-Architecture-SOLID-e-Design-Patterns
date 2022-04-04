

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../data/usecases/usecases.dart';
import '../../../infra/http.dart';
import '../../../presentation/presenters/presenters.dart';
import '../../../ui/pages/pages.dart';
import '../../../validation/validators/validators.dart';

Widget makeLoginPage() {
  final validationComposite = new ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ]);
  
  final url = 'http://fordevs/herokuapp.com/api/login';
  final client = Client();
  final httpAdapter = HttpAdapter(client);

  final remoteAuthentication =
      new RemoteAuthentication(httpClient: httpAdapter, url: url);

  final streamLoginPresenter = StreamLoginPresenter(
    authentication: remoteAuthentication,
    validation: validationComposite,
  );

  return LoginPage(streamLoginPresenter);
}
