import 'package:twelfth_mobile/features/search/domain/entities/club_search_result.dart';
import 'package:twelfth_mobile/features/search/domain/entities/player_search_result.dart';

enum SearchStatus { initial, loading, success, empty, error }

enum SearchFilter { player, club }

class SearchState {
  static const Object _noChange = Object();
  final SearchStatus status;
  final SearchFilter filter;
  final String selectedSeason;
  final List<ClubSearchResult> clubs;
  final List<PlayerSearchResult> players;
  final String? errorMessage;

  SearchState({
    this.status = SearchStatus.initial,
    this.filter = SearchFilter.player,
    String? selectedSeason,
    this.clubs = const [],
    this.players = const [],
    this.errorMessage,
  }) : selectedSeason = selectedSeason ?? DateTime.now().year.toString();

  bool get isLoading => status == SearchStatus.loading;

  bool get hasResults =>
      status == SearchStatus.success &&
      (clubs.isNotEmpty || players.isNotEmpty);

  SearchState copyWith({
    SearchStatus? status,
    SearchFilter? filter,
    String? selectedSeason,
    List<ClubSearchResult>? clubs,
    List<PlayerSearchResult>? players,
    Object? errorMessage = _noChange,
  }) => SearchState(
    status: status ?? this.status,
    filter: filter ?? this.filter,
    selectedSeason: selectedSeason ?? this.selectedSeason,
    clubs: clubs ?? this.clubs,
    players: players ?? this.players,
    errorMessage: identical(errorMessage, _noChange)
        ? this.errorMessage
        : errorMessage as String?,
  );
}
