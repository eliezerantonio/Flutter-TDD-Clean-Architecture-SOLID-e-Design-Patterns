import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static Translations strings = PtPt();

  static void load(Locale locale) {
    switch (locale.toString()) {
      case 'en_Us':
        strings = EnUs();
        break;
      default:
        strings = PtPt();
        break;
    }
  }
}
