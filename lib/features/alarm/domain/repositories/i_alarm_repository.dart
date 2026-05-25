import 'package:twelfth_mobile/features/alarm/domain/entities/notification_settings.dart';

abstract interface class IAlarmRepository {
  Future<NotificationSettings> getSettings();
  Future<NotificationSettings> updateSettings(NotificationSettings settings);
  Future<void> registerFcmToken(String token);
}
