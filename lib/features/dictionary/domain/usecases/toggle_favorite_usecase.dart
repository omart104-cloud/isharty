import '../../../../core/usecases/usecase.dart';
import '../repositories/sign_repository.dart';

class ToggleFavoriteUseCase implements UseCase<Set<String>, String> {
  final SignRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  @override
  Future<Set<String>> call(String signId) {
    return _repository.toggleFavoriteSign(signId);
  }
}
