import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/situation_repository.dart';
import 'situations_state.dart';

/// ViewModel managing school situations data and lifecycle.
class SituationsCubit extends Cubit<SituationsState> {
  final SituationRepository repository;

  SituationsCubit({required this.repository}) : super(const SituationsState()) {
    loadSituations();
  }

  Future<void> loadSituations() async {
    emit(state.copyWith(status: SituationsStatus.loading));
    try {
      final situations = await repository.getAllSituations();
      emit(state.copyWith(
        status: SituationsStatus.loaded,
        situations: situations,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SituationsStatus.error,
        errorMessage: 'Failed to load situations: $e',
      ));
    }
  }
}
