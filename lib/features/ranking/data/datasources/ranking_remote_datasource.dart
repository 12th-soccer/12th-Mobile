import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/features/ranking/data/models/club_detail_model.dart';
import 'package:twelfth_mobile/features/ranking/data/models/club_ranking_model.dart';
import 'package:twelfth_mobile/features/ranking/data/models/player_goal_model.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_goal.dart';

abstract interface class IRankingRemoteDataSource {
  Future<List<ClubRankingModel>> getRanking(String leagueType);
  Future<ClubDetailModel> getClubDetail(int clubId);
  Future<PlayerDetail> getPlayerDetail(int playerId);
  Future<List<PlayerGoal>> getPlayerGoals(int playerId);
}

class RankingRemoteDataSourceImpl implements IRankingRemoteDataSource {
  final ApiClient _apiClient;
  const RankingRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ClubRankingModel>> getRanking(String leagueType) async {
    try {
      final url = ApiEndpoints.ranking(leagueType);
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
        ApiEndpoints.player(playerId.toString()),
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          final rawName = json['name'] as String? ?? '';
          final rawImageUrl = json['playerImageUrl'] as String?;
          final isSwapped = rawName.startsWith('http');
          return PlayerDetail(
            playerId: json['playerId'] as int,
            name: isSwapped ? (rawImageUrl ?? '') : rawName,
            imageUrl: isSwapped ? rawName : rawImageUrl,
            age: json['age'] as int?,
            position: json['position'] as String?,
            number: json['number'] as int?,
            clubName: json['clubName'] as String?,
          );
        },
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<PlayerGoal>> getPlayerGoals(int playerId) async {
    try {
      return await _apiClient.get(
        ApiEndpoints.goal(playerId.toString()),
        decoder: (data) {
          if (data == null) return <PlayerGoal>[];
          final list = data as List<dynamic>;
          return list
              .map(
                (e) =>
                    PlayerGoalModel.fromJson(e as Map<String, dynamic>)
                        .toEntity(),
              )
              .toList();
        },
      );
    } on ApiException catch (e) {
      final status = e.statusCode;
      if (status == 400 || status == 404 || (status != null && status >= 500)) {
        return [];
      }
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
