import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/search/data/models/search_models.dart';

class ClubMappingService {
  static final ClubMappingService _instance = ClubMappingService._internal();

  factory ClubMappingService() => _instance;

  ClubMappingService._internal();

  final Map<String, int> _nameToIdMap = {};
  final Map<int, String> _idToNameMap = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final client = DioClient.instance.apiClient;
      final teams = await client.get<List<dynamic>>(
        '/search/team?keyword=&season=${DateTime.now().year}&page=1',
        decoder: (data) => data as List<dynamic>,
      );

      _nameToIdMap.clear();
      _idToNameMap.clear();

      for (final teamJson in teams) {
        final club = ClubSearchResultModel.fromJson(
          teamJson as Map<String, dynamic>,
        );
        _nameToIdMap[club.name] = club.clubId;
        _idToNameMap[club.clubId] = club.name;

        final normalized = _normalize(club.name);
        if (normalized.isNotEmpty) {
          _nameToIdMap[normalized] = club.clubId;
        }
      }

      _addLocalTeams();

      _isInitialized = true;
    } catch (e) {
      _nameToIdMap.clear();
      _idToNameMap.clear();
      _addLocalTeams();
      _isInitialized = true;
    }
  }

  void _addLocalTeams() {
  }

  int? lookup(String teamName) {
    if (!_isInitialized) return null;

    if (_nameToIdMap.containsKey(teamName)) {
      return _nameToIdMap[teamName];
    }

    final normalized = _normalize(teamName);
    return _nameToIdMap[normalized];
  }

  String? getNameById(int teamId) {
    if (!_isInitialized) return null;
    return _idToNameMap[teamId];
  }

  bool sameTeam(String? a, String? b) {
    if (!_isInitialized || a == null || b == null) return false;
    final normalizedA = _normalize(a);
    final normalizedB = _normalize(b);
    if (normalizedA.isEmpty || normalizedB.isEmpty) return false;
    return normalizedA == normalizedB;
  }

  String _normalize(String? teamName) {
    final value = (teamName ?? '').trim().toLowerCase();
    if (value.isEmpty) return '';

    var normalized = value.replaceAll(RegExp(r'[^a-z0-9가-힣]'), '');
    if (normalized.startsWith('fc')) {
      normalized = normalized.substring(2);
    }
    if (normalized.endsWith('fc')) {
      normalized = normalized.substring(0, normalized.length - 2);
    }
    return normalized;
  }
}

abstract final class ClubIdMap {
  static ClubMappingService get _service => ClubMappingService();

  static int? lookup(String teamName) => _service.lookup(teamName);

  static bool sameTeam(String? a, String? b) => _service.sameTeam(a, b);

  static String normalize(String? teamName) => _service._normalize(teamName);
}

final clubMappingInitProvider = FutureProvider<void>((ref) async {
  await ClubMappingService().initialize();
});
