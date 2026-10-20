import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/signbank_repository.dart';
import 'sign_gloss_state.dart';

/// Cubit managing the fetch lifecycle and state of ASL Signbank glosses.
class SignGlossCubit extends Cubit<SignGlossState> {
  final SignbankRepository _repository;
  int? _lastRequestedId;

  SignGlossCubit({
    SignbankRepository? repository,
  })  : _repository = repository ?? SignbankRepository(),
        super(const SignGlossInitial());

  /// Returns the most recently requested gloss ID, if any.
  int? get lastRequestedId => _lastRequestedId;

  /// Loads an ASL Signbank gloss by its numeric [id].
  ///
  /// Emits [SignGlossLoading], followed by either [SignGlossLoaded] on success
  /// or [SignGlossError] on failure.
  Future<void> loadGloss(int id) async {
    if (id <= 0) {
      emit(SignGlossError('Please enter a valid numeric ID greater than 0.', glossId: id));
      return;
    }

    _lastRequestedId = id;
    emit(SignGlossLoading(id));

    try {
      final gloss = await _repository.fetchGlossById(id);
      emit(SignGlossLoaded(gloss));
    } on SignbankException catch (e) {
      emit(SignGlossError(e.message, glossId: id));
    } catch (e) {
      emit(SignGlossError('Unexpected error loading gloss #$id: $e', glossId: id));
    }
  }

  /// Retries loading the last requested gloss ID, or a default fallback ID.
  Future<void> retry([int defaultId = 1]) async {
    final idToLoad = _lastRequestedId ?? defaultId;
    await loadGloss(idToLoad);
  }
}
