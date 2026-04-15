abstract final class StadiumMap {
  static const Map<String, String> _data = {
    'FC 서울': '서울월드컵경기장',
    '울산 HD FC': '울산문수축구경기장',
    '전북 현대 모터스': '전주월드컵경기장',
    '인천 유나이티드': '인천축구전용경기장',
    '포항 스틸러스': '포항스틸야드',
    '대전 하나 시티즌': '대전월드컵경기장',
    '강원FC': '강릉종합운동장',
    '김천상무 FC': '김천종합스포츠타운주경기장',
    '대구 FC': 'DGB대구은행파크',
    '제주 SK FC': '제주월드컵경기장',
    '수원 FC': '수원종합운동장',
    '수원 삼성': '수원월드컵경기장',
    '서울 이랜드 FC': '잠실올림픽주경기장',
    '부산 아이파크': '부산구덕운동장',
    'FC안양': '안양종합운동장',
    '성남FC': '탄천종합운동장',
    '경남FC': '창원축구센터',
    '충남 아산 프로축구단': '이순신종합운동장',
    '안산 그리너스': '안산와~스타디움',
    '김포FC': '김포솔터축구장',
    '화성FC': '화성종합경기타운주경기장',
    '충북청주FC': '청주종합운동장',
    '전남 드래곤즈': '광양전용구장',
    '광주FC': '광주축구전용경기장',
    '용인FC': '용인미르스타디움',
    '김해FC2008': '김해스포츠센터',
    '파주프런티어FC': '파주스타디움',
    '천안시티FC': '천안종합운동장',
  };

  static String? lookup(String teamName) {
    if (_data.containsKey(teamName)) return _data[teamName];
    final noSpace = teamName.replaceAll(' ', '');
    for (final entry in _data.entries) {
      if (entry.key.replaceAll(' ', '') == noSpace) return entry.value;
    }
    return null;
  }
  static Uri naverMapUri(String stadiumName) {
    return Uri.parse(
      'nmap://search?query=${Uri.encodeComponent(stadiumName)}&appname=com.example.twelfth_mobile',
    );
  }

  static Uri naverMapWebUri(String stadiumName) {
    return Uri.parse(
      'https://map.naver.com/v5/search/${Uri.encodeComponent(stadiumName)}',
    );
  }
}
