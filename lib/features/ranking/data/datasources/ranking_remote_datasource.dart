import 'dart:developer' as developer;
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
      developer.log('[Ranking] 랭킹 요청: $url');
      return await _apiClient.get(
        url,
        decoder: (data) {
          final list = data as List<dynamic>;
          if (list.isNotEmpty) {
            developer.log('[Ranking] 첫 번째 item 필드: ${(list.first as Map).keys.toList()}');
            developer.log('[Ranking] 첫 번째 item: ${list.first}');
          }
          return list
              .map(
                (e) => ClubRankingModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        },
      );
    } on ApiException catch (e) {
      developer.log(
        '[Ranking] 랭킹 실패 (ApiException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.statusCode}\n'
        '  message: ${e.message}\n'
        '  URL: ${e.uri}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Ranking] 랭킹 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<ClubDetailModel> getClubDetail(int clubId) async {
    try {
      developer.log('[Ranking] 클럽 상세 요청: clubId=$clubId');
      return await _apiClient.get(
        ApiEndpoints.club(clubId.toString()),
        decoder: (data) {
          final jsonMap = data as Map<String, dynamic>;
          developer.log('[Ranking] 클럽 상세 필드: ${jsonMap.keys.toList()}');
          developer.log('[Ranking] 클럽 상세 응답 키: ${jsonMap.keys.toList()}');
          for (final key in [
            'matches',
            'schedules',
            'upcomingMatches',
            'schedule',
          ]) {
            final val = jsonMap[key];
            if (val != null) {
              developer.log('[Ranking] "$key" 필드 길이: ${(val as List).length}');
              for (final m in val) {
                final mp = m as Map<String, dynamic>;
                developer.log('[Ranking]   match: id=${mp['matchId']} date=${mp['matchDate']} homeScore=${mp['homeTeamScore']} awayScore=${mp['awayTeamScore']} home=${mp['homeTeamName']} away=${mp['awayTeamName']}');
              }
            }
          }
          return ClubDetailModel.fromJson(jsonMap);
        },
      );
    } on ApiException catch (e) {
      developer.log(
        '[Ranking] 클럽 상세 실패 (ApiException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.statusCode}\n'
        '  URL: ${e.uri}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Ranking] 클럽 상세 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<PlayerDetail> getPlayerDetail(int playerId) async {
    try {
      developer.log('[Player] 선수 상세 요청: playerId=$playerId');
      return await _apiClient.get(
        ApiEndpoints.player(playerId.toString()),
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          developer.log('[Player] 선수 상세 응답 전체: $json');
          final rawName = json['name'] as String? ?? '';
          final rawImageUrl = json['playerImageUrl'] as String?;
          final isSwapped = rawName.startsWith('http');
          final detail = PlayerDetail(
            playerId: json['playerId'] as int,
            name: isSwapped ? (rawImageUrl ?? '') : rawName,
            imageUrl: isSwapped ? rawName : rawImageUrl,
            age: json['age'] as int?,
            position: json['position'] as String?,
            number: json['number'] as int?,
            clubName: json['clubName'] as String?,
          );
          developer.log('[Player] 파싱 결과: name=${detail.name} club=${detail.clubName} pos=${detail.position} num=${detail.number}');
          return detail;
        },
      );
    } on ApiException catch (e) {
      developer.log(
        '[Player] 선수 상세 실패 (ApiException)\n'
        '  status: ${e.statusCode}\n'
        '  URL: ${e.uri}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Player] 선수 상세 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<List<PlayerGoal>> getPlayerGoals(int playerId) async {
    try {
      developer.log('[Player] 선수 골 기록 요청: playerId=$playerId');
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
      developer.log(
        '[Player] 선수 골 기록 실패 (ApiException)\n'
        '  status: $status\n'
        '  URL: ${e.uri}\n'
        '  response: ${e.responseData}',
      );
      if (status == 400 || status == 404 || (status != null && status >= 500)) {
        return [];
      }
      rethrow;
    } catch (e, stack) {
      developer.log('[Player] 선수 골 기록 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }
}
