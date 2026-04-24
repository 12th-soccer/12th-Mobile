import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/views/auth/login_view.dart';
import 'package:twelfth_mobile/views/auth/sign_up/sign_up_email_view.dart';
import 'package:twelfth_mobile/views/auth/sign_up/sign_up_password_view.dart';
import 'package:twelfth_mobile/views/auth/sign_up/sign_up_success_view.dart';
import 'package:twelfth_mobile/views/auth/sign_up/sign_up_verify_view.dart';
import 'package:twelfth_mobile/views/favorites/favorites_view.dart';
import 'package:twelfth_mobile/views/search/search_view.dart';
import 'package:twelfth_mobile/views/main_app.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';
import 'package:twelfth_mobile/views/onboarding/onboarding_complete_view.dart';
import 'package:twelfth_mobile/views/onboarding/onboarding_player_view.dart';
import 'package:twelfth_mobile/views/onboarding/onboarding_team_view.dart';
import 'package:twelfth_mobile/views/onboarding/onboarding_welcome_view.dart';
import 'package:twelfth_mobile/views/profile/no_spoiler_settings_view.dart';
import 'package:twelfth_mobile/views/profile/notification_settings_view.dart';
import 'package:twelfth_mobile/views/profile/profile_view.dart';
import 'package:twelfth_mobile/views/ranking/player_detail_view.dart';
import 'package:twelfth_mobile/views/ranking/ranking_view.dart';
import 'package:twelfth_mobile/core/router/player_route_args.dart';
import 'package:twelfth_mobile/core/router/team_route_args.dart';
import 'package:twelfth_mobile/views/ranking/team_detail_view.dart';
import 'package:twelfth_mobile/views/schedule/schedule_view.dart';
import 'package:twelfth_mobile/views/splash_view.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const TwelfthSplashView(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginView(),
    ),

    /// signUp
    GoRoute(
      path: AppRoutes.signUpEmail,
      builder: (context, state) => const SignUpEmailView(),
    ),
    GoRoute(
      path: AppRoutes.signUpVerify,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return SignUpVerifyView(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.signUpPassword,
      builder: (context, state) => const SignUpPasswordView(),
    ),
    GoRoute(
      path: AppRoutes.signUpSuccess,
      builder: (context, state) => const SignUpSuccessView(),
    ),

    /// onboarding
    GoRoute(
      path: AppRoutes.onboardingWelcome,
      builder: (context, state) => const OnboardingWelcomeView(),
    ),
    GoRoute(
      path: AppRoutes.onboardingPlayer,
      builder: (context, state) => const OnboardingPlayerView(),
    ),
    GoRoute(
      path: AppRoutes.onboardingTeam,
      builder: (context, state) {
        final player = state.extra as String?;
        return OnboardingTeamView(player: player);
      },
    ),
    GoRoute(
      path: AppRoutes.onboardingComplete,
      builder: (context, state) => const OnboardingCompleteView(),
    ),

    /// main shell (bottom nav visible)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          TwelfthMainApp(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.ranking,
              builder: (context, state) => const RankingView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => const SearchView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.schedule,
              builder: (context, state) => const ScheduleView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, state) => const FavoritesView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileView(),
            ),
          ],
        ),
      ],
    ),

    /// detail views (no bottom nav)
    GoRoute(
      path: AppRoutes.match,
      builder: (context, state) {
        final extra = state.extra as MatchExtra;
        return MatchDetailView(extra: extra);
      },
    ),
    GoRoute(
      path: AppRoutes.team,
      builder: (context, state) {
        final args = state.extra as TeamRouteArgs;
        return TeamDetailView(clubId: args.clubId, teamName: args.teamName);
      },
    ),
    GoRoute(
      path: AppRoutes.player,
      builder: (context, state) {
        final args = state.extra as PlayerRouteArgs;
        return PlayerDetailView(playerId: args.playerId, playerName: args.playerName);
      },
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationSettingsView(),
    ),
    GoRoute(
      path: AppRoutes.noSpoiler,
      builder: (context, state) => const NoSpoilerSettingsView(),
    ),
  ],
);
