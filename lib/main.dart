import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/core/providers/club_mapping_provider.dart';
import 'package:twelfth_mobile/core/providers/player_cache_provider.dart';
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

  unawaited(ClubMappingService().initialize());

  unawaited(PlayerCacheService().initializeCache());

  runApp(const ProviderScope(child: TwelfthApp()));
}

class TwelfthApp extends StatefulWidget {
  const TwelfthApp({super.key});

  @override
  State<TwelfthApp> createState() => _TwelfthAppState();
}

class _TwelfthAppState extends State<TwelfthApp> with WidgetsBindingObserver {
  late final StreamSubscription<void> _sessionSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sessionSub = SessionManager.onSessionExpired.listen((_) {
      appRouter.go(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionSub.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    final path =
        appRouter.routerDelegate.currentConfiguration.uri.path;
    final onLoginOrSplash =
        path == AppRoutes.login || path == AppRoutes.splash;
    if (!onLoginOrSplash) return;

    TokenStorage.instance.hasToken().then((hasToken) {
      if (hasToken) appRouter.go(AppRoutes.schedule);
    });
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
