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
  static const updateUsername = "/user/name";

  /// ranking
  static String ranking(String season, String league) => "/ranking?season=$season&league=$league";

  /// search
  static String searchTeam(String keyword, {String? season, int page = 1}) =>
      "/search/team?keyword=$keyword&season=${season ?? DateTime.now().year}&page=$page";
  static String searchPlayer(String keyword, {String? season, int page = 1}) =>
      "/search/player?keyword=$keyword&season=${season ?? DateTime.now().year}&page=$page";

  /// teams
  static String team(String teamId, {String? season}) =>
      "/teams/$teamId?season=${season ?? DateTime.now().year}";
  static String teamsKleague1(String season) => "/teams/kleague1?season=$season";
  static String teamsKleague2(String season) => "/teams/kleague2?season=$season";

  /// match
  static String match(String matchId) => "/match/$matchId";
  static String matchDateKleague1(String date) =>
      "/match/kleague1?season=${date.split('-').first}&date=$date";
  static String matchDateKleague2(String date) =>
      "/match/kleague2?season=${date.split('-').first}&date=$date";

  /// player
  static String player(String playerId, {String? season}) =>
      season != null ? "/player/$playerId?season=$season" : "/player/$playerId";
  static String playersKleague1(String season, {int page = 1}) =>
      "/player/kleague1?season=$season&page=$page";
  static String playersKleague2(String season, {int page = 1}) =>
      "/player/kleague2?season=$season&page=$page";

  /// favorite
  static const favoriteTeams = "/favorite/team";
  static String favoriteTeam(String teamId) => "/favorite/team/$teamId";
  static String favoritePlayerRegister(String playerId) => "/favorite/player/$playerId?season=${DateTime.now().year}";
  static String favoritePlayer(String playerId) => "/favorite/player/$playerId";
  static const favoritePlayers = "/favorite/player";

  /// recruitment
  static const recruitmentCreate = '/recruitment';
  static String recruitments({int page = 0, int size = 10, String sort = 'createdAt,desc'}) =>
      '/recruitment?page=$page&size=$size&sort=$sort';
  static String recruitmentDetail(String recruitmentId) => '/recruitment/$recruitmentId';

  /// spoiler
  static const spoiler = '/spoiler';

  /// join
  static String joinRecruitment(String id) => '/join/$id';
  static const myJoinedRecruitments = '/join';

  /// notice
  static String noticeCreate(String recruitmentId) => '/notice/$recruitmentId';
  static String noticeDetail(String noticeId) => '/notice/$noticeId';

  /// comment
  static String commentList(String noticeId) => '/comment/$noticeId';
  static String commentCreate(String noticeId) => '/comment/$noticeId';

  /// account
  static const deleteAccount = '/user/me';

  /// phone verification
  static const phoneVerify = '/user/phone/verify';

  /// notifications
  static const notificationSettings = "/notifications/settings";
  static const fcmTokens = "/fcm/tokens";

  /// goals
  static String goals(String playerId, String season, String league) =>
      "/goals/$playerId?season=$season&league=$league";
}
