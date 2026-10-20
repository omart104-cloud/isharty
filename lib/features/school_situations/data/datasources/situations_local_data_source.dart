import '../situation_model.dart';
import '../situations_data.dart';

abstract class SituationsLocalDataSource {
  Future<List<SchoolSituationModel>> getSituations();
}

class SituationsLocalDataSourceImpl implements SituationsLocalDataSource {
  @override
  Future<List<SchoolSituationModel>> getSituations() async {
    return List.unmodifiable(SituationsData.allSituations);
  }
}
