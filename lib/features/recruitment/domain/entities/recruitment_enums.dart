enum AgeGroup {
  teenages,
  twenties,
  thirties,
  forties,
  fiftiesPlus;

  String get apiValue => switch (this) {
        AgeGroup.teenages => 'TEENAGES',
        AgeGroup.twenties => 'TWENTIES',
        AgeGroup.thirties => 'THIRTIES',
        AgeGroup.forties => 'FORTIES',
        AgeGroup.fiftiesPlus => 'FIFTIES_PLUS',
      };

  String get displayTag => switch (this) {
        AgeGroup.teenages => '#10대',
        AgeGroup.twenties => '#20대',
        AgeGroup.thirties => '#30대',
        AgeGroup.forties => '#40대',
        AgeGroup.fiftiesPlus => '#50대+',
      };

  static AgeGroup? fromApiValue(String? v) => switch (v) {
        'TEENAGES' => AgeGroup.teenages,
        'TWENTIES' => AgeGroup.twenties,
        'THIRTIES' => AgeGroup.thirties,
        'FORTIES' => AgeGroup.forties,
        'FIFTIES_PLUS' => AgeGroup.fiftiesPlus,
        _ => null,
      };

  static AgeGroup? fromTag(String tag) => switch (tag) {
        '#10대' => AgeGroup.teenages,
        '#20대' => AgeGroup.twenties,
        '#30대' => AgeGroup.thirties,
        '#40대' => AgeGroup.forties,
        '#50대+' => AgeGroup.fiftiesPlus,
        _ => null,
      };
}

enum GenderGroup {
  female,
  male,
  any;

  String get apiValue => switch (this) {
        GenderGroup.female => 'FEMALE',
        GenderGroup.male => 'MALE',
        GenderGroup.any => 'ANY',
      };

  String get displayTag => switch (this) {
        GenderGroup.female => '#여성',
        GenderGroup.male => '#남성',
        GenderGroup.any => '#성별무관',
      };

  static GenderGroup? fromApiValue(String? v) => switch (v) {
        'FEMALE' => GenderGroup.female,
        'MALE' => GenderGroup.male,
        'ANY' => GenderGroup.any,
        _ => null,
      };

  static GenderGroup? fromTag(String tag) => switch (tag) {
        '#여성' => GenderGroup.female,
        '#남성' => GenderGroup.male,
        '#성별무관' => GenderGroup.any,
        _ => null,
      };
}
