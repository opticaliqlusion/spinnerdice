import 'dart:math' as math;

class GameState {
  bool isSpinnerMode;
  int maxValue;
  int numDice;
  List<int> selectedNumbers;
  double spinAngle;
  double spinVelocity;
  bool isHolding;
  final math.Random random;

  GameState({
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
  }) {
    return GameState(
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
