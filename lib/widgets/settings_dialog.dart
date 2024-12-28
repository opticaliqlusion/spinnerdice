import 'package:flutter/material.dart';
import '../models/settings_state.dart';

class SettingsDialog extends StatelessWidget {
  final SettingsState settings;
  final ValueChanged<bool> onParticleEffectsChanged;

  const SettingsDialog({
    super.key,
    required this.settings,
    required this.onParticleEffectsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.settings),
          SizedBox(width: 8),
          Text('Settings'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Particle Effects'),
              Switch(
                value: settings.particleEffectsEnabled,
                onChanged: onParticleEffectsChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Disable particle effects to improve performance on older devices.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
