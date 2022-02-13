
import 'package:flutter/material.dart';

class Headline1 extends StatelessWidget {
  const Headline1(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
