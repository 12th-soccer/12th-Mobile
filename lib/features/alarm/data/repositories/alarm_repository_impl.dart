import 'package:twelfth_mobile/features/alarm/data/datasources/alarm_remote_datasource.dart';
import 'package:twelfth_mobile/features/alarm/data/models/notification_settings_model.dart';
import 'package:twelfth_mobile/features/alarm/domain/entities/notification_settings.dart';
import 'package:twelfth_mobile/features/alarm/domain/repositories/i_alarm_repository.dart';

class AlarmRepositoryImpl implements IAlarmRepository {
  final IAlarmRemoteDataSource _dataSource;

  const AlarmRepositoryImpl(this._dataSource);

  @override
  Future<NotificationSettings> getSettings() async {
    final model = await _dataSource.getSettings();
    return model.toEntity();
  }

  @override
  Future<NotificationSettings> updateSettings(
    NotificationSettings settings,
  ) async {
    final model = await _dataSource.updateSettings(
      NotificationSettingsModel.fromEntity(settings),
    );
    return model.toEntity();
  }

  @override
  Future<void> registerFcmToken(String token) =>
      _dataSource.registerFcmToken(token);
}
