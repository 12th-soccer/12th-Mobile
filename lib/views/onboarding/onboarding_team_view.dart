import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/favorites/data/datasources/favorites_remote_datasource.dart';
import 'package:twelfth_mobile/features/search/data/datasources/search_remote_datasource.dart';
import 'package:twelfth_mobile/features/search/domain/entities/club_search_result.dart';
import 'package:twelfth_mobile/views/onboarding/widget/onboarding_search_layout.dart';
import 'package:twelfth_mobile/views/onboarding/widget/onboarding_selectable_title.dart';

class OnboardingTeamView extends ConsumerStatefulWidget {
  final String? player;

  const OnboardingTeamView({super.key, this.player});

  @override
  ConsumerState<OnboardingTeamView> createState() => _OnboardingTeamViewState();
}

class _OnboardingTeamViewState extends ConsumerState<OnboardingTeamView> {
  final _searchController = TextEditingController();
  List<ClubSearchResult> _results = [];
  ClubSearchResult? _selected;
  bool _isSearching = false;
  bool _isProcessing = false;

  late final ISearchRemoteDataSource _searchDs;
  late final IFavoritesRemoteDataSource _favoritesDs;
  late final ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _apiClient = DioClient.instance.apiClient;
    _searchDs = SearchRemoteDataSourceImpl(_apiClient);
    _favoritesDs = FavoritesRemoteDataSourceImpl(_apiClient);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String keyword) async {
    if (keyword.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final models = await _searchDs.searchClubs(keyword.trim());
      if (mounted) {
        setState(() => _results = models.map((m) => m.toEntity()).toList());
      }
    } catch (_) {
      if (mounted) setState(() => _results = []);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _onNext() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    if (_selected != null) {
      try {
        await _favoritesDs.addFavoriteClub(_selected!.clubId);
      } catch (e) {
        debugPrint('[Onboarding] addFavoriteClub failed: $e');
      }
    }
    if (mounted) context.push(AppRoutes.onboardingComplete);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingSearchLayout<ClubSearchResult>(
      title: '좋아하는 구단이 있으세요?',
      hintText: '구단 이름으로 검색하세요.',
      controller: _searchController,
      isSearching: _isSearching,
      results: _results,
      isSelected: (item) => _selected?.clubId == item.clubId,
      onChanged: (v) {
        setState(() {
          if (_selected != null &&
              !_results.any((r) => r.clubId == _selected!.clubId)) {
            _selected = null;
          }
        });
        _search(v);
      },
      onSubmitted: _search,
      onPrev: () => context.pop(),
      onNext: _onNext,
      onTapItem: (item) {
        setState(() {
          _selected = _selected == item ? null : item;
        });
      },
      itemBuilder: (club, isSelected) {
        return OnboardingSelectableTile(
          title: club.name,
          isSelected: isSelected,
          imageUrl: club.logoUrl,
        );
      },
    );
  }
}
