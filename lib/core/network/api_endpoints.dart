import 'package:twelfth_mobile/core/config/app_env.dart';

class ApiEndpoints {
  /// baseURL
  static const baseUrl = AppEnv.baseUrl;

  /// USEr
  static const google = "/auth/google";
  static const signUp = "/user/verify/signup";
  static const logIn = "/user/login";
  static const email = "/user/email";
  static const logOut = "/user/logout";
  static const userInfo = "/user/info";

  /// ranking
  static String ranking(String leagueType) => "/ranking?leagueType=$leagueType";

  /// club
  static String club(String clubId) => "/club/$clubId";
  static const clubSearch = "/club/search";
  static const clubFavorite = "/club/favorite";

  /// match
  static String match(String matchId) => "/match/$matchId";
  static const matchByDate = "/match";

  /// player
  static String player(String playerId) => "/player/$playerId";
  static const playerInterest = "/player/favorite";
  static const playerSearch = "/player/search";

  /// favorite
  static String favoriteClub(String clubId) => "/favorite/club/$clubId";
  static String favoritePlayer(String playerId) => "/favorite/player/$playerId";
  static String favoriteSchedule(String clubId) => "/favorite/schedule/$clubId";

  /// notifications
  static const notificationSettings = "/notifications/settings";
  static const fcmTokens = "/fcm/tokens";

  /// goal & event
  static String goal(String playerId) => "/goal/$playerId";
  static String event(String matchId) => "/event/$matchId";
}
