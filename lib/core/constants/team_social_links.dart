class TeamSocialLinks {
  final String instagram;
  final String youtube;

  const TeamSocialLinks({required this.instagram, required this.youtube});
}

abstract final class TeamSocials {
  static const Map<String, TeamSocialLinks> _data = {
    'FC_SEOUL': TeamSocialLinks(
      instagram: 'https://www.instagram.com/fcseoul/',
      youtube: 'https://www.youtube.com/@FCSEOUL',
    ),
    'ULSAN_HD': TeamSocialLinks(
      instagram: 'https://www.instagram.com/uhdfc_1983/',
      youtube: 'https://www.youtube.com/@ULSANHDFC',
    ),
    'JEONBUK_HYUNDAU': TeamSocialLinks(
      instagram: 'https://www.instagram.com/jeonbuk1994/',
      youtube: 'https://www.youtube.com/@Jeonbuk1994',
    ),
    'DAEJEON_HANA_CITIZEN': TeamSocialLinks(
      instagram: 'https://www.instagram.com/daejeon_hana/',
      youtube: 'https://www.youtube.com/@daejeonhanacitizen',
    ),
    'BUCHEON_FC_1995': TeamSocialLinks(
      instagram: 'https://www.instagram.com/bucheonfc1995/',
      youtube: 'https://www.youtube.com/@BFC_1995',
    ),
    'GWANGJU_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gwangju_fc/',
      youtube: 'https://www.youtube.com/@Gwangju_FC',
    ),
    'POHANG_STEELERS': TeamSocialLinks(
      instagram: 'https://www.instagram.com/fc.pohangsteelers/',
      youtube: 'https://www.youtube.com/@fc.pohangsteelers/featured',
    ),
    'FC_ANYANG': TeamSocialLinks(
      instagram: 'https://www.instagram.com/fc_anyang/',
      youtube: 'https://www.youtube.com/@fc_anyang',
    ),
    'GIMCHEON_SANGMU': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gimcheonfc/',
      youtube: 'https://www.youtube.com/@gimcheonfc',
    ),
    'INCHEON_UNITED': TeamSocialLinks(
      instagram: 'https://www.instagram.com/incheonutd/',
      youtube: 'https://www.youtube.com/@incheonutdfc',
    ),
    'GANGWON_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gangwon_fc/',
      youtube: 'https://www.youtube.com/@gangwonfc2008',
    ),
    'JEJU_SK': TeamSocialLinks(
      instagram: 'https://www.instagram.com/jejuskfc_official/',
      youtube: 'https://www.youtube.com/@제주SK_FC',
    ),
    'SUWON_SAMSUNG_BLUEWINGS': TeamSocialLinks(
      instagram: 'https://www.instagram.com/suwonsamsungfc/',
      youtube: 'https://www.youtube.com/@suwonsamsungfc',
    ),
    'BUSAN_IPARK': TeamSocialLinks(
      instagram: 'https://www.instagram.com/busaniparkfc/',
      youtube: 'https://www.youtube.com/@_BusanIPARKFC',
    ),
    'SUWON_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/suwonfc/',
      youtube: 'https://www.youtube.com/@TheSuwonFC',
    ),
    'DAEGU_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/daegufc.co.kr/',
      youtube: 'https://www.youtube.com/@FCDAEGUFC',
    ),
    'SEOUL_E_LAND': TeamSocialLinks(
      instagram: 'https://www.instagram.com/seouleland/',
      youtube: 'https://www.youtube.com/@seouleland',
    ),
    'GIMPO_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gimpofc_official/',
      youtube: 'https://www.youtube.com/@fc-gimpofc9572',
    ),
    'CHUNGNAM_ASAN_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/asanfc2020/',
      youtube: 'https://www.youtube.com/@CAFC2020',
    ),
    'PAJU_CITIZEN_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/pajufrontierfc/',
      youtube: 'https://www.youtube.com/@파주프런티어FC',
    ),
    'SEONGNAM_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/sfc.seongnam/',
      youtube: 'https://www.youtube.com/@SeongnamFC',
    ),
    'CHEONAN_CITY_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/cheonancityfc/',
      youtube: 'https://www.youtube.com/@CheonanCityFC',
    ),
    'ANSAN_GREENERS': TeamSocialLinks(
      instagram: 'https://www.instagram.com/ansan_greeners_fc/',
      youtube: 'https://www.youtube.com/@ansangreenersfc',
    ),
    'GYEONGNAM_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gyeongnamfc/',
      youtube: 'https://www.youtube.com/@gyeongnam_fc',
    ),
    'HWASEONG_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/hwaseongfc_official/',
      youtube: 'https://www.youtube.com/@fc_hwaseong',
    ),
    'CHEONGJU_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/chfc_2023/',
      youtube: 'https://www.youtube.com/@chfc_2023',
    ),
    'JEONNAM_DRAGONS': TeamSocialLinks(
      instagram: 'https://www.instagram.com/jeonnamdragons_fc/',
      youtube: 'https://www.youtube.com/@JeonnamFC',
    ),
    'YONGIN_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/yonginfc/',
      youtube: 'https://www.youtube.com/@yonginfc',
    ),
    'GIMHAE_FC': TeamSocialLinks(
      instagram: 'https://www.instagram.com/gimhaefc2008/',
      youtube: 'https://www.youtube.com/@gimhaefc2008',
    ),
  };

  static TeamSocialLinks? of(String teamName) {
    final canonical = canonicalName(teamName);
    print('[TeamSocials] Looking up team: "$teamName" → canonical: "$canonical"');

    if (canonical != null && _data.containsKey(canonical)) {
      final links = _data[canonical]!;
      print('[TeamSocials] Found social links for $canonical: Instagram: ${links.instagram}, YouTube: ${links.youtube}');
      return links;
    }

    print('[TeamSocials] No social links found for "$teamName"');
    return null;
  }

  static String? canonicalName(String? teamName) {
    if (teamName == null) return null;

    final trimmed = teamName.trim();

    if (_data.containsKey(trimmed)) {
      return trimmed;
    }

    final aliases = <String, String>{
      'Yongin City': 'YONGIN_FC',
      '용인 시티': 'YONGIN_FC',
      'FC Seoul': 'FC_SEOUL',
      'Ulsan HD FC': 'ULSAN_HD',
      'Jeonbuk Motors': 'JEONBUK_HYUNDAU',
      'Daejeon Citizen': 'DAEJEON_HANA_CITIZEN',
      'Bucheon FC 1995': 'BUCHEON_FC_1995',
      'Gwangju FC': 'GWANGJU_FC',
      'Pohang Steelers': 'POHANG_STEELERS',
      'FC Anyang': 'FC_ANYANG',
      'Gimcheon Sangmu': 'GIMCHEON_SANGMU',
      'Incheon United': 'INCHEON_UNITED',
      'Gangwon FC': 'GANGWON_FC',
      'Jeju United FC': 'JEJU_SK',
      'Suwon Samsung Bluewings': 'SUWON_SAMSUNG_BLUEWINGS',
      'Busan I Park': 'BUSAN_IPARK',
      'Suwon City FC': 'SUWON_FC',
      'Daegu FC': 'DAEGU_FC',
      'Seoul E-Land FC': 'SEOUL_E_LAND',
      'Gimpo Citizen': 'GIMPO_FC',
      'Asan Mugunghwa': 'CHUNGNAM_ASAN_FC',
      'Seongnam FC': 'SEONGNAM_FC',
      'Cheonan City': 'CHEONAN_CITY_FC',
      'Ansan Greeners': 'ANSAN_GREENERS',
      'Gyeongnam FC': 'GYEONGNAM_FC',
      'Cheongju': 'CHEONGJU_FC',
      'Jeonnam Dragons': 'JEONNAM_DRAGONS',
    };

    if (aliases.containsKey(trimmed)) {
      return aliases[trimmed];
    }

    final normalizedInput = _normalizeForLookup(trimmed);

    for (final key in _data.keys) {
      if (_normalizeForLookup(key) == normalizedInput) {
        return key;
      }
    }

    return null;
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
