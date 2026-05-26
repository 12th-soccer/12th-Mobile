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
  Future<List<PlayerGoal>> getPlayerGoals(int playerId);
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

    final currentYear = DateTime.now().year;
    final seasons = [currentYear.toString(), (currentYear - 1).toString(), (currentYear - 2).toString()];

    for (final season in seasons) {
      try {
        final result = await _apiClient.get(
          ApiEndpoints.player(playerId.toString(), season: season),
          decoder: (data) {

            if (data == null) {
              return null;
            }

            if (data is String && data.trim().isEmpty) {
              return null;
            }

            if (data is! Map<String, dynamic>) {
              return null;
            }

            final json = data;

            final rawName = json['name'] as String? ?? '';
            final photo = json['photo'] as String?;
            final rawImageUrl = photo ?? json['playerImageUrl'] as String?;
            final isSwapped = photo == null && rawName.startsWith('http');
            final clubName = (json['teamName'] ?? json['clubName']) as String?;


            return PlayerDetail(
              playerId: json['playerId'] as int,
              name: isSwapped ? (rawImageUrl ?? '') : rawName,
              imageUrl: isSwapped ? rawName : rawImageUrl,
              age: json['age'] as int?,
              position: json['position'] as String?,
              number: json['number'] as int?,
              clubName: clubName,
            );
          },
        );

        if (result != null) {
          return result;
        }

      } on ApiException catch (e) {
        final status = e.statusCode;
        if (status == 400 || status == 401 || status == 403 || status == 404) {
          continue;
        }
        throw e;
      } catch (e) {
        continue;
      }
    }

    throw Exception('Player not found in any season');
  }

  static String get _currentSeason => DateTime.now().year.toString();

  @override
  Future<List<PlayerGoal>> getPlayerGoals(int playerId) async {

    final List<PlayerGoal> goalsBySeasons = [];

    final currentYear = DateTime.now().year;
    final seasons = List.generate(currentYear - 2020 + 1, (i) => (2020 + i).toString());

    for (final season in seasons) {
      for (final league in const ['kleague1', 'kleague2']) {
        try {
          final endpoint = ApiEndpoints.goals(playerId.toString(), season, league);

          final result = await _apiClient.get(
            endpoint,
            decoder: (data) {

              if (data == null) {
                return null;
              }

              if (data is String && data.trim().isEmpty) {
                return null;
              }

              if (data is! Map<String, dynamic>) {
                return null;
              }

              try {
                final goal = PlayerGoalModel.fromJson(data).toEntity();
                return goal;
              } catch (e) {
                return null;
              }
            },
          );

          if (result != null && result.goalCount > 0) {
            goalsBySeasons.add(result);
          }
        } on ApiException catch (e) {
          final status = e.statusCode;
          if (status == 400 || status == 401 || status == 403 || status == 404) {
            continue;
          }
        } catch (e) {
        }
      }
    }

    if (goalsBySeasons.isNotEmpty) {
      goalsBySeasons.sort((a, b) => b.season.compareTo(a.season));
    } else {
    }

    return goalsBySeasons;
  }
}
