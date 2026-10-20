import '../../../../core/usecases/usecase.dart';
import '../../data/sign_model.dart';
import '../repositories/sign_repository.dart';

class GetSignsUseCase implements UseCase<List<SignModel>, NoParams> {
  final SignRepository _repository;

  GetSignsUseCase(this._repository);

  @override
  Future<List<SignModel>> call(NoParams params) {
    return _repository.getAllSigns();
  }
}
