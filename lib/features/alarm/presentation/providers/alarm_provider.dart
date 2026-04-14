import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/common/providers/notification_settings_provider.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/alarm/data/datasources/alarm_remote_datasource.dart';

final _apiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final alarmRemoteDataSourceProvider = Provider<IAlarmRemoteDataSource>(
  (ref) => AlarmRemoteDataSourceImpl(ref.read(_apiClientProvider)),
);

class NotificationSettingsNotifier extends AsyncNotifier<NotificationSettings> {
  @override
  Future<NotificationSettings> build() async {
    return ref.read(alarmRemoteDataSourceProvider).getSettings();
  }

  Future<bool> save(NotificationSettings settings) async {
    state = const AsyncLoading();
    try {
      final updated = await ref
          .read(alarmRemoteDataSourceProvider)
          .updateSettings(settings);
      state = AsyncData(updated);
      return true;
    } catch (e, st) {
      developer.log('[AlarmProvider] 설정 저장 실패: $e');
      state = AsyncError(e, st);
      return false;
    }
  }
}

final notificationSettingsNotifierProvider =
    AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
      NotificationSettingsNotifier.new,
    );

Future<void> registerFcmToken(WidgetRef ref, String token) async {
  await ref.read(alarmRemoteDataSourceProvider).registerFcmToken(token);
}
