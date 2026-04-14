import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
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
  final Dio _dio;
  const RankingRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ClubRankingModel>> getRanking(String leagueType) async {
    try {
      final url = ApiEndpoints.ranking(leagueType);
      developer.log('[Ranking] 랭킹 요청: $url');
      final response = await _dio.get(url);
      developer.log('[Ranking] 응답 status: ${response.statusCode}');
      final rawData = response.data;
      final List<dynamic> list = rawData is String
          ? jsonDecode(rawData) as List<dynamic>
          : rawData as List<dynamic>;
      if (list.isNotEmpty) {
        developer.log('[Ranking] 첫 번째 item 필드: ${(list.first as Map).keys.toList()}');
        developer.log('[Ranking] 첫 번째 item: ${list.first}');
      }
      return list
          .map((e) => ClubRankingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      developer.log(
        '[Ranking] 랭킹 실패 (DioException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.response?.statusCode}\n'
        '  message: ${e.message}\n'
        '  URL: ${e.requestOptions.uri}',
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
      final response = await _dio.get(ApiEndpoints.club(clubId.toString()));
      developer.log('[Ranking] 클럽 상세 응답 status: ${response.statusCode}');
      final rawData = response.data;
      final Map<String, dynamic> jsonMap = rawData is String
          ? jsonDecode(rawData) as Map<String, dynamic>
          : rawData as Map<String, dynamic>;
      developer.log('[Ranking] 클럽 상세 필드: ${jsonMap.keys.toList()}');
      // 응답 키 전체 로깅
      developer.log('[Ranking] 클럽 상세 응답 키: ${jsonMap.keys.toList()}');
      for (final key in ['matches', 'schedules', 'upcomingMatches', 'schedule']) {
        final val = jsonMap[key];
        if (val != null) {
          developer.log('[Ranking] "$key" 필드 길이: ${(val as List).length}');
          for (final m in (val as List)) {
            final mp = m as Map<String, dynamic>;
            developer.log('[Ranking]   match: id=${mp['matchId']} date=${mp['matchDate']} homeScore=${mp['homeTeamScore']} awayScore=${mp['awayTeamScore']} home=${mp['homeTeamName']} away=${mp['awayTeamName']}');
          }
        }
      }
      return ClubDetailModel.fromJson(jsonMap);
    } on DioException catch (e) {
      developer.log(
        '[Ranking] 클럽 상세 실패 (DioException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.response?.statusCode}\n'
        '  URL: ${e.requestOptions.uri}',
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
      final response = await _dio.get(ApiEndpoints.player(playerId.toString()));
      developer.log('[Player] 선수 상세 응답 status: ${response.statusCode} | data: ${response.data}');
      final rawData = response.data;
      final Map<String, dynamic> json = rawData is String
          ? jsonDecode(rawData) as Map<String, dynamic>
          : rawData as Map<String, dynamic>;
      // 서버 버그: name 필드에 imageUrl이, playerImageUrl 필드에 name이 들어옴
      // name 필드가 'http'로 시작하면 뒤바뀐 것으로 판단
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
    } on DioException catch (e) {
      developer.log(
        '[Player] 선수 상세 실패 (DioException)\n'
        '  status: ${e.response?.statusCode}\n'
        '  URL: ${e.requestOptions.uri}',
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
      final response = await _dio.get(ApiEndpoints.goal(playerId.toString()));
      developer.log(
        '[Player] 선수 골 기록 응답 status: ${response.statusCode} | data: ${response.data}',
      );
      final raw = response.data;
      if (raw == null) return [];
      final List<dynamic> list = raw is String
          ? jsonDecode(raw) as List<dynamic>
          : raw as List<dynamic>;
      return list
          .map((e) => PlayerGoalModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      developer.log(
        '[Player] 선수 골 기록 실패 (DioException)\n'
        '  status: $status\n'
        '  URL: ${e.requestOptions.uri}\n'
        '  response: ${e.response?.data}',
      );
      if (status == 400 || status == 404) return [];
      rethrow;
    } catch (e, stack) {
      developer.log('[Player] 선수 골 기록 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }
}
