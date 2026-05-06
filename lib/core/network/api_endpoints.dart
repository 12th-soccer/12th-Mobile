import 'package:twelfth_mobile/core/config/app_env.dart';

class ApiEndpoints {
  /// baseURL
  static const baseUrl = AppEnv.baseUrl;

  /// user
  static const google = "/auth/google";
  static const signUp = "/user/verify/signup";
  static const logIn = "/user/login";
  static const email = "/user/email";
  static const logOut = "/user/logout";
  static const userInfo = "/user/info";

  /// ranking
  static String ranking(String leagueType) => "/ranking?leagueType=$leagueType";

  /// teams
  static String team(String teamId) => "/teams/$teamId";
  static const teamSearch = "/teams/search";
  static const teamFavorite = "/teams/favorite";
  static String teamsKleague1(String season) => "/teams/kleague1?season=$season";
  static String teamsKleague2(String season) => "/teams/kleague2?season=$season";

  /// matches
  static String match(String matchId) => "/matches/$matchId";
  static String matchByDate(String season, String date) =>
      "/matches/kleague1?date=$date&season=$season";

  /// player
  static String player(String playerId, {String? season}) =>
      season != null ? "/player/$playerId?season=$season" : "/player/$playerId";
  static const playerFavorite = "/player/favorite";
  static const playerSearch = "/player/search";
  static String playersKleague1(String season, int page) =>
      "/player/kleague1?season=$season&page=$page";
  static String playersKleague2(String season, int page) =>
      "/player/kleague2?season=$season&page=$page";

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
