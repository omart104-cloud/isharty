import '../models/saved_sentence_model.dart';

abstract class SentenceBuilderLocalDataSource {
  Future<List<SavedSentenceModel>> getSavedSentences();
  Future<List<SavedSentenceModel>> saveSentence(String sentenceText, List<String> signIds);
  Future<List<SavedSentenceModel>> deleteSentence(String id);
}

class SentenceBuilderLocalDataSourceImpl implements SentenceBuilderLocalDataSource {
  final List<SavedSentenceModel> _sentences = [
    const SavedSentenceModel(
      id: 'sent_1',
      sentenceText: 'السلام عليكم يا معلم من فضلك',
      signIds: ['s_salam', 's_moalem', 's_men_fadlak'],
      formattedDate: '18 أكتوبر 2026',
    ),
    const SavedSentenceModel(
      id: 'sent_2',
      sentenceText: 'أنا سعيد في المدرسة شكراً',
      signIds: ['s_saeed', 's_madrasa', 's_shokran'],
      formattedDate: '19 أكتوبر 2026',
    ),
  ];

  @override
  Future<List<SavedSentenceModel>> getSavedSentences() async {
    return List.unmodifiable(_sentences);
  }

  @override
  Future<List<SavedSentenceModel>> saveSentence(String sentenceText, List<String> signIds) async {
    final now = DateTime.now();
    final newSentence = SavedSentenceModel(
      id: 'sent_${now.millisecondsSinceEpoch}',
      sentenceText: sentenceText,
      signIds: List.from(signIds),
      formattedDate: '${now.day}/${now.month}/${now.year}',
    );
    _sentences.insert(0, newSentence);
    return List.unmodifiable(_sentences);
  }

  @override
  Future<List<SavedSentenceModel>> deleteSentence(String id) async {
    _sentences.removeWhere((s) => s.id == id);
    return List.unmodifiable(_sentences);
  }
}
