import '../../domain/repositories/sign_repository.dart';
import '../datasources/signs_local_data_source.dart';
import '../sign_model.dart';

class SignRepositoryImpl implements SignRepository {
  final SignsLocalDataSource _localDataSource;

  SignRepositoryImpl({SignsLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? SignsLocalDataSourceImpl();

  @override
  Future<List<SignModel>> getAllSigns() => _localDataSource.getSigns();

  @override
  Future<SignModel?> getSignById(String id) async {
    final all = await _localDataSource.getSigns();
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<String>> getCategories() => _localDataSource.getCategories();

  @override
  Future<Set<String>> getFavoriteSignIds() => _localDataSource.getFavoriteSignIds();

  @override
  Future<Set<String>> toggleFavoriteSign(String id) => _localDataSource.toggleFavorite(id);

  @override
  Future<Set<String>> getCompletedSignIds() => _localDataSource.getCompletedSignIds();

  @override
  Future<Set<String>> toggleCompletedSign(String id) => _localDataSource.toggleCompleted(id);
}
