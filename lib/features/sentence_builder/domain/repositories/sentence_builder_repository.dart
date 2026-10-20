import '../entities/saved_sentence_entity.dart';

abstract class SentenceBuilderRepository {
  Future<List<SavedSentenceEntity>> getSavedSentences();
  Future<List<SavedSentenceEntity>> saveSentence({
    required String sentenceText,
    required List<String> signIds,
  });
  Future<List<SavedSentenceEntity>> deleteSentence(String id);
}
