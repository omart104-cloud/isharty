import '../../domain/entities/situation_entity.dart';
import '../../domain/repositories/situation_repository.dart';
import '../datasources/situations_local_data_source.dart';

class SituationRepositoryImpl implements SituationRepository {
  final SituationsLocalDataSource _dataSource;

  SituationRepositoryImpl({SituationsLocalDataSource? dataSource})
      : _dataSource = dataSource ?? SituationsLocalDataSourceImpl();

  @override
  Future<List<SchoolSituationEntity>> getAllSituations() => _dataSource.getSituations();

  @override
  Future<SchoolSituationEntity?> getSituationById(String id) async {
    final all = await _dataSource.getSituations();
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
