import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/dio.dart';

class TeamItem {
  final bool isK1;
  final String displayName;
  final String code;
  final String? logoUrl;

  const TeamItem({
    required this.isK1,
    required this.displayName,
    required this.code,
    this.logoUrl,
  });
}

class TeamListState {
  final List<TeamItem> k1Teams;
  final List<TeamItem> k2Teams;

  const TeamListState({this.k1Teams = const [], this.k2Teams = const []});
}

final _teamApiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final _nameToCode = <String, String>{
  'FC Seoul': 'FC_SEOUL',
  'Jeonbuk Motors': 'JEONBUK_HYUNDAI',
  'Ulsan Hyundai FC': 'ULSAN_HD',
  'Pohang Steelers': 'POHANG_STEELERS',
  'Incheon United': 'INCHEON_UNITED',
  'Gangwon FC': 'GANGWON_FC',
  'Jeju United FC': 'JEJU_SK',
  'Daejeon Citizen': 'DAEJEON_HANA_CITIZEN',
  'FC Anyang': 'FC_ANYANG',
  'Gimcheon Sangmu FC': 'GIMCHEON_SANGMU',
  'Bucheon FC 1995': 'BUCHEON_FC_1995',
  'Gwangju FC': 'GWANGJU_FC',

  'Busan I Park': 'BUSAN_IPARK',
  'Suwon Bluewings': 'SUWON_SAMSUNG_BLUEWINGS',
  'Seoul E-Land FC': 'SEOUL_E_LAND',
  'Suwon City FC': 'SUWON_FC',
  'Hwaseong': 'HWASEONG_FC',
  'Daegu FC': 'DAEGU_FC',
  'Asan Mugunghwa': 'CHUNGNAM_ASAN_FC',
  'Gimpo Citizen': 'GIMPO_FC',
  'Cheonan City': 'CHEONAN_CITY_FC',
  'Paju Citizen': 'PAJU_CITIZEN_FC',
  'Seongnam FC': 'SEONGNAM_FC',
  'Ansan Greeners': 'ANSAN_GREENERS',
  'Cheongju': 'CHEONGJU_FC',
  'Gyeongnam FC': 'GYEONGNAM_FC',
  'Yongin City': 'YONGIN_FC',
  'Jeonnam Dragons': 'JEONNAM_DRAGONS',
  'Gimhae City': 'GIMHAE_FC',
};

String _convertToCode(String name) {
  final mappedCode = _nameToCode[name];
  if (mappedCode != null) {
    print('매핑 성공: $name -> $mappedCode');
    return mappedCode;
  }

  final converted = name
      .toUpperCase()
      .replaceAll(' ', '_')
      .replaceAll('-', '_')
      .replaceAll('___', '_')
      .replaceAll('__', '_');

  print('기본 변환: $name -> $converted');
  return converted;
}

List<TeamItem> _parseTeams(dynamic data, {required bool isK1}) {
  if (data == null) return [];
  List<dynamic> list;
  if (data is List) {
    list = data;
  } else if (data is Map) {
    list = (data['content'] ?? data['teams'] ?? data['data'] ?? []) as List;
  } else {
    return [];
  }

  print('=== 서버에서 받아온 팀 데이터 (${isK1 ? 'K1' : 'K2'}) ===');
  print('Data: $data');

  final seen = <String>{};
  final items = <TeamItem>[];
  for (final e in list) {
    final json = e as Map<String, dynamic>;
    final name = (json['teamName'] ?? json['name'] ?? '') as String;
    print('팀 이름: $name');
    if (name.isEmpty || seen.contains(name)) continue;
    seen.add(name);
    final logo = (json['teamLogo'] ??
        json['teamImageUrl'] ??
        json['logo'] ??
        json['image']) as String?;
    final serverCode = (json['teamCode'] ?? json['code']) as String?;
    final code = serverCode ?? _convertToCode(name);
    print('팀 코드: $code');
    items.add(TeamItem(isK1: isK1, displayName: name, code: code, logoUrl: logo));
  }
  print('=== 생성된 팀 아이템들 ===');
  for (final item in items) {
    print('${item.displayName} -> ${item.code}');
  }
  return items;
}

Future<List<TeamItem>> _fetchWithFallback(
  ApiClient client,
  String Function(String season) endpointBuilder, {
  required bool isK1,
}) async {
  final currentYear = DateTime.now().year;
  final seasons = List.generate(
    currentYear - kStartSeason + 1,
    (i) => (currentYear - i).toString(),
  );

  for (final season in seasons) {
    try {
      final result = await client.get(
        endpointBuilder(season),
        decoder: (data) => _parseTeams(data, isK1: isK1),
      );
      if (result.isNotEmpty) return result;
    } catch (_) {}
  }
  return [];
}

final teamListProvider = FutureProvider<TeamListState>((ref) async {
  final client = ref.read(_teamApiClientProvider);

  final results = await Future.wait([
    _fetchWithFallback(client, ApiEndpoints.teamsKleague1, isK1: true),
    _fetchWithFallback(client, ApiEndpoints.teamsKleague2, isK1: false),
  ]);

  return TeamListState(k1Teams: results[0], k2Teams: results[1]);
});
