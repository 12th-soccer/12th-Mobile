import 'dart:developer' as developer;
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
    developer.log('[FCM] 알림 권한: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      developer.log('[FCM] 알림 권한 거부됨 — 토큰 등록 건너뜀');
      return;
    }

    await messaging.getAPNSToken();

    final token = await messaging.getToken();
    if (token != null) {
      developer.log('[FCM] 토큰 발급: ${token.substring(0, 20)}...');
      await _registerToken(ref, token);
    }

    messaging.onTokenRefresh.listen((newToken) {
      developer.log('[FCM] 토큰 갱신');
      _registerToken(ref, newToken);
    });

    FirebaseMessaging.onMessage.listen((message) {
      developer.log(
        '[FCM] 포그라운드 메시지 수신\n'
        '  title: ${message.notification?.title}\n'
        '  body: ${message.notification?.body}',
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      developer.log('[FCM] 백그라운드 알림 탭: ${message.data}');
    });

    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      developer.log('[FCM] 종료 상태 알림 탭으로 실행: ${initial.data}');
    }
  }

  static Future<void> _registerToken(WidgetRef ref, String token) async {
    await ref.read(alarmRemoteDataSourceProvider).registerFcmToken(token);
  }
}
