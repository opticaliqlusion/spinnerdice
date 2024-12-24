import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;
import '../constants/theme.dart';
import '../controllers/game_controller.dart';
import '../widgets/spinner_display.dart';
import '../widgets/dice_display.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late GameController _controller;
  late AnimationController _animationController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = GameController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    );
    _controller.setAnimationController(_animationController);
    
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    
    // Listen for spinner stops to trigger confetti
    _controller.addListener(() {
      if (_controller.showResult) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Particle background
          CircularParticle(
            key: UniqueKey(),
            awayRadius: 80,
            numberOfParticles: 50,
            speedOfParticles: 1,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            onTapAnimation: true,
            particleColor: AppTheme.primaryColor.withAlpha(150),
            awayAnimationDuration: const Duration(milliseconds: 600),
            maxParticleSize: 8,
            isRandSize: true,
            isRandomColor: true,
            randColorList: AppTheme.particleColors,
            awayAnimationCurve: Curves.easeInOutBack,
            enableHover: true,
            hoverColor: AppTheme.secondaryColor,
            hoverRadius: 90,
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: math.pi / 2,
              maxBlastForce: 20,
              minBlastForce: 10,
              emissionFrequency: 0.5,
              numberOfParticles: 20,
              gravity: 0.3,
              shouldLoop: false,
              colors: SpinnerDisplay.segmentColors,
            ),
          ),
          SafeArea(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                final state = _controller.state;
                return Column(
                  children: [
                    // Mode Toggle
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Spinner', style: TextStyle(fontSize: 20)),
                          Switch(
                            value: !state.isSpinnerMode,
                            onChanged: _controller.onModeChanged,
                          ),
                          const Text('Dice', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),

                    // Main Display Area
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onLongPressStart: (_) => _controller.onHoldStart(),
                          onLongPressEnd: (_) => _controller.onHoldEnd(),
                          onTapDown: (_) => _controller.onHoldStart(),
                          onTapUp: (_) => _controller.onHoldEnd(),
                          onTapCancel: _controller.onHoldEnd,
                          behavior: HitTestBehavior.opaque,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: state.isSpinnerMode
                                ? SpinnerDisplay(
                                    spinAngle: state.spinAngle,
                                    selectedNumbers: state.selectedNumbers,
                                    isHolding: state.isHolding,
                                    maxValue: state.maxValue,
                                    showResult: _controller.showResult,
                                  )
                                : DiceDisplay(
                                    selectedNumbers: state.selectedNumbers,
                                    isHolding: state.isHolding,
                                  ),
                          ),
                        ),
                      ),
                    ),

                    // Value Sliders
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (state.isSpinnerMode) ...[
                            Text(
                              'Max Number: ${state.maxValue}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Slider(
                              value: state.maxValue.toDouble(),
                              min: 2,
                              max: 12,
                              divisions: 10,
                              onChanged: _controller.onMaxValueChanged,
                            ),
                          ] else ...[
                            Text(
                              'Number of Dice: ${state.numDice}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Slider(
                              value: state.numDice.toDouble(),
                              min: 1,
                              max: 6,
                              divisions: 5,
                              onChanged: _controller.onNumDiceChanged,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
