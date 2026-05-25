class NotificationSettings {
  final bool notificationEnabled;
  final bool oneHourBeforeEnabled;
  final bool thirtyMinutesBeforeEnabled;
  final bool fifteenMinutesBeforeEnabled;
  final bool matchStartEnabled;
  final bool favoriteTeamMatchEnabled;

  const NotificationSettings({
    this.notificationEnabled = true,
    this.oneHourBeforeEnabled = true,
    this.thirtyMinutesBeforeEnabled = true,
    this.fifteenMinutesBeforeEnabled = true,
    this.matchStartEnabled = true,
    this.favoriteTeamMatchEnabled = true,
  });

  NotificationSettings copyWith({
    bool? notificationEnabled,
    bool? oneHourBeforeEnabled,
    bool? thirtyMinutesBeforeEnabled,
    bool? fifteenMinutesBeforeEnabled,
    bool? matchStartEnabled,
    bool? favoriteTeamMatchEnabled,
  }) =>
      NotificationSettings(
        notificationEnabled: notificationEnabled ?? this.notificationEnabled,
        oneHourBeforeEnabled: oneHourBeforeEnabled ?? this.oneHourBeforeEnabled,
        thirtyMinutesBeforeEnabled:
            thirtyMinutesBeforeEnabled ?? this.thirtyMinutesBeforeEnabled,
        fifteenMinutesBeforeEnabled:
            fifteenMinutesBeforeEnabled ?? this.fifteenMinutesBeforeEnabled,
        matchStartEnabled: matchStartEnabled ?? this.matchStartEnabled,
        favoriteTeamMatchEnabled:
            favoriteTeamMatchEnabled ?? this.favoriteTeamMatchEnabled,
      );
}
