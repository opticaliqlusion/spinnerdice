class SettingsState {
  final bool particleEffectsEnabled;

  const SettingsState({
    this.particleEffectsEnabled = true,
  });

  SettingsState copyWith({
    bool? particleEffectsEnabled,
  }) {
    return SettingsState(
      particleEffectsEnabled: particleEffectsEnabled ?? this.particleEffectsEnabled,
    );
  }
}
