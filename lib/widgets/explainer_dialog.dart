import 'package:flutter/material.dart';

class ExplainerDialog extends StatelessWidget {
  const ExplainerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Why I Built This'),
      content: const SingleChildScrollView(
        child: Text(
          'I created this app because my children, like many young children, '
          'would often cheat when spinning spinners and rolling dice in board games. '
          '\n\nThis app makes it easy to quickly get random numbers while keeping '
          'things fair, ensuring board games stay fun for everyone!'
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it!'),
        ),
      ],
    );
  }
}
