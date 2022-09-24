import 'package:flutter/material.dart';

ThemeData makeAppATheme() {
  final primaryColor = Color.fromRGBO(136, 14, 79, 1);
  final primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  final primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  final secondaryColor = Color.fromRGBO(0, 77, 64, 1);
  final secondaryColorDark = Color.fromRGBO(0, 37, 26, 1);

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    backgroundColor: Colors.white,
    secondaryHeaderColor:secondaryColorDark,
   appBarTheme: AppBarTheme(backgroundColor:primaryColor),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: primaryColorDark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColorLight),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      alignLabelWithHint: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
        overlayColor: MaterialStateProperty.all(primaryColorLight),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
  );
}
