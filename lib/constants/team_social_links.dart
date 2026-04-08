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

  static TeamSocialLinks? of(String teamName) => _data[teamName];
}
