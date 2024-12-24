import 'package:flutter/material.dart';
import 'constants/theme.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const SpinnerDiceApp());
}

class SpinnerDiceApp extends StatelessWidget {
  const SpinnerDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spinner & Dice',
      theme: AppTheme.theme,
      home: const GameScreen(),
    );
  }
}
