import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/search/data/datasources/search_remote_datasource.dart';
import 'package:twelfth_mobile/features/search/data/repositories/search_repository_impl.dart';
import 'package:twelfth_mobile/features/search/domain/repositories/i_search_repository.dart';
import 'package:twelfth_mobile/features/search/domain/usecases/search_usecases.dart';
import 'package:twelfth_mobile/features/search/presentation/providers/search_state.dart';

final _dioProvider = Provider<Dio>((ref) => DioClient.instance.dio);

final _searchRemoteDataSourceProvider = Provider<ISearchRemoteDataSource>(
  (ref) => SearchRemoteDataSourceImpl(ref.read(_dioProvider)),
);

final searchRepositoryProvider = Provider<ISearchRepository>(
  (ref) => SearchRepositoryImpl(ref.read(_searchRemoteDataSourceProvider)),
);

final _searchClubsUseCaseProvider = Provider<SearchClubsUseCase>(
  (ref) => SearchClubsUseCase(ref.read(searchRepositoryProvider)),
);

final _searchPlayersUseCaseProvider = Provider<SearchPlayersUseCase>(
  (ref) => SearchPlayersUseCase(ref.read(searchRepositoryProvider)),
);

class SearchNotifier extends Notifier<SearchState> {
  int _requestId = 0;

  @override
  SearchState build() => const SearchState();

  void setFilter(SearchFilter filter) {
    state = state.copyWith(
      filter: filter,
      status: SearchStatus.initial,
      errorMessage: null,
      clubs: [],
      players: [],
    );
  }

  Future<void> search(String keyword) async {
    final requestId = ++_requestId;
    final q = keyword.trim();
    if (q.isEmpty) {
      state = state.copyWith(
        status: SearchStatus.initial,
        errorMessage: null,
        clubs: [],
        players: [],
      );
      return;
    }

    state = state.copyWith(status: SearchStatus.loading);

    try {
      if (state.filter == SearchFilter.club) {
        final clubs = await ref.read(_searchClubsUseCaseProvider).call(q);
        if (requestId != _requestId) return;
        state = clubs.isEmpty
            ? state.copyWith(status: SearchStatus.empty, clubs: [])
            : state.copyWith(status: SearchStatus.success, clubs: clubs);
      } else {
        final players = await ref.read(_searchPlayersUseCaseProvider).call(q);
        if (requestId != _requestId) return;
        state = players.isEmpty
            ? state.copyWith(status: SearchStatus.empty, players: [])
            : state.copyWith(status: SearchStatus.success, players: players);
      }
    } on DioException catch (e) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: _parseError(e),
      );
    }
  }

  void reset() {
    state = SearchState(filter: state.filter, errorMessage: null);
  }

  String _parseError(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return '해당 키워드가 없습니다';
      case 403:
        return '권한이 없습니다';
      case 404:
        return '결과를 찾을 수 없습니다';
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          return '네트워크 연결을 확인해 주세요';
        }
        return '오류가 발생했습니다. 다시 시도해 주세요';
    }
  }
}

final searchNotifierProvider = NotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);
