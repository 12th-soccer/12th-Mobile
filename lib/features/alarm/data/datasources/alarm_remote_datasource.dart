import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:twelfth_mobile/common/providers/notification_settings_provider.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';

abstract interface class IAlarmRemoteDataSource {
  Future<NotificationSettings> getSettings();

  Future<NotificationSettings> updateSettings(NotificationSettings settings);

  Future<void> registerFcmToken(String token);
}

class AlarmRemoteDataSourceImpl implements IAlarmRemoteDataSource {
  final Dio _dio;

  const AlarmRemoteDataSourceImpl(this._dio);

  Map<String, dynamic> _parseMap(dynamic raw) {
    if (raw is String) return jsonDecode(raw) as Map<String, dynamic>;
    return raw as Map<String, dynamic>;
  }

  @override
  Future<NotificationSettings> getSettings() async {
    try {
      developer.log(
        '[Alarm] 알림 설정 조회: GET ${ApiEndpoints.notificationSettings}',
      );
      final response = await _dio.get(ApiEndpoints.notificationSettings);
      developer.log('[Alarm] 알림 설정 조회 응답 status: ${response.statusCode}');
      return NotificationSettings.fromJson(_parseMap(response.data));
    } on DioException catch (e) {
      developer.log(
        '[Alarm] 알림 설정 조회 실패\n'
        '  status: ${e.response?.statusCode}\n'
        '  response: ${e.response?.data}',
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
      final response = await _dio.patch(
        ApiEndpoints.notificationSettings,
        data: settings.toJson(),
      );
      developer.log('[Alarm] 알림 설정 수정 응답 status: ${response.statusCode}');
      return NotificationSettings.fromJson(_parseMap(response.data));
    } on DioException catch (e) {
      developer.log(
        '[Alarm] 알림 설정 수정 실패\n'
        '  status: ${e.response?.statusCode}\n'
        '  response: ${e.response?.data}',
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
      final response = await _dio.post(
        ApiEndpoints.fcmTokens,
        data: {'token': token},
      );
      developer.log('[Alarm] FCM 토큰 등록 응답 status: ${response.statusCode}');
    } on DioException catch (e) {
      developer.log(
        '[Alarm] FCM 토큰 등록 실패\n'
        '  status: ${e.response?.statusCode}\n'
        '  response: ${e.response?.data}',
      );
    } catch (e, stack) {
      developer.log('[Alarm] FCM 토큰 등록 실패 (Exception)\n  $e\n$stack');
    }
  }
}
