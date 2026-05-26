import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/search/data/models/search_models.dart';

class PlayerCacheService {
  static final PlayerCacheService _instance = PlayerCacheService._internal();

  factory PlayerCacheService() => _instance;

  PlayerCacheService._internal();

  final Map<int, PlayerSearchResultModel> _playerCache = {};
  bool _isK1Loaded = false;
  bool _isK2Loaded = false;

  Future<void> initializeCache() async {
    await Future.wait([_loadK1Players(), _loadK2Players()]);
  }

  Future<void> _loadK1Players() async {
    if (_isK1Loaded) return;

    try {
      final client = DioClient.instance.apiClient;
      final players = await client.get<List<dynamic>>(
        ApiEndpoints.playersKleague1('2024'),
        decoder: (data) {
          if (data == null) return <dynamic>[];
          if (data is List) return data;
          if (data is Map<String, dynamic>) {
            return (data['content'] ?? data['players'] ?? []) as List<dynamic>;
          }
          return [];
        },
      );

      int playersWithImages = 0;
      int playersWithoutImages = 0;

      for (final playerJson in players) {
        final player = PlayerSearchResultModel.fromJson(
          playerJson as Map<String, dynamic>,
        );
        _playerCache[player.playerId] = player;

        if (player.imageUrl != null && player.imageUrl!.isNotEmpty) {
          playersWithImages++;
        } else {
          playersWithoutImages++;
        }
      }

      _isK1Loaded = true;
    } catch (e) {
    }
  }

  Future<void> _loadK2Players() async {
    if (_isK2Loaded) return;

    try {
      final client = DioClient.instance.apiClient;
      final players = await client.get<List<dynamic>>(
        ApiEndpoints.playersKleague2('2024'),
        decoder: (data) {
          if (data == null) return <dynamic>[];
          if (data is List) return data;
          if (data is Map<String, dynamic>) {
            return (data['content'] ?? data['players'] ?? []) as List<dynamic>;
          }
          return [];
        },
      );

      int playersWithImages = 0;
      int playersWithoutImages = 0;

      for (final playerJson in players) {
        final player = PlayerSearchResultModel.fromJson(
          playerJson as Map<String, dynamic>,
        );
        _playerCache[player.playerId] = player;

        if (player.imageUrl != null && player.imageUrl!.isNotEmpty) {
          playersWithImages++;
        } else {
          playersWithoutImages++;
        }
      }

      _isK2Loaded = true;
    } catch (e) {
    }
  }

  PlayerSearchResultModel? getCachedPlayer(int playerId) {
    return _playerCache[playerId];
  }

  String? getCachedPlayerImage(int playerId) {
    final player = _playerCache[playerId];
    if (player?.imageUrl != null) {
    }
    return player?.imageUrl;
  }

  int get cacheSize => _playerCache.length;

  bool get isInitialized => _isK1Loaded && _isK2Loaded;
}

final playerCacheInitProvider = FutureProvider<void>((ref) async {
  await PlayerCacheService().initializeCache();
});

final enhancedPlayerImageProvider = FutureProvider.family<String?, int>((
  ref,
  playerId,
) async {
  if (playerId == 0) {
    return null;
  }


  final cacheService = PlayerCacheService();
  if (!cacheService.isInitialized) {
    await cacheService.initializeCache();
  }


  final cachedImage = cacheService.getCachedPlayerImage(playerId);

  if (cachedImage != null && cachedImage.isNotEmpty) {
    return cachedImage;
  }


  final client = DioClient.instance.apiClient;
  final currentYear = DateTime.now().year;
  final seasons = [currentYear.toString(), (currentYear - 1).toString(), (currentYear - 2).toString()];

  for (final season in seasons) {
    try {

      final imageUrl = await client.get(
        ApiEndpoints.player(playerId.toString(), season: season),
        decoder: (data) => _parsePlayerImageData(data, season),
      );

      if (imageUrl != null && imageUrl.isNotEmpty) {
        return imageUrl;
      } else {
      }

    } on ApiException catch (e) {
      final status = e.statusCode;
      if (status == 400 || status == 401 || status == 403 || status == 404) {
        continue;
      }
      continue;
    } catch (e) {
      continue;
    }
  }

  return null;
});

String? _parsePlayerImageData(dynamic data, String season) {

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

  final photo = json['photo'] as String?;
  final playerImageUrl = json['playerImageUrl'] as String?;
  final profileImageUrl = json['profileImageUrl'] as String?;
  final imageUrl = json['imageUrl'] as String?;
  final defaultImageUrl = json['defaultImageUrl'] as String?;
  final profileImage = json['profileImage'] as String?;
  final defaultProfile = json['defaultProfile'] as String?;
  final defaultAvatar = json['defaultAvatar'] as String?;

  final rawName = json['name'] as String? ?? '';
  final isSwapped = photo == null && rawName.startsWith('http');

  final resolvedImageUrl = photo ??
      playerImageUrl ??
      profileImageUrl ??
      defaultImageUrl ??
      defaultProfile ??
      defaultAvatar ??
      imageUrl ??
      profileImage;

  final finalUrl = isSwapped ? rawName : resolvedImageUrl;

  if (finalUrl != null && finalUrl.isNotEmpty) {
    final lowerUrl = finalUrl.toLowerCase();
    if (lowerUrl.contains('default') ||
        lowerUrl.contains('placeholder') ||
        lowerUrl.contains('no-image') ||
        lowerUrl.contains('avatar') ||
        finalUrl.endsWith('default.png') ||
        finalUrl.endsWith('default.jpg') ||
        finalUrl.endsWith('profile_default.png')) {
      return finalUrl;
    }
  }

  return finalUrl;
}
