import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import '../constants/theme.dart';
import 'dart:ui' as ui;

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  
  ParticlePainter(this.particles);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
      
    for (final particle in particles) {
      paint.color = particle.color.withOpacity(particle.opacity);
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double opacity;
  
  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    this.opacity = 1.0,
  });
  
  void update() {
    x += vx;
    y += vy;
    vy -= 0.1; // Gravity effect
    opacity *= 0.98; // Fade out more slowly
  }
}

class FloatingEmoji extends StatefulWidget {
  final String emoji;
  final double startX;
  final double startY;
  
  const FloatingEmoji({
    super.key,
    required this.emoji,
    required this.startX,
    required this.startY,
  });
  
  @override
  State<FloatingEmoji> createState() => _FloatingEmojiState();
}

class _FloatingEmojiState extends State<FloatingEmoji> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _startY;
  late double _horizontalOffset;
  
  @override
  void initState() {
    super.initState();
    _startY = widget.startY;
    _horizontalOffset = (math.Random().nextDouble() - 0.5) * 40; // Reduced horizontal movement
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..forward().then((_) => mounted ? setState(() {}) : null);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        // Use curved animation for smoother motion
        final curvedProgress = Curves.easeOutQuad.transform(progress);
        // Calculate direction vector from center
        final dx = widget.startX - 200; // Distance from center X
        final dy = widget.startY - 200; // Distance from center Y
        final magnitude = math.sqrt(dx * dx + dy * dy);
        final dirX = dx / magnitude;
        final dirY = dy / magnitude;
        
        // Move outward and upward
        final outwardDistance = curvedProgress * 200; // Move outward
        final upwardDistance = curvedProgress * 300; // Move upward
        
        final xOffset = widget.startX + (dirX * outwardDistance) + (_horizontalOffset * progress);
        final yOffset = widget.startY + (dirY * outwardDistance) - upwardDistance;
        
        final opacity = (1 - curvedProgress * 0.8); // Fade out more slowly
        
        return Positioned(
          left: xOffset,
          top: yOffset,
          child: Opacity(
            opacity: opacity,
            child: Text(
              widget.emoji,
              style: const TextStyle(fontSize: 120), // Increased size
            ),
          ),
        );
      },
    );
  }
}

class SpinnerArmPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 4 // Increased stroke width
      ..strokeCap = StrokeCap.round;

    // Create arrow path
    final path = Path();
    
    // Start from center top
    path.moveTo(size.width / 2, 0);
    // Draw arrow head (scaled up)
    path.lineTo(size.width / 2 - 16, 40);
    path.lineTo(size.width / 2 + 16, 40);
    path.close();

    // Add shadow
    canvas.drawShadow(path, Colors.black, 6, true);
    // Draw arrow
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SpinnerPainter extends CustomPainter {
  final int segments;
  final List<Color> colors;
  
  SpinnerPainter({
    required this.segments,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final segmentAngle = 2 * math.pi / segments;
    
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Draw segments clockwise from top (-π/2)
    for (int i = 0; i < segments; i++) {
      // Calculate segment angle (clockwise from top)
      final startAngle = i * segmentAngle - math.pi / 2;
      final segmentNumber = i + 1; // Segment numbers 1 to N clockwise from top
      
      // Use consistent color mapping (clockwise from top)
      paint.color = colors[i % colors.length];
      
      // Draw segment
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(
          center.dx + radius * math.cos(startAngle),
          center.dy + radius * math.sin(startAngle)
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          segmentAngle,
          false
        )
        ..close();
      
      canvas.drawPath(path, paint);
      
      // Draw segment border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3; // Increased border width
      canvas.drawPath(path, borderPaint);
      
      // Draw number in segment center
      final textPainter = TextPainter(
        text: TextSpan(
          text: segmentNumber.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40, // Increased font size
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      // Position text in segment center
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.7;
      final textX = center.dx + textRadius * math.cos(textAngle) - textPainter.width / 2;
      final textY = center.dy + textRadius * math.sin(textAngle) - textPainter.height / 2;
      
      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SpinnerDisplay extends StatefulWidget {
  final double spinAngle;
  final List<int> selectedNumbers;
  final bool isHolding;
  final int maxValue;
  final bool showResult;
  final bool particleEffectsEnabled;

  const SpinnerDisplay({
    super.key,
    required this.spinAngle,
    required this.selectedNumbers,
    required this.isHolding,
    required this.maxValue,
    required this.showResult,
    required this.particleEffectsEnabled,
  });

  static const List<Color> segmentColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
  ];

  @override
  State<SpinnerDisplay> createState() => _SpinnerDisplayState();
}

class _SpinnerDisplayState extends State<SpinnerDisplay> with SingleTickerProviderStateMixin {
  List<Particle> _particles = [];
  Timer? _particleTimer;
  final List<Key> _emojiKeys = [];
  
  @override
  void initState() {
    super.initState();
    _startParticleAnimation();
  }
  
  @override
  void dispose() {
    _particleTimer?.cancel();
    super.dispose();
  }
  
  void _startParticleAnimation() {
    _particleTimer?.cancel();
    _particleTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) return;
      
      setState(() {
        // Update existing particles
        _particles = _particles.where((p) => p.opacity > 0.1).toList();
        for (var particle in _particles) {
          particle.update();
        }
        
        // Add new particles (only when enabled)
        if (widget.showResult && widget.selectedNumbers.isNotEmpty && widget.particleEffectsEnabled) {
          final random = math.Random();
          
          // Calculate selected number position
          final segmentAngle = 2 * math.pi / widget.maxValue;
          final numberIndex = widget.selectedNumbers.first - 1;
          final angle = numberIndex * segmentAngle - math.pi / 2;
          final radius = 150.0;
          final selectedX = 200 + radius * math.cos(angle);
          final selectedY = 200 + radius * math.sin(angle);
          
          // Particles from selected number position
          if (random.nextDouble() < 0.3) {
            final spread = math.pi / 2; // 90 degree spread
            final particleAngle = angle - spread/2 + random.nextDouble() * spread;
            final speed = random.nextDouble() * 8 + 6;
            _particles.add(Particle(
              x: selectedX,
              y: selectedY,
              vx: math.cos(particleAngle) * speed,
              vy: math.sin(particleAngle) * speed - random.nextDouble() * 5,
              size: random.nextDouble() * 4 + 2,
              color: SpinnerDisplay.segmentColors[numberIndex % SpinnerDisplay.segmentColors.length],
            ));
          }
          
          // Side particles for additional effect
          if (random.nextDouble() < 0.2) {
            _particles.add(Particle(
              x: 0,
              y: 400,
              vx: random.nextDouble() * 4 + 3,
              vy: random.nextDouble() * 20 + 15,
              size: random.nextDouble() * 6 + 3,
              color: SpinnerDisplay.segmentColors[random.nextInt(SpinnerDisplay.segmentColors.length)],
            ));
          }
          if (random.nextDouble() < 0.2) {
            _particles.add(Particle(
              x: 400,
              y: 400,
              vx: -(random.nextDouble() * 4 + 3),
              vy: random.nextDouble() * 20 + 15,
              size: random.nextDouble() * 6 + 3,
              color: SpinnerDisplay.segmentColors[random.nextInt(SpinnerDisplay.segmentColors.length)],
            ));
          }
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // Add new emoji when result changes
    if (widget.showResult && widget.selectedNumbers.isNotEmpty) {
      final random = math.Random();
      // Only add new emoji if we don't have too many
      if (_emojiKeys.length < 5) { // Allow more emojis
        _emojiKeys.add(UniqueKey());
        _emojiKeys.add(UniqueKey()); // Add two at once for more celebratory effect
      } else {
        _emojiKeys.removeAt(0);
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      transform: Matrix4.identity()..scale(widget.isHolding ? 0.95 : 1.0),
      width: 400,
      height: 400,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Base layer: Static spinner wheel
          CustomPaint(
            painter: SpinnerPainter(
              segments: widget.maxValue,
              colors: SpinnerDisplay.segmentColors,
            ),
            size: const Size(400, 400),
          ),
          // Middle layer: Spinner components
          Transform.rotate(
            angle: widget.spinAngle,
            child: Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: SpinnerArmPainter(),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          // Top layer: Celebration effects (only when enabled)
          if (widget.showResult && widget.particleEffectsEnabled) ...[
            CustomPaint(
              painter: ParticlePainter(_particles),
              size: const Size(400, 400),
            ),
            // Result number with celebration effect
            if (widget.selectedNumbers.isNotEmpty)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Center(
                      child: Stack(
                        children: [
                          // Number with border
                          for (var offset in [
                            Offset(-6, -6),
                            Offset(6, -6),
                            Offset(-6, 6),
                            Offset(6, 6),
                          ])
                            Transform.translate(
                              offset: offset,
                              child: Text(
                                widget.selectedNumbers.first.toString(),
                                style: const TextStyle(
                                  fontSize: 300,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          // Main number
                          Text(
                            widget.selectedNumbers.first.toString(),
                            style: TextStyle(
                              fontSize: 300,
                              fontWeight: FontWeight.bold,
                              color: SpinnerDisplay.segmentColors[(widget.selectedNumbers.first - 1) % SpinnerDisplay.segmentColors.length],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}
