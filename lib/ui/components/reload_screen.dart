
import 'package:flutter/material.dart';

import '../helpers/i18n/i18n.dart';

class ReloadScreen extends StatelessWidget {
   ReloadScreen({
    @required this.reload,
    @required this.error,
  });

  final String error;
  final Future<void> Function() reload;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(error, style:TextStyle(fontSize: 16,), textAlign: TextAlign.center),
        SizedBox(height:10),
        ElevatedButton(onPressed: reload, child: Text(R.string.reload))
      ]),
    );
  }
}
