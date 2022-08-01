import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import 'splash_presenter_factory.dart';

Widget makeSplashPage() {
  return SplashPage(presenter:makeGetxSplashPresenter());
}
