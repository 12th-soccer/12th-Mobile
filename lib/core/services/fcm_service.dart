import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/features/alarm/presentation/providers/alarm_provider.dart';

abstract final class FcmService {
  static Future<void> initialize(WidgetRef ref) async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    await messaging.getAPNSToken();

    final token = await messaging.getToken();
    if (token != null) {
      await _registerToken(ref, token);
    }

    messaging.onTokenRefresh.listen((newToken) {
      _registerToken(ref, newToken);
    });
  }

  static Future<void> _registerToken(WidgetRef ref, String token) async {
    await ref.read(alarmRemoteDataSourceProvider).registerFcmToken(token);
  }
}
