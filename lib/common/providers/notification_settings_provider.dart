import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettings {
  final bool masterEnabled;
  final bool onMatchStart;
  final bool before1Hour;
  final bool before30Min;
  final bool before15Min;

  const NotificationSettings({
    this.masterEnabled = true,
    this.onMatchStart = true,
    this.before1Hour = false,
    this.before30Min = false,
    this.before15Min = false,
  });

  NotificationSettings copyWith({
    bool? masterEnabled,
    bool? onMatchStart,
    bool? before1Hour,
    bool? before30Min,
    bool? before15Min,
  }) {
    return NotificationSettings(
      masterEnabled: masterEnabled ?? this.masterEnabled,
      onMatchStart: onMatchStart ?? this.onMatchStart,
      before1Hour: before1Hour ?? this.before1Hour,
      before30Min: before30Min ?? this.before30Min,
      before15Min: before15Min ?? this.before15Min,
    );
  }
}

class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  @override
  NotificationSettings build() => const NotificationSettings();

  void setMaster(bool value) =>
      state = state.copyWith(masterEnabled: value);

  void setOnMatchStart(bool value) =>
      state = state.copyWith(onMatchStart: value);

  void setBefore1Hour(bool value) =>
      state = state.copyWith(before1Hour: value);

  void setBefore30Min(bool value) =>
      state = state.copyWith(before30Min: value);

  void setBefore15Min(bool value) =>
      state = state.copyWith(before15Min: value);
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);
