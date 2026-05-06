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
    } on ApiException catch (e) {
      return const NotificationSettingsModel();
    } catch (e, stack) {
      return const NotificationSettingsModel();
    }
  }

  @override
  Future<NotificationSettingsModel> updateSettings(
    NotificationSettingsModel settings,
  ) async {
    try {
      return await _apiClient.patch(
        ApiEndpoints.notificationSettings,
        data: settings.toJson(),
        decoder: (data) =>
            NotificationSettingsModel.fromJson(data as Map<String, dynamic>),
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
    } catch (e, stack) {}
  }
}
