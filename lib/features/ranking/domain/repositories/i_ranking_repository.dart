import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';

abstract interface class IRankingRepository {
  Future<List<ClubRanking>> getRanking();
  Future<ClubDetail> getClubDetail(int clubId);
}
