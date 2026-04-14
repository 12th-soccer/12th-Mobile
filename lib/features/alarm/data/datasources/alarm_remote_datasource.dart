import 'dart:developer' as developer;
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
      developer.log(
        '[Alarm] 알림 설정 조회: GET ${ApiEndpoints.notificationSettings}',
      );
      return await _apiClient.get(
        ApiEndpoints.notificationSettings,
        decoder: (data) =>
            NotificationSettings.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      developer.log(
        '[Alarm] 알림 설정 조회 실패\n'
        '  status: ${e.statusCode}\n'
        '  response: ${e.responseData}',
      );
      return const NotificationSettings();
    } catch (e, stack) {
      developer.log('[Alarm] 알림 설정 조회 실패 (Exception)\n  $e\n$stack');
      return const NotificationSettings();
    }
  }

  @override
  Future<NotificationSettings> updateSettings(
    NotificationSettings settings,
  ) async {
    try {
      developer.log(
        '[Alarm] 알림 설정 수정: PATCH ${ApiEndpoints.notificationSettings}',
      );
      return await _apiClient.patch(
        ApiEndpoints.notificationSettings,
        data: settings.toJson(),
        decoder: (data) =>
            NotificationSettings.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      developer.log(
        '[Alarm] 알림 설정 수정 실패\n'
        '  status: ${e.statusCode}\n'
        '  response: ${e.responseData}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Alarm] 알림 설정 수정 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> registerFcmToken(String token) async {
    try {
      developer.log('[Alarm] FCM 토큰 등록: POST ${ApiEndpoints.fcmTokens}');
      await _apiClient.postVoid(
        ApiEndpoints.fcmTokens,
        data: {'token': token},
      );
      developer.log('[Alarm] FCM 토큰 등록 성공');
    } on ApiException catch (e) {
      developer.log(
        '[Alarm] FCM 토큰 등록 실패\n'
        '  status: ${e.statusCode}\n'
        '  response: ${e.responseData}',
      );
    } catch (e, stack) {
      developer.log('[Alarm] FCM 토큰 등록 실패 (Exception)\n  $e\n$stack');
    }
  }
}
