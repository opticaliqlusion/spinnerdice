import 'dart:math' as math;
import 'settings_state.dart';

class GameState {
  final SettingsState settings;
  bool isSpinnerMode;
  int maxValue;
  int numDice;
  List<int> selectedNumbers;
  double spinAngle;
  double spinVelocity;
  bool isHolding;
  final math.Random random;

  GameState({
    this.settings = const SettingsState(),
    this.isSpinnerMode = true,
    this.maxValue = 6,
    this.numDice = 1,
    this.selectedNumbers = const [],
    this.spinAngle = 0.0,
    this.spinVelocity = 0.0,
    this.isHolding = false,
  }) : random = math.Random.secure();

  GameState copyWith({
    bool? isSpinnerMode,
    int? maxValue,
    int? numDice,
    List<int>? selectedNumbers,
    double? spinAngle,
    double? spinVelocity,
    bool? isHolding,
    SettingsState? settings,
  }) {
    return GameState(
      settings: settings ?? this.settings,
      isSpinnerMode: isSpinnerMode ?? this.isSpinnerMode,
      maxValue: maxValue ?? this.maxValue,
      numDice: numDice ?? this.numDice,
      selectedNumbers: selectedNumbers ?? this.selectedNumbers,
      spinAngle: spinAngle ?? this.spinAngle,
      spinVelocity: spinVelocity ?? this.spinVelocity,
      isHolding: isHolding ?? this.isHolding,
    );
  }
}
