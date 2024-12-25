import 'package:flutter/material.dart';
import '../constants/theme.dart';

class DiceDisplay extends StatelessWidget {
  final List<int> selectedNumbers;
  final bool isHolding;
  final bool showResult;

  const DiceDisplay({
    super.key,
    required this.selectedNumbers,
    required this.isHolding,
    this.showResult = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Dice container
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(isHolding ? 0.95 : 1.0),
            width: 200,
            height: 200,
            decoration: AppTheme.diceDecoration(context),
            child: Center(
              child: Text(
                (!isHolding && !showResult) ? 'Hold to\nRoll' : '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        // Individual dice display
        if (selectedNumbers.isNotEmpty)
          Positioned(
            top: 100, // Position above the central button
            left: 0,
            right: 0,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: selectedNumbers.map((number) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.grey.shade200,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.primaryColor),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            number.toString(),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

        // Sum display overlay
        if (showResult && selectedNumbers.isNotEmpty)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              final sum = selectedNumbers.fold(0, (sum, number) => sum + number);
              return Opacity(
                opacity: value,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Stack(
                      children: [
                        // Number with border
                        for (var offset in const [
                          Offset(-6, -6),
                          Offset(6, -6),
                          Offset(-6, 6),
                          Offset(6, 6),
                        ])
                          Transform.translate(
                            offset: offset,
                            child: Text(
                              sum.toString(),
                              style: const TextStyle(
                                fontSize: 300,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        // Main number
                        Text(
                          sum.toString(),
                          style: TextStyle(
                            fontSize: 300,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
