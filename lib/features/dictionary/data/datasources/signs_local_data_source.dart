import '../sign_model.dart';
import '../signs_data.dart';

/// Local data source providing sign definitions and in-memory persistence.
abstract class SignsLocalDataSource {
  Future<List<SignModel>> getSigns();
  Future<List<String>> getCategories();
  Future<Set<String>> getFavoriteSignIds();
  Future<Set<String>> toggleFavorite(String signId);
  Future<Set<String>> getCompletedSignIds();
  Future<Set<String>> toggleCompleted(String signId);
}

class SignsLocalDataSourceImpl implements SignsLocalDataSource {
  final Set<String> _favoriteSignIds = {'s_salam', 's_shokran', 's_mosaada'};
  final Set<String> _completedSignIds = {
    's_salam',
    's_shokran',
    's_men_fadlak',
    's_sabah_elkhair',
    's_modir',
    's_moalem',
    's_fasl',
    's_madrasa',
    's_qalam',
    's_saeed',
    's_naam',
    's_laa',
    's_maa',
    's_hammam',
  };

  @override
  Future<List<SignModel>> getSigns() async {
    return List.unmodifiable(SignsData.allSigns);
  }

  @override
  Future<List<String>> getCategories() async {
    return List.unmodifiable(SignsData.categories);
  }

  @override
  Future<Set<String>> getFavoriteSignIds() async {
    return Set.unmodifiable(_favoriteSignIds);
  }

  @override
  Future<Set<String>> toggleFavorite(String signId) async {
    if (_favoriteSignIds.contains(signId)) {
      _favoriteSignIds.remove(signId);
    } else {
      _favoriteSignIds.add(signId);
    }
    return Set.unmodifiable(_favoriteSignIds);
  }

  @override
  Future<Set<String>> getCompletedSignIds() async {
    return Set.unmodifiable(_completedSignIds);
  }

  @override
  Future<Set<String>> toggleCompleted(String signId) async {
    if (_completedSignIds.contains(signId)) {
      _completedSignIds.remove(signId);
    } else {
      _completedSignIds.add(signId);
    }
    return Set.unmodifiable(_completedSignIds);
  }
}
