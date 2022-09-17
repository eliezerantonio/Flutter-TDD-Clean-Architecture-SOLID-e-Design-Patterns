import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static Translations string = PtPt();

  static void load(Locale locale) {
    switch (locale.toString()) {
      case 'en_Us':
        string = EnUs();
        break;
      default:
        string = PtPt();
        break;
    }
  }
}
