import '../../../../core/usecases/usecase.dart';
import '../repositories/sign_repository.dart';

class ToggleCompletedUseCase implements UseCase<Set<String>, String> {
  final SignRepository _repository;

  ToggleCompletedUseCase(this._repository);

  @override
  Future<Set<String>> call(String signId) {
    return _repository.toggleCompletedSign(signId);
  }
}
