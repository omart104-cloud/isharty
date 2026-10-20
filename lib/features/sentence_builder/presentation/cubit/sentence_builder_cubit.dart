import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dictionary/data/sign_model.dart';
import '../../../dictionary/data/signs_data.dart';
import '../../domain/repositories/sentence_builder_repository.dart';
import 'sentence_builder_state.dart';

/// ViewModel managing the composition, editing, and playback of sign sentences.
class SentenceBuilderCubit extends Cubit<SentenceBuilderState> {
  final SentenceBuilderRepository repository;

  SentenceBuilderCubit({required this.repository}) : super(const SentenceBuilderState()) {
    _initDefaultState();
  }

  Future<void> _initDefaultState() async {
    final saved = await repository.getSavedSentences();

    // Friendly initial sentence: "السلام عليكم" + "المعلم" + "شكرًا"
    final initialSigns = <SignModel>[];
    for (final id in ['s_salam', 's_moalem', 's_shokran']) {
      try {
        final sign = SignsData.allSigns.firstWhere((s) => s.id == id);
        initialSigns.add(sign);
      } catch (_) {}
    }

    emit(state.copyWith(
      selectedSigns: initialSigns,
      savedSentences: saved,
    ));
  }

  void addSign(SignModel sign) {
    final updated = List<SignModel>.from(state.selectedSigns)..add(sign);
    emit(state.copyWith(selectedSigns: updated));
  }

  void removeSignAt(int index) {
    if (index >= 0 && index < state.selectedSigns.length) {
      final updated = List<SignModel>.from(state.selectedSigns)..removeAt(index);
      emit(state.copyWith(selectedSigns: updated));
    }
  }

  void clearSentence() {
    emit(state.copyWith(selectedSigns: []));
  }

  Future<void> saveCurrentSentence() async {
    if (state.selectedSigns.isEmpty) return;

    final sentenceText = state.sentenceText;
    final signIds = state.selectedSigns.map((s) => s.id).toList();

    final updated = await repository.saveSentence(
      sentenceText: sentenceText,
      signIds: signIds,
    );

    emit(state.copyWith(
      savedSentences: updated,
      statusMessage: 'تم حفظ الجملة بنجاح',
    ));
  }

  Future<void> deleteSavedSentence(String id) async {
    final updated = await repository.deleteSentence(id);
    emit(state.copyWith(savedSentences: updated));
  }
}
