import 'package:twelfth_mobile/core/constants/team_social_links.dart';

abstract final class ClubIdMap {
  static const Map<String, int> _data = {
    'FC 서울': 1,
    '울산 HD FC': 2,
    '전북 현대 모터스': 3,
    '인천 유나이티드': 9,
    '포항 스틸러스': 5,
    '부천FC1995': 6,
    '광주FC': 7,
    '수원 삼성': 8,
    '수원삼성블루윙즈': 8,
    '수원 삼성 블루윙즈': 8,
    '대전 하나 시티즌': 4,
    '강원FC': 10,
    '강원 FC': 10,
    '김천상무 FC': 11,
    '대구 FC': 12,
    '제주 SK FC': 13,
    '수원 FC': 14,
    '서울 이랜드 FC': 15,
    '부산 아이파크': 16,
    'FC안양': 17,
    '성남FC': 18,
    '경남FC': 19,
    '충남 아산 프로축구단': 20,
    '안산 그리너스': 21,
    '김포FC': 22,
    '화성FC': 23,
    '충북청주FC': 24,
    '전남 드래곤즈': 25,
    '용인FC': 26,
    '파주프런티어FC': 27,
    '천안시티FC': 28,
    '김해FC2008': 29,

    // English aliases from match API responses
    'FC Seoul': 1,
    'Ulsan HD FC': 2,
    'Jeonbuk Hyundai Motors': 3,
    'Daejeon Hana Citizen': 4,
    'Pohang Steelers': 5,
    'Bucheon FC 1995': 6,
    'Gwangju FC': 7,
    'Suwon Samsung Bluewings': 8,
    'Incheon United': 9,
    'Gangwon FC': 10,
    'Gimcheon Sangmu': 11,
    'Daegu FC': 12,
    'Jeju SK FC': 13,
    'Suwon FC': 14,
    'Seoul E-Land FC': 15,
    'Busan IPark': 16,
    'FC Anyang': 17,
    'Seongnam FC': 18,
    'Gyeongnam FC': 19,
    'Chungnam Asan FC': 20,
    'Ansan Greeners': 21,
    'Gimpo FC': 22,
    'Hwaseong FC': 23,
    'Chungbuk Cheongju FC': 24,
    'Jeonnam Dragons': 25,
    'Yongin FC': 26,
    'Paju Frontier FC': 27,
    'Cheonan City FC': 28,
    'Gimhae FC 2008': 29,
  };

  static int? lookup(String teamName) {
    final canonical = TeamSocials.canonicalName(teamName);
    if (canonical != null && _data.containsKey(canonical)) {
      return _data[canonical];
    }

    if (_data.containsKey(teamName)) return _data[teamName];
    final normalizedInput = normalize(teamName);
    for (final entry in _data.entries) {
      if (normalize(entry.key) == normalizedInput) return entry.value;
    }
    return null;
  }

  static bool sameTeam(String? a, String? b) {
    final normalizedA = normalize(a);
    final normalizedB = normalize(b);
    if (normalizedA.isEmpty || normalizedB.isEmpty) return false;
    return normalizedA == normalizedB;
  }

  static String normalize(String? teamName) {
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
