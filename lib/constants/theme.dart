import 'package:flutter/material.dart';

class AppTheme {
  static const backgroundColor = Color(0xFFFFE5F1);
  static const primaryColor = Colors.purple;
  static const secondaryColor = Colors.pink;

  static ThemeData get theme => ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          background: backgroundColor,
        ),
      );

  static List<Color> get particleColors => [
        primaryColor.withAlpha(150),
        secondaryColor.withAlpha(150),
        Colors.blue.withAlpha(150),
      ];

  static BoxDecoration spinnerDecoration(BuildContext context) => BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      );

  static BoxDecoration diceDecoration(BuildContext context) => BoxDecoration(
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      );
}
