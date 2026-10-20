import '../domain/entities/sign_entity.dart';

/// Data Transfer Object (DTO) for [SignEntity] supporting JSON serialization.
class SignModel extends SignEntity {
  const SignModel({
    required super.id,
    required super.arabicWord,
    required super.category,
    required super.description,
    required super.handShape,
    required super.movementSteps,
    required super.usageNote,
    super.difficulty = 'سهل',
    super.isPopular = false,
    super.gestureSymbol = '✋',
    super.relatedSignIds = const [],
    super.videoUrl,
    super.signbankGlossId,
    super.glossEnglish,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'arabicWord': arabicWord,
        'category': category,
        'description': description,
        'handShape': handShape,
        'movementSteps': movementSteps,
        'usageNote': usageNote,
        'difficulty': difficulty,
        'isPopular': isPopular,
        'gestureSymbol': gestureSymbol,
        'relatedSignIds': relatedSignIds,
        'videoUrl': videoUrl,
        'signbankGlossId': signbankGlossId,
        'glossEnglish': glossEnglish,
      };

  factory SignModel.fromJson(Map<String, dynamic> map) => SignModel(
        id: map['id'] as String,
        arabicWord: map['arabicWord'] as String,
        category: map['category'] as String,
        description: map['description'] as String,
        handShape: map['handShape'] as String,
        movementSteps: List<String>.from(map['movementSteps'] as List),
        usageNote: map['usageNote'] as String,
        difficulty: map['difficulty'] as String? ?? 'سهل',
        isPopular: map['isPopular'] as bool? ?? false,
        gestureSymbol: map['gestureSymbol'] as String? ?? '✋',
        relatedSignIds: List<String>.from(map['relatedSignIds'] as List? ?? []),
        videoUrl: map['videoUrl'] as String?,
        signbankGlossId: map['signbankGlossId'] as int?,
        glossEnglish: map['glossEnglish'] as String?,
      );

  SignModel copyWith({
    String? id,
    String? arabicWord,
    String? category,
    String? description,
    String? handShape,
    List<String>? movementSteps,
    String? usageNote,
    String? difficulty,
    bool? isPopular,
    String? gestureSymbol,
    List<String>? relatedSignIds,
    String? videoUrl,
    int? signbankGlossId,
    String? glossEnglish,
  }) {
    return SignModel(
      id: id ?? this.id,
      arabicWord: arabicWord ?? this.arabicWord,
      category: category ?? this.category,
      description: description ?? this.description,
      handShape: handShape ?? this.handShape,
      movementSteps: movementSteps ?? this.movementSteps,
      usageNote: usageNote ?? this.usageNote,
      difficulty: difficulty ?? this.difficulty,
      isPopular: isPopular ?? this.isPopular,
      gestureSymbol: gestureSymbol ?? this.gestureSymbol,
      relatedSignIds: relatedSignIds ?? this.relatedSignIds,
      videoUrl: videoUrl ?? this.videoUrl,
      signbankGlossId: signbankGlossId ?? this.signbankGlossId,
      glossEnglish: glossEnglish ?? this.glossEnglish,
    );
  }
}
