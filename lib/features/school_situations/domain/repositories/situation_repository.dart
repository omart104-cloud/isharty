import '../entities/situation_entity.dart';

abstract class SituationRepository {
  Future<List<SchoolSituationEntity>> getAllSituations();
  Future<SchoolSituationEntity?> getSituationById(String id);
}
