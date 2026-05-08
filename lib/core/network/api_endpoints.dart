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

  /// search
      "/search/team?keyword=$keyword&season=$season&page=$page";
  static String searchPlayer(String keyword, String season, {int page = 1}) =>
      "/search/player?keyword=$keyword&season=$season&page=$page";

  /// teams
  static String team(String teamId) => "/teams/$teamId";
  static String teamsKleague1(String season) => "/teams/kleague1?season=$season";
  static String teamsKleague2(String season) => "/teams/kleague2?season=$season";

  /// matches
  static String match(String matchId) => "/matches/$matchId";
  static String matchDateKleague1(String season, String date) =>
      "/matches/kleague1?date=$date&season=$season";
  static String matchDateKleague2(String season, String date) =>
      "/matches/kleague2?date=$date&season=$season";

  /// player
  static String player(String playerId, {String? season}) =>
      season != null ? "/player/$playerId?season=$season" : "/player/$playerId";
  static String playersKleague1(String season, int page) =>
      "/player/kleague1?season=$season&page=$page";
  static String playersKleague2(String season, int page) =>
      "/player/kleague2?season=$season&page=$page";
  static String playerDetail(String season) => '/player/{playerId}?season=$season';

  /// favorite
  static const favoriteTeams = "/favorite/team";
  static String favoriteTeam(String teamId) => "/favorite/team/$teamId";
  static String favoritePlayerRegister(String playerId, String season) =>
      "/favorite/player/$playerId?season=$season";
  static String favoritePlayer(String playerId) => "/favorite/player/$playerId";
  static const favoritePlayers = "/favorite/player";

  /// notifications
  static const notificationSettings = "/notifications/settings";
  static const fcmTokens = "/fcm/tokens";

  /// goals
  static String goals(String playerId, String season, String league) =>
      "/goals/$playerId?season=$season&league=$league";
}
