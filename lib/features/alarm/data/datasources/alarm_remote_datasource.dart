import 'package:twelfth_mobile/features/alarm/data/models/notification_settings_model.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';

abstract interface class IAlarmRemoteDataSource {
  Future<NotificationSettingsModel> getSettings();
  Future<NotificationSettingsModel> updateSettings(NotificationSettingsModel settings);
  Future<void> registerFcmToken(String token);
}

class AlarmRemoteDataSourceImpl implements IAlarmRemoteDataSource {
  final ApiClient _apiClient;

  const AlarmRemoteDataSourceImpl(this._apiClient);

  @override
  Future<NotificationSettingsModel> getSettings() async {
    try {
      return await _apiClient.get(
        ApiEndpoints.notificationSettings,
        decoder: (data) =>
            NotificationSettingsModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (_) {
      return const NotificationSettingsModel();
    }
  }

  @override
  Future<NotificationSettingsModel> updateSettings(
    NotificationSettingsModel settings,
  ) =>
      _apiClient.patch(
        ApiEndpoints.notificationSettings,
        data: settings.toJson(),
        decoder: (data) =>
            NotificationSettingsModel.fromJson(data as Map<String, dynamic>),
      );

  @override
  Future<void> registerFcmToken(String token) async {
    try {
      await _apiClient.postVoid(
        ApiEndpoints.fcmTokens,
        data: {'token': token},
      );
    } catch (_) {
      // FCM 토큰 등록 실패는 무시 (앱 동작에 영향 없음)
    }
  }
}
