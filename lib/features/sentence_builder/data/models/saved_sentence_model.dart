import '../../domain/entities/saved_sentence_entity.dart';

class SavedSentenceModel extends SavedSentenceEntity {
  const SavedSentenceModel({
    required super.id,
    required super.sentenceText,
    required super.signIds,
    required super.formattedDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'sentenceText': sentenceText,
        'signIds': signIds,
        'formattedDate': formattedDate,
      };

  factory SavedSentenceModel.fromJson(Map<String, dynamic> json) => SavedSentenceModel(
        id: json['id'] as String,
        sentenceText: json['sentenceText'] as String,
        signIds: List<String>.from(json['signIds'] as List),
        formattedDate: json['formattedDate'] as String,
      );
}
