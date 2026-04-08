import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/features/ranking/data/models/club_detail_model.dart';
import 'package:twelfth_mobile/features/ranking/data/models/club_ranking_model.dart';

abstract interface class IRankingRemoteDataSource {
  Future<List<ClubRankingModel>> getRanking();
  Future<ClubDetailModel> getClubDetail(int clubId);
}

class RankingRemoteDataSourceImpl implements IRankingRemoteDataSource {
  final Dio _dio;
  const RankingRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ClubRankingModel>> getRanking() async {
    try {
      developer.log('[Ranking] 랭킹 요청: ${ApiEndpoints.ranking}');
      final response = await _dio.get(ApiEndpoints.ranking);
      developer.log('[Ranking] 응답 status: ${response.statusCode}');
      developer.log('[Ranking] 응답 data type: ${response.data.runtimeType}');
      final rawData = response.data;
      final List<dynamic> list =
          rawData is String ? jsonDecode(rawData) as List<dynamic> : rawData as List<dynamic>;
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
      final Map<String, dynamic> jsonMap =
          rawData is String ? jsonDecode(rawData) as Map<String, dynamic> : rawData as Map<String, dynamic>;
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
}
