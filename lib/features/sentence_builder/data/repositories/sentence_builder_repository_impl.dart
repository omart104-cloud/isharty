import '../../domain/entities/saved_sentence_entity.dart';
import '../../domain/repositories/sentence_builder_repository.dart';
import '../datasources/sentence_builder_local_data_source.dart';

class SentenceBuilderRepositoryImpl implements SentenceBuilderRepository {
  final SentenceBuilderLocalDataSource _dataSource;

  SentenceBuilderRepositoryImpl({SentenceBuilderLocalDataSource? dataSource})
      : _dataSource = dataSource ?? SentenceBuilderLocalDataSourceImpl();

  @override
  Future<List<SavedSentenceEntity>> getSavedSentences() => _dataSource.getSavedSentences();

  @override
  Future<List<SavedSentenceEntity>> saveSentence({
    required String sentenceText,
    required List<String> signIds,
  }) =>
      _dataSource.saveSentence(sentenceText, signIds);

  @override
  Future<List<SavedSentenceEntity>> deleteSentence(String id) => _dataSource.deleteSentence(id);
}
