import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/features/ranking/data/models/club_detail_model.dart';
import 'package:twelfth_mobile/features/ranking/data/models/club_ranking_model.dart';
import 'package:twelfth_mobile/features/ranking/data/models/player_goal_model.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_goal.dart';

abstract interface class IRankingRemoteDataSource {
  Future<List<ClubRankingModel>> getRanking(String leagueType, String season);
  Future<ClubDetailModel> getClubDetail(int clubId);
  Future<PlayerDetail> getPlayerDetail(int playerId);
  Future<PlayerGoal?> getPlayerGoals(int playerId);
}

class RankingRemoteDataSourceImpl implements IRankingRemoteDataSource {
  final ApiClient _apiClient;
  const RankingRemoteDataSourceImpl(this._apiClient);

  static String _toLeagueParam(String leagueType) {
    if (leagueType == 'K1') return 'kleague1';
    if (leagueType == 'K2') return 'kleague2';
    return leagueType;
  }

  @override
  Future<List<ClubRankingModel>> getRanking(String leagueType, String season) async {
    try {
      final url = ApiEndpoints.ranking(season, _toLeagueParam(leagueType));
      return await _apiClient.get(
        url,
        decoder: (data) {
          final list = data as List<dynamic>;
          return list
              .map(
                (e) => ClubRankingModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        },
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<ClubDetailModel> getClubDetail(int clubId) async {
    try {
      return await _apiClient.get(
        ApiEndpoints.team(clubId.toString()),
        decoder: (data) =>
            ClubDetailModel.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<PlayerDetail> getPlayerDetail(int playerId) async {
    try {
      return await _apiClient.get(
        ApiEndpoints.player(playerId.toString(), season: _currentSeason),
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          final rawName = json['name'] as String? ?? '';
          final photo = json['photo'] as String?;
          final rawImageUrl = photo ?? json['playerImageUrl'] as String?;
          final isSwapped = photo == null && rawName.startsWith('http');
          return PlayerDetail(
            playerId: json['playerId'] as int,
            name: isSwapped ? (rawImageUrl ?? '') : rawName,
            imageUrl: isSwapped ? rawName : rawImageUrl,
            age: json['age'] as int?,
            position: json['position'] as String?,
            number: json['number'] as int?,
            clubName: (json['teamName'] ?? json['clubName']) as String?,
          );
        },
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  static String get _currentSeason => DateTime.now().year.toString();

  @override
  Future<PlayerGoal?> getPlayerGoals(int playerId) async {
    final season = _currentSeason;
    for (final league in const ['kleague1', 'kleague2']) {
      try {
        final result = await _apiClient.get(
          ApiEndpoints.goals(playerId.toString(), season, league),
          decoder: (data) {
            if (data == null) return null;
            return PlayerGoalModel.fromJson(data as Map<String, dynamic>)
                .toEntity();
          },
        );
        if (result != null) return result;
      } on ApiException catch (e) {
        final status = e.statusCode;
        if (status == 400 || status == 401 || status == 404) continue;
        rethrow;
      } catch (_) {
        rethrow;
      }
    }
    return null;
  }
}
