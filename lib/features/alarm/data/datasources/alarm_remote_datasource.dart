import 'package:twelfth_mobile/common/providers/notification_settings_provider.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';

abstract interface class IAlarmRemoteDataSource {
  Future<NotificationSettings> getSettings();

  Future<NotificationSettings> updateSettings(NotificationSettings settings);

  Future<void> registerFcmToken(String token);
}

class AlarmRemoteDataSourceImpl implements IAlarmRemoteDataSource {
  final ApiClient _apiClient;

  const AlarmRemoteDataSourceImpl(this._apiClient);

  @override
  Future<NotificationSettings> getSettings() async {
    try {
      return await _apiClient.get(
        ApiEndpoints.notificationSettings,
        decoder: (data) =>
            NotificationSettings.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return const NotificationSettings();
    } catch (e, stack) {
      return const NotificationSettings();
    }
  }

  @override
  Future<NotificationSettings> updateSettings(
    NotificationSettings settings,
  ) async {
    try {
      return await _apiClient.patch(
        ApiEndpoints.notificationSettings,
        data: settings.toJson(),
        decoder: (data) =>
            NotificationSettings.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      rethrow;
    } catch (e, stack) {
      rethrow;
    }
  }

  @override
  Future<void> registerFcmToken(String token) async {
    try {
      await _apiClient.postVoid(
        ApiEndpoints.fcmTokens,
        data: {'token': token},
      );
    } catch (e, stack) {
    }
  }
}
