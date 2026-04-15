class TeamSocialLinks {
  final String instagram;
  final String youtube;

  const TeamSocialLinks({required this.instagram, required this.youtube});
}

abstract final class TeamSocials {
  static const Map<String, TeamSocialLinks> _data = {
    'FC 서울': TeamSocialLinks(
      instagram: 'https://www.instagram.com/fcseoul/',
      youtube: 'https://www.youtube.com/@FCSEOUL',
    ),
    '울산 HD FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/uhdfc_1983/',
      youtube: 'https://www.youtube.com/@ULSANHDFC',
    ),
    '전북 현대 모터스': TeamSocialLinks(
      instagram: 'https://www.instagram.com/jeonbuk1994/',
      youtube: 'https://www.youtube.com/@Jeonbuk1994',
    ),
    '대전 하나 시티즌': TeamSocialLinks(
      instagram: 'https://www.instagram.com/daejeon_hana/',
      youtube: 'https://www.youtube.com/@daejeonhanacitizen',
    ),
    '부천FC1995': TeamSocialLinks(
      instagram: 'https://www.instagram.com/bucheonfc1995/',
      youtube: 'https://www.youtube.com/@BFC_1995',
    ),
    '광주FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gwangju_fc/',
      youtube: 'https://www.youtube.com/@Gwangju_FC',
    ),
    '포항 스틸러스': TeamSocialLinks(
      instagram: 'https://www.instagram.com/fc.pohangsteelers/',
      youtube: 'https://www.youtube.com/@fc.pohangsteelers/featured',
    ),
    'FC안양': TeamSocialLinks(
      instagram: 'https://www.instagram.com/fc_anyang/',
      youtube: 'https://www.youtube.com/@fc_anyang',
    ),
    '김천상무 FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gimcheonfc/',
      youtube: 'https://www.youtube.com/@gimcheonfc',
    ),
    '인천 유나이티드': TeamSocialLinks(
      instagram: 'https://www.instagram.com/incheonutd/',
      youtube: 'https://www.youtube.com/@incheonutdfc',
    ),
    '강원FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gangwon_fc/',
      youtube: 'https://www.youtube.com/@gangwonfc2008',
    ),
    '제주 SK FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/jejuskfc_official/',
      youtube: 'https://www.youtube.com/@제주SK_FC',
    ),
    '수원 삼성': TeamSocialLinks(
      instagram: 'https://www.instagram.com/suwonsamsungfc/',
      youtube: 'https://www.youtube.com/@suwonsamsungfc',
    ),
    '부산 아이파크': TeamSocialLinks(
      instagram: 'https://www.instagram.com/busaniparkfc/',
      youtube: 'https://www.youtube.com/@_BusanIPARKFC',
    ),
    '수원 FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/suwonfc/',
      youtube: 'https://www.youtube.com/@TheSuwonFC',
    ),
    '대구 FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/daegufc.co.kr/',
      youtube: 'https://www.youtube.com/@FCDAEGUFC',
    ),
    '서울 이랜드 FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/seouleland/',
      youtube: 'https://www.youtube.com/@seouleland',
    ),
    '김포FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gimpofc_official/',
      youtube: 'https://www.youtube.com/@fc-gimpofc9572',
    ),
    '충남 아산 프로축구단': TeamSocialLinks(
      instagram: 'https://www.instagram.com/asanfc2020/',
      youtube: 'https://www.youtube.com/@CAFC2020',
    ),
    '파주프런티어FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/pajufrontierfc/',
      youtube: 'https://www.youtube.com/@파주프런티어FC',
    ),
    '성남FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/sfc.seongnam/',
      youtube: 'https://www.youtube.com/@SeongnamFC',
    ),
    '천안시티FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/cheonancityfc/',
      youtube: 'https://www.youtube.com/@CheonanCityFC',
    ),
    '안산 그리너스': TeamSocialLinks(
      instagram: 'https://www.instagram.com/ansan_greeners_fc/',
      youtube: 'https://www.youtube.com/@ansangreenersfc',
    ),
    '경남FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gyeongnamfc/',
      youtube: 'https://www.youtube.com/@gyeongnam_fc',
    ),
    '화성FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/hwaseongfc_official/',
      youtube: 'https://www.youtube.com/@fc_hwaseong',
    ),
    '충북청주FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/chfc_2023/',
      youtube: 'https://www.youtube.com/@chfc_2023',
    ),
    '전남 드래곤즈': TeamSocialLinks(
      instagram: 'https://www.instagram.com/jeonnamdragons_fc/',
      youtube: 'https://www.youtube.com/@JeonnamFC',
    ),
    '용인FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/yonginfc/',
      youtube: 'https://www.youtube.com/@yonginfc',
    ),
    '김해FC2008': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gimhaefc2008/',
      youtube: 'https://www.youtube.com/@gimhaefc2008',
    ),
  };

  static const Map<String, String> _aliases = {
    '수원삼성블루윙즈': '수원 삼성',
    '수원 삼성 블루윙즈': '수원 삼성',
    '수원삼성': '수원 삼성',

    '전북현대모터스': '전북 현대 모터스',
    '전북 현대': '전북 현대 모터스',
    '전북현대': '전북 현대 모터스',
    '전북 현대 모터스 FC': '전북 현대 모터스',

    '울산HD': '울산 HD FC',
    '울산HDFC': '울산 HD FC',
    '울산 HD': '울산 HD FC',

    '포항스틸러스': '포항 스틸러스',
    '포항 스틸러스 FC': '포항 스틸러스',

    '대구FC': '대구 FC',

    '대전하나시티즌': '대전 하나 시티즌',
    '대전 하나': '대전 하나 시티즌',
    '대전 하나시티즌': '대전 하나 시티즌',

    '인천유나이티드': '인천 유나이티드',
    '인천 유나이티드 FC': '인천 유나이티드',

    '부산아이파크': '부산 아이파크',
    '부산 아이파크 FC': '부산 아이파크',

    '서울이랜드': '서울 이랜드 FC',
    '서울이랜드FC': '서울 이랜드 FC',
    '서울 이랜드': '서울 이랜드 FC',

    '수원FC': '수원 FC',

    '제주SKFC': '제주 SK FC',
    '제주 SK': '제주 SK FC',
    '제주SK': '제주 SK FC',

    '충남아산': '충남 아산 프로축구단',
    '충남아산FC': '충남 아산 프로축구단',
    '충남 아산 FC': '충남 아산 프로축구단',
    '충남 아산': '충남 아산 프로축구단',

    '안산그리너스': '안산 그리너스',
    '안산그리너스FC': '안산 그리너스',
    '안산 그리너스 FC': '안산 그리너스',

    '전남드래곤즈': '전남 드래곤즈',
    '전남 드래곤즈 FC': '전남 드래곤즈',

    'FC서울': 'FC 서울',

    '부천 FC 1995': '부천FC1995',
    '부천FC': '부천FC1995',
    '부천 FC': '부천FC1995',

    '광주 FC': '광주FC',

    'FC 안양': 'FC안양',

    '김천상무FC': '김천상무 FC',
    '김천 상무': '김천상무 FC',
    '김천 상무 FC': '김천상무 FC',
    '김천상무': '김천상무 FC',

    '강원 FC': '강원FC',

    '김포 FC': '김포FC',
    '김포': '김포FC',

    '성남 FC': '성남FC',
    '성남': '성남FC',

    '경남 FC': '경남FC',

    '화성 FC': '화성FC',

    '충북 청주 FC': '충북청주FC',
    '충북청주': '충북청주FC',
    '충북 청주': '충북청주FC',

    '용인 FC': '용인FC',

    '김해 FC 2008': '김해FC2008',
    '김해FC': '김해FC2008',
    '김해 FC': '김해FC2008',

    '파주 프런티어 FC': '파주프런티어FC',
    '파주 프런티어': '파주프런티어FC',
    '파주프런티어': '파주프런티어FC',
    '파주 FC': '파주프런티어FC',
    '파주FC': '파주프런티어FC',

    '천안 시티 FC': '천안시티FC',
    '천안시티': '천안시티FC',
    '천안 시티': '천안시티FC',
  };

  static TeamSocialLinks? of(String teamName) {
    final canonical = canonicalName(teamName);
    if (canonical != null && _data.containsKey(canonical)) {
      return _data[canonical];
    }
    if (_data.containsKey(teamName)) return _data[teamName];
    final aliasKey =
        _aliases[teamName] ?? _aliases[teamName.replaceAll(' ', '')];
    if (aliasKey != null && _data.containsKey(aliasKey)) return _data[aliasKey];
    final noSpace = teamName.replaceAll(' ', '');
    if (_data.containsKey(noSpace)) return _data[noSpace];
    for (final key in _data.keys) {
      if (key.replaceAll(' ', '') == noSpace) return _data[key];
    }
    return null;
  }

  static String? canonicalName(String? teamName) {
    if (teamName == null) return null;
    if (_data.containsKey(teamName)) return teamName;

    final trimmed = teamName.trim();
    if (_data.containsKey(trimmed)) return trimmed;

    final aliasKey = _aliases[trimmed] ?? _aliases[trimmed.replaceAll(' ', '')];
    if (aliasKey != null) return aliasKey;

    final noSpace = trimmed.replaceAll(' ', '');
    if (_data.containsKey(noSpace)) return noSpace;

    for (final key in _data.keys) {
      if (key.replaceAll(' ', '') == noSpace) return key;
    }

    final normalizedInput = _normalizeForLookup(trimmed);
    for (final key in _data.keys) {
      if (_normalizeForLookup(key) == normalizedInput) return key;
    }

    return trimmed.isEmpty ? null : trimmed;
  }

  static String _normalizeForLookup(String value) {
    var normalized = value.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9가-힣]'),
      '',
    );
    if (normalized.startsWith('fc')) {
      normalized = normalized.substring(2);
    }
    if (normalized.endsWith('fc')) {
      normalized = normalized.substring(0, normalized.length - 2);
    }
    return normalized;
  }
}
