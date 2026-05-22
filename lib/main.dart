import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/router/router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/core/services/local_notification_service.dart';
import 'package:twelfth_mobile/core/services/session_manager.dart';
import 'package:twelfth_mobile/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await _initFirebase();
}

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initFirebase();

  await LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(child: TwelfthApp()));
}

class TwelfthApp extends StatefulWidget {
  const TwelfthApp({super.key});

  @override
  State<TwelfthApp> createState() => _TwelfthAppState();
}

class _TwelfthAppState extends State<TwelfthApp> {
  late final StreamSubscription<void> _sessionSub;

  @override
  void initState() {
    super.initState();
    _sessionSub = SessionManager.onSessionExpired.listen((_) {
      appRouter.go(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _sessionSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: CustomColor.background),
      routerConfig: appRouter,
    );
  }
}
