import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;
import '../constants/theme.dart';
import '../controllers/game_controller.dart';
import '../widgets/spinner_display.dart';
import '../widgets/dice_display.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/explainer_dialog.dart';

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
    
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    // Listen for spinner stops to trigger confetti
    _controller.addListener(() {
      if (_controller.showResult && _controller.state.settings.particleEffectsEnabled) {
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
          // Enhanced Particle background (only when enabled)
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              if (!_controller.state.settings.particleEffectsEnabled) {
                return const SizedBox.shrink();
              }
              return CircularParticle(
                key: UniqueKey(),
                awayRadius: 120,
                numberOfParticles: 100,
                speedOfParticles: 2.5,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                onTapAnimation: true,
                particleColor: AppTheme.primaryColor.withAlpha(150),
                awayAnimationDuration: const Duration(milliseconds: 400),
                maxParticleSize: 12,
                isRandSize: true,
                isRandomColor: true,
                randColorList: AppTheme.particleColors,
                awayAnimationCurve: Curves.easeInOutBack,
                enableHover: true,
                hoverColor: AppTheme.secondaryColor,
                hoverRadius: 150,
                connectDots: true,
              );
            },
          ),
          // Enhanced Confetti effects - bursting from center (only when enabled)
          if (_controller.state.settings.particleEffectsEnabled) ...[
            // Upward burst
            Center(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -math.pi / 2, // Upward
                blastDirectionality: BlastDirectionality.explosive,
                maxBlastForce: 60,
                minBlastForce: 30,
                emissionFrequency: 0.5,
                numberOfParticles: 60,
                gravity: 0.2,
                shouldLoop: false,
                colors: SpinnerDisplay.segmentColors,
                createParticlePath: (size) {
                  final path = Path();
                  // Star shape
                  for (var i = 0; i < 5; i++) {
                    final angle = (i * 4 * math.pi) / 5;
                    final point = Offset(
                      size.width / 2 + math.cos(angle) * size.width / 2,
                      size.height / 2 + math.sin(angle) * size.height / 2,
                    );
                    if (i == 0) {
                      path.moveTo(point.dx, point.dy);
                    } else {
                      path.lineTo(point.dx, point.dy);
                    }
                  }
                  path.close();
                  return path;
                },
              ),
            ),
            // Downward burst
            Center(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: math.pi / 2, // Downward
                blastDirectionality: BlastDirectionality.explosive,
                maxBlastForce: 60,
                minBlastForce: 30,
                emissionFrequency: 0.5,
                numberOfParticles: 60,
                gravity: 0.2,
                shouldLoop: false,
                colors: SpinnerDisplay.segmentColors,
              ),
            ),
            // Left diagonal burst
            Center(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: math.pi + math.pi / 6, // Left and slightly up
                blastDirectionality: BlastDirectionality.explosive,
                maxBlastForce: 50,
                minBlastForce: 30,
                emissionFrequency: 0.5,
                numberOfParticles: 45,
                gravity: 0.2,
                shouldLoop: false,
                colors: SpinnerDisplay.segmentColors,
              ),
            ),
            // Right diagonal burst
            Center(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -math.pi / 6, // Right and slightly up
                blastDirectionality: BlastDirectionality.explosive,
                maxBlastForce: 50,
                minBlastForce: 30,
                emissionFrequency: 0.5,
                numberOfParticles: 45,
                gravity: 0.2,
                shouldLoop: false,
                colors: SpinnerDisplay.segmentColors,
              ),
            ),
          ],
          SafeArea(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                final state = _controller.state;
                return Column(
                  children: [
                    // Top Bar with Mode Toggle and Settings
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 48), // Balance for settings icon
                          Row(
                            children: [
                              const Text('Spinner', style: TextStyle(fontSize: 20)),
                              Switch(
                                value: !state.isSpinnerMode,
                                onChanged: _controller.onModeChanged,
                              ),
                              const Text('Dice', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const ExplainerDialog(),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => SettingsDialog(
                                      settings: state.settings,
                                      onParticleEffectsChanged: _controller.onParticleEffectsChanged,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Main Display Area
                    Expanded(
                      child: Center(
                        child: IgnorePointer(
                          ignoring: _controller.isInteractionDisabled,
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
                                      particleEffectsEnabled: state.settings.particleEffectsEnabled,
                                    )
                                  : DiceDisplay(
                                      selectedNumbers: state.selectedNumbers,
                                      isHolding: state.isHolding,
                                      showResult: _controller.showResult,
                                    ),
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
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Slider(
                                  value: state.maxValue.toDouble(),
                                  min: 2,
                                  max: 12,
                                  divisions: 10,
                                  onChanged: _controller.onMaxValueChanged,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    state.maxValue.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Slider(
                                  value: state.numDice.toDouble(),
                                  min: 1,
                                  max: 6,
                                  divisions: 5,
                                  onChanged: _controller.onNumDiceChanged,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    state.numDice.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
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
