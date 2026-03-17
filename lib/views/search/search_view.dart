import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

enum _FilterType { player, team }

const _mockPlayers = [
  '윤도영',
  '서진수',
  '서영재',
  '조성권',
  '모따',
  '백가온',
  '안현범',
  '이승우',
  '이현식',
  '세징야',
  '강윤성',
  '이은호',
];

const _mockTeams = [
  '전북 현대 모터스 FC',
  '울산 HD FC',
  'FC 서울',
  '포항 스틸러스',
  '강원 FC',
  '광주 FC',
  '수원 삼성',
  '인천 유나이티드',
  '대전 하나 시티즌',
  '제주 SK',
];

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  _FilterType _filter = _FilterType.player;
  final List<String> _history = [];
  List<String> _results = [];
  bool _showResults = false;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    final q = query.trim();
    if (q.isEmpty) {
      setState(() {
        _showResults = false;
        _results = [];
      });
      return;
    }

    _history.remove(q);
    _history.insert(0, q);
    if (_history.length > 20) _history.removeLast();

    _runSearch(q);
    _focusNode.unfocus();
  }

  void _runSearch(String q) {
    final pool = _filter == _FilterType.player ? _mockPlayers : _mockTeams;
    setState(() {
      _showResults = true;
      _results = pool.where((name) => name.contains(q)).toList();
    });
  }

  void _onHistoryTap(String query) {
    _searchController.text = query;
    _search(query);
  }

  void _clearField() {
    _searchController.clear();
    setState(() {
      _showResults = false;
      _results = [];
    });
    _focusNode.requestFocus();
  }

  void _onFilterChanged(_FilterType filter) {
    setState(() => _filter = filter);
    final q = _searchController.text.trim();
    if (q.isNotEmpty && _showResults) {
      _runSearch(q);
    }
  }

  void _navigateToDetail(String name) {
    if (_filter == _FilterType.player) {
      context.push(AppRoutes.player, extra: name);
    } else {
      context.push(AppRoutes.team, extra: name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        backgroundColor: CustomColor.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const Divider(color: CustomColor.main, height: 1),
              Expanded(
                child: _showResults
                    ? _buildResultsSection()
                    : _buildHistorySection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final filterLabel = _filter == _FilterType.player ? '선수' : '구단';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: _clearField,
            child: const Icon(Symbols.arrow_back_ios, color: CustomColor.main),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              autofocus: true,
              cursorColor: CustomColor.main,
              style: CustomTextStyle.body1,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: '검색',
                hintStyle: CustomTextStyle.body1.copyWith(
                  color: CustomColor.gray500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: _search,
              onChanged: (v) {
                setState(() {});
                if (v.trim().isEmpty && (_showResults || _results.isNotEmpty)) {
                  setState(() {
                    _showResults = false;
                    _results = [];
                  });
                }
              },
            ),
          ),
          _FilterDropdown(
            label: filterLabel,
            onSelected: (type) => _onFilterChanged(type),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    if (_history.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final query = _history[index];
        return GestureDetector(
          onTap: () => _onHistoryTap(query),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Symbols.search,
                  color: CustomColor.gray500,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Text(query, style: CustomTextStyle.body1),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('검색 결과', style: CustomTextStyle.heading1),
        ),
        Expanded(
          child: _results.isEmpty
              ? Center(
                  child: Text(
                    '검색 결과가 없습니다.',
                    style: CustomTextStyle.body2.copyWith(
                      color: CustomColor.gray500,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) =>
                      _buildResultItem(_results[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildResultItem(String name) {
    return GestureDetector(
      onTap: () => _navigateToDetail(name),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: CustomColor.gray900,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(name, style: CustomTextStyle.body1)),
            GestureDetector(
              onTap: () => _navigateToDetail(name),
              child: Text(
                '더보기',
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final void Function(_FilterType) onSelected;

  const _FilterDropdown({
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<_FilterType>(
        onSelected: onSelected,
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: CustomColor.main),
        ),
        offset: const Offset(0, 36),
        constraints: const BoxConstraints(minWidth: 72, maxWidth: 72),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: _FilterType.player,
            height: 40,
            child: Center(child: Text('선수', style: CustomTextStyle.body2)),
          ),
          PopupMenuItem(
            value: _FilterType.team,
            height: 40,
            child: Center(child: Text('구단', style: CustomTextStyle.body2)),
          ),
        ],
        child: SizedBox(
          width: 72,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: CustomColor.main),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: CustomTextStyle.body2),
                const SizedBox(width: 4),
                const Icon(
                  Symbols.keyboard_arrow_down,
                  color: CustomColor.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
