import 'package:flutter/foundation.dart';
import '../../../dictionary/data/sign_model.dart';
import '../../domain/entities/saved_sentence_entity.dart';

@immutable
class SentenceBuilderState {
  final List<SignModel> selectedSigns;
  final List<SavedSentenceEntity> savedSentences;
  final bool isPlayingSequence;
  final int currentPlayingIndex;
  final String? statusMessage;

  const SentenceBuilderState({
    this.selectedSigns = const [],
    this.savedSentences = const [],
    this.isPlayingSequence = false,
    this.currentPlayingIndex = 0,
    this.statusMessage,
  });

  String get sentenceText => selectedSigns.map((s) => s.arabicWord).join(' ');

  bool get isEmpty => selectedSigns.isEmpty;

  SentenceBuilderState copyWith({
    List<SignModel>? selectedSigns,
    List<SavedSentenceEntity>? savedSentences,
    bool? isPlayingSequence,
    int? currentPlayingIndex,
    String? statusMessage,
  }) {
    return SentenceBuilderState(
      selectedSigns: selectedSigns ?? this.selectedSigns,
      savedSentences: savedSentences ?? this.savedSentences,
      isPlayingSequence: isPlayingSequence ?? this.isPlayingSequence,
      currentPlayingIndex: currentPlayingIndex ?? this.currentPlayingIndex,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SentenceBuilderState &&
          runtimeType == other.runtimeType &&
          listEquals(selectedSigns, other.selectedSigns) &&
          listEquals(savedSentences, other.savedSentences) &&
          isPlayingSequence == other.isPlayingSequence &&
          currentPlayingIndex == other.currentPlayingIndex;

  @override
  int get hashCode =>
      Object.hashAll(selectedSigns) ^
      Object.hashAll(savedSentences) ^
      isPlayingSequence.hashCode ^
      currentPlayingIndex.hashCode;
}
