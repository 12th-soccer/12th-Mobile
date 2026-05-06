import 'package:twelfth_mobile/features/alarm/domain/entities/notification_settings.dart';

class NotificationSettingsModel {
  final bool notificationEnabled;
  final bool oneHourBeforeEnabled;
  final bool thirtyMinutesBeforeEnabled;
  final bool fifteenMinutesBeforeEnabled;
  final bool matchStartEnabled;

  const NotificationSettingsModel({
    this.notificationEnabled = true,
    this.oneHourBeforeEnabled = true,
    this.thirtyMinutesBeforeEnabled = true,
    this.fifteenMinutesBeforeEnabled = true,
    this.matchStartEnabled = true,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      NotificationSettingsModel(
        notificationEnabled: json['notificationEnabled'] as bool? ?? true,
        oneHourBeforeEnabled: json['oneHourBeforeEnabled'] as bool? ?? true,
        thirtyMinutesBeforeEnabled:
            json['thirtyMinutesBeforeEnabled'] as bool? ?? true,
        fifteenMinutesBeforeEnabled:
            json['fifteenMinutesBeforeEnabled'] as bool? ?? true,
        matchStartEnabled: json['matchStartEnabled'] as bool? ?? true,
      );

  factory NotificationSettingsModel.fromEntity(NotificationSettings entity) =>
      NotificationSettingsModel(
        notificationEnabled: entity.notificationEnabled,
        oneHourBeforeEnabled: entity.oneHourBeforeEnabled,
        thirtyMinutesBeforeEnabled: entity.thirtyMinutesBeforeEnabled,
        fifteenMinutesBeforeEnabled: entity.fifteenMinutesBeforeEnabled,
        matchStartEnabled: entity.matchStartEnabled,
      );

  Map<String, dynamic> toJson() => {
        'notificationEnabled': notificationEnabled,
        'oneHourBeforeEnabled': oneHourBeforeEnabled,
        'thirtyMinutesBeforeEnabled': thirtyMinutesBeforeEnabled,
        'fifteenMinutesBeforeEnabled': fifteenMinutesBeforeEnabled,
        'matchStartEnabled': matchStartEnabled,
      };

  NotificationSettings toEntity() => NotificationSettings(
        notificationEnabled: notificationEnabled,
        oneHourBeforeEnabled: oneHourBeforeEnabled,
        thirtyMinutesBeforeEnabled: thirtyMinutesBeforeEnabled,
        fifteenMinutesBeforeEnabled: fifteenMinutesBeforeEnabled,
        matchStartEnabled: matchStartEnabled,
      );
}
