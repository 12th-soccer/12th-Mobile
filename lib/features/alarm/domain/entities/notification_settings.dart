class NotificationSettings {
  final bool notificationEnabled;
  final bool oneHourBeforeEnabled;
  final bool thirtyMinutesBeforeEnabled;
  final bool fifteenMinutesBeforeEnabled;
  final bool matchStartEnabled;

  const NotificationSettings({
    this.notificationEnabled = true,
    this.oneHourBeforeEnabled = true,
    this.thirtyMinutesBeforeEnabled = true,
    this.fifteenMinutesBeforeEnabled = true,
    this.matchStartEnabled = true,
  });

  NotificationSettings copyWith({
    bool? notificationEnabled,
    bool? oneHourBeforeEnabled,
    bool? thirtyMinutesBeforeEnabled,
    bool? fifteenMinutesBeforeEnabled,
    bool? matchStartEnabled,
  }) =>
      NotificationSettings(
        notificationEnabled: notificationEnabled ?? this.notificationEnabled,
        oneHourBeforeEnabled: oneHourBeforeEnabled ?? this.oneHourBeforeEnabled,
        thirtyMinutesBeforeEnabled:
            thirtyMinutesBeforeEnabled ?? this.thirtyMinutesBeforeEnabled,
        fifteenMinutesBeforeEnabled:
            fifteenMinutesBeforeEnabled ?? this.fifteenMinutesBeforeEnabled,
        matchStartEnabled: matchStartEnabled ?? this.matchStartEnabled,
      );
}
