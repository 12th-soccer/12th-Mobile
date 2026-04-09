abstract final class TeamNameMap {
  static const Map<String, String> _data = {
    // K1
    'FC Seoul': 'FC 서울',
    'Ulsan HD FC': '울산 HD FC',
    'Jeonbuk Hyundai Motors FC': '전북 현대 모터스',
    'Daejeon Hana Citizen': '대전 하나 시티즌',
    'Bucheon FC 1995': '부천FC1995',
    'Gwangju FC': '광주FC',
    'FC Anyang': 'FC안양',
    'Gimcheon Sangmu': '김천상무 FC',
    'Incheon United': '인천 유나이티드',
    'Gangwon FC': '강원FC',
    'Pohang Steelers': '포항 스틸러스',
    'Jeju SK': '제주 SK FC',
    // K2
    'Suwon Samsung Bluewings': '수원 삼성',
    'Suwon Samsung': '수원 삼성',
    'Busan IPark': '부산 아이파크',
    'Suwon FC': '수원 FC',
    'Daegu FC': '대구 FC',
    'Seoul E-Land FC': '서울 이랜드 FC',
    'Gimpo FC': '김포FC',
    'Chungnam Asan': '충남 아산 프로축구단',
    'Paju Frontier FC': '파주프런티어FC',
    'Seongnam FC': '성남FC',
    'Cheonan City FC': '천안시티FC',
    'Ansan Greeners': '안산 그리너스',
    'Gyeongnam FC': '경남FC',
    'Hwaseong FC': '화성FC',
    'Chungbuk Cheongju FC': '충북청주FC',
    'Jeonnam Dragons': '전남 드래곤즈',
    'Yongin FC': '용인FC',
    'Gimhae FC 2008': '김해FC2008',
  };

  static String translate(String name) => _data[name] ?? name;
}
