import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import '../models/game_state.dart';
import '../models/settings_state.dart';

class GameController extends ChangeNotifier {
  GameState _state;
  AnimationController? _animationController;
  bool _isAnimating = false;
  bool _showResult = false;
  Timer? _resultTimer;

  GameController() : _state = GameState();

  GameState get state => _state;
  bool get showResult => _showResult;
  bool get isInteractionDisabled => _isAnimating || _showResult;

  void setAnimationController(AnimationController controller) {
    _animationController = controller;
    _animationController?.addListener(_updateAnimation);
  }

  // Calculate the segment number based on final angle
int _calculateSegmentNumber(double angle) {
  print('\nCalculating segment number:');
  print('Raw angle: ${angle.toStringAsFixed(3)} radians');
  
  // Normalize angle to [0, 2π)
  double normalizedAngle = (angle % (2 * math.pi) + 2 * math.pi) % (2 * math.pi);
  print('Normalized angle: ${normalizedAngle.toStringAsFixed(3)} radians');
  
  // Calculate segment size in radians
  double segmentAngle = (2 * math.pi) / _state.maxValue;
  print('Segment size: ${segmentAngle.toStringAsFixed(3)} radians');
  
  // Determine segment number (1-based index)
  int segmentNumber = (normalizedAngle / segmentAngle).floor() + 1;
  print('Final segment number: $segmentNumber');
  
  return segmentNumber;
}

  void _updateAnimation() {
    if (!_isAnimating) return;
    
    if (_state.isHolding) {
      // Increase velocity while holding
      _updateState(spinVelocity: math.min(_state.spinVelocity + 0.5, 20.0));
    } else if (_state.spinVelocity > 0) {
      // Gradually slow down when released
      _updateState(spinVelocity: math.max(0, _state.spinVelocity - 0.2));
    }
    
    if (_state.spinVelocity > 0) {
      if (_state.isSpinnerMode) {
        // Only update the spin angle while spinning
        double newAngle = _state.spinAngle + _state.spinVelocity * 0.1;
        _updateState(spinAngle: newAngle);
      } else {
        // Use a new Random instance each time for true randomness
        final diceRandom = math.Random();
        _updateState(
          selectedNumbers: List.generate(
            _state.numDice,
            (_) => diceRandom.nextInt(6) + 1,
          ),
        );
      }
    }

    // When spinner stops
    if (_state.spinVelocity <= 0 && !_state.isHolding && _isAnimating) {
      _isAnimating = false;
      _animationController?.stop();
      
      if (_state.isSpinnerMode) {
        print('\nSpinner stopped at angle: ${_state.spinAngle.toStringAsFixed(3)} radians');
        // Calculate final segment number only when spinner stops
        final segmentNumber = _calculateSegmentNumber(_state.spinAngle);
        _updateState(selectedNumbers: [segmentNumber]);
      }
      
      // Show result with fireworks
      _showResult = true;
      notifyListeners();
      
      // Hide result after delay
      _resultTimer?.cancel();
      _resultTimer = Timer(const Duration(milliseconds: 2000), () {
        _showResult = false;
        notifyListeners();
      });
    }
  }

  void _updateState({
    bool? isSpinnerMode,
    int? maxValue,
    int? numDice,
    List<int>? selectedNumbers,
    double? spinAngle,
    double? spinVelocity,
    bool? isHolding,
    SettingsState? settings,
  }) {
    _state = _state.copyWith(
      settings: settings,
      isSpinnerMode: isSpinnerMode,
      maxValue: maxValue,
      numDice: numDice,
      selectedNumbers: selectedNumbers,
      spinAngle: spinAngle,
      spinVelocity: spinVelocity,
      isHolding: isHolding,
    );
    notifyListeners();
  }

  void onModeChanged(bool isDiceMode) {
    _updateState(
      isSpinnerMode: !isDiceMode,
      selectedNumbers: [],
      spinAngle: 0.0,
      spinVelocity: 0.0,
    );
    _isAnimating = false;
    _animationController?.stop();
  }

  void onMaxValueChanged(double value) {
    _updateState(
      maxValue: value.round(),
      selectedNumbers: [],
    );
  }

  void onNumDiceChanged(double value) {
    _updateState(
      numDice: value.round(),
      selectedNumbers: [],
    );
  }

  void onHoldStart() {
    // Random initial velocity between 10-20 for more unpredictable spins
    final random = math.Random();
    final initialVelocity = 10.0 + random.nextDouble() * 10.0;
    
    _updateState(
      isHolding: true,
      selectedNumbers: [],
      spinVelocity: initialVelocity,
    );
    _isAnimating = true;
    _animationController?.repeat();
  }

  void onHoldEnd() {
    _updateState(isHolding: false);
  }

  void onParticleEffectsChanged(bool enabled) {
    final newSettings = _state.settings.copyWith(
      particleEffectsEnabled: enabled,
    );
    _state = _state.copyWith(settings: newSettings);
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _resultTimer?.cancel();
    super.dispose();
  }
}
