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
  };

  static int? lookup(String teamName) {
    if (_data.containsKey(teamName)) return _data[teamName];
    final noSpace = teamName.replaceAll(' ', '');
    for (final entry in _data.entries) {
      if (entry.key.replaceAll(' ', '') == noSpace) return entry.value;
    }
    return null;
  }
}
