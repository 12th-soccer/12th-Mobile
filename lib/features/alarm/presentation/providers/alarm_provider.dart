import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/alarm/data/datasources/alarm_remote_datasource.dart';
import 'package:twelfth_mobile/features/alarm/data/repositories/alarm_repository_impl.dart';
import 'package:twelfth_mobile/features/alarm/domain/entities/notification_settings.dart';
import 'package:twelfth_mobile/features/alarm/domain/repositories/i_alarm_repository.dart';

final _apiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final _alarmRemoteDataSourceProvider = Provider<IAlarmRemoteDataSource>(
  (ref) => AlarmRemoteDataSourceImpl(ref.read(_apiClientProvider)),
);

final alarmRepositoryProvider = Provider<IAlarmRepository>(
  (ref) => AlarmRepositoryImpl(ref.read(_alarmRemoteDataSourceProvider)),
);

class NotificationSettingsNotifier extends AsyncNotifier<NotificationSettings> {
  @override
  Future<NotificationSettings> build() async {
    return ref.read(alarmRepositoryProvider).getSettings();
  }

  Future<bool> save(NotificationSettings settings) async {
    state = const AsyncLoading();
    try {
      final updated = await ref
          .read(alarmRepositoryProvider)
          .updateSettings(settings);
      state = AsyncData(updated);
      return true;
    } catch (e, st) {
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
  await ref.read(alarmRepositoryProvider).registerFcmToken(token);
}
