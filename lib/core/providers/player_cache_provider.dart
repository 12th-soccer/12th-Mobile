import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      print('[PlayerCache] Loaded ${players.length} K1 players');
      print('[PlayerCache] K1 players with images: $playersWithImages');
      print('[PlayerCache] K1 players without images: $playersWithoutImages');
    } catch (e) {
      print('[PlayerCache] Failed to load K1 players: $e');
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
      print('[PlayerCache] Loaded ${players.length} K2 players');
      print('[PlayerCache] K2 players with images: $playersWithImages');
      print('[PlayerCache] K2 players without images: $playersWithoutImages');
    } catch (e) {
      print('[PlayerCache] Failed to load K2 players: $e');
    }
  }

  PlayerSearchResultModel? getCachedPlayer(int playerId) {
    return _playerCache[playerId];
  }

  String? getCachedPlayerImage(int playerId) {
    final player = _playerCache[playerId];
    if (player?.imageUrl != null) {
      print(
        '[PlayerCache] Found cached image for player $playerId: ${player!.imageUrl}',
      );
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
  if (playerId == 0) return null;

  final cacheService = PlayerCacheService();
  if (!cacheService.isInitialized) {
    print('[PlayerImage] Cache not initialized, waiting...');
    await cacheService.initializeCache();
  }

  final cachedImage = cacheService.getCachedPlayerImage(playerId);
  if (cachedImage != null && cachedImage.isNotEmpty) {
    return cachedImage;
  }

  final client = DioClient.instance.apiClient;
  try {
    final imageUrl = await client.get(
      ApiEndpoints.player(
        playerId.toString(),
        season: DateTime.now().year.toString(),
      ),
      decoder: (data) {
        if (data == null) return null;
        final json = data as Map<String, dynamic>;
        final photo = json['photo'] as String?;
        final rawName = json['name'] as String? ?? '';
        final rawImageUrl = photo ?? json['playerImageUrl'] as String?;
        final isSwapped = photo == null && rawName.startsWith('http');
        return isSwapped ? rawName : rawImageUrl;
      },
    );

    if (imageUrl != null) {
      print(
        '[PlayerImage] Found fallback image for player $playerId: $imageUrl',
      );
    } else {
      print('[PlayerImage] No image found for player $playerId');
    }

    return imageUrl;
  } catch (e) {
    print('[PlayerImage] Failed to load image for player $playerId: $e');
    return null;
  }
});
