import 'package:twelfth_mobile/core/config/app_env.dart';

class ApiEndpoints {
  /// baseURL
  static const baseUrl = AppEnv.baseUrl;

  /// auth
  static const google = "/auth/google";

  /// user
  static const signUp = "/user/verify/signup";
  static const logIn = "/user/login";
  static const email = "/user/email";
  static const logOut = "/user/logout";

  /// ranking
  static const ranking = "/ranking";

  /// search
  static const clubSearch = "/search/club";
  static const playerSearch = "/search/player";

  /// club
  static String club(String clubId) => "/club/$clubId";
  static const clubFavorite = "/club/favorite";
  static String schedule(String clubId) => "/club/schedule/$clubId";

  /// match
  static String match(String matchId) => "/match/$matchId";
  static String matchDate(String date) => "/match/matches?date=$date";

  /// player
  static String player(String playerId) => "/player/$playerId";
  static const playerFavorite = "/player/interest";

  /// favorite
  static String favoriteClub(String clubId) => "/favorite/club/$clubId";
  static String favoritePlayer(String playerId) => "/favorite/player/$playerId";
  static String clubDelete(String clubId) => "/favorite/club/$clubId";
  static String playerDelete(String playerId) => "/favorite/player/$playerId";

  /// alarm
  static const alarmSetting = "/alarm/setting";
}