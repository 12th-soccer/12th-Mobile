import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_club.dart';
import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_player.dart';

abstract interface class IFavoritesRepository {
  Future<List<FavoriteClub>> getFavoriteClubs();
  Future<void> addFavoriteClub(int clubId);
  Future<void> removeFavoriteClub(int clubId);
  Future<List<FavoritePlayer>> getFavoritePlayers();
  Future<void> addFavoritePlayer(int playerId);
  Future<void> removeFavoritePlayer(int playerId);
}
