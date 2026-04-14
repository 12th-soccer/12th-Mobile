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

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        notificationEnabled: json['notificationEnabled'] as bool? ?? true,
        oneHourBeforeEnabled: json['oneHourBeforeEnabled'] as bool? ?? true,
        thirtyMinutesBeforeEnabled:
            json['thirtyMinutesBeforeEnabled'] as bool? ?? true,
        fifteenMinutesBeforeEnabled:
            json['fifteenMinutesBeforeEnabled'] as bool? ?? true,
        matchStartEnabled: json['matchStartEnabled'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'notificationEnabled': notificationEnabled,
        'oneHourBeforeEnabled': oneHourBeforeEnabled,
        'thirtyMinutesBeforeEnabled': thirtyMinutesBeforeEnabled,
        'fifteenMinutesBeforeEnabled': fifteenMinutesBeforeEnabled,
        'matchStartEnabled': matchStartEnabled,
      };

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
