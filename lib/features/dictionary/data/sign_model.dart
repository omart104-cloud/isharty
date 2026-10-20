class SignModel {
  final String id;
  final String arabicWord;
  final String category;
  final String description;
  final String handShape;
  final List<String> movementSteps;
  final String usageNote;
  final String difficulty;
  final bool isPopular;
  final String gestureSymbol;
  final List<String> relatedSignIds;

  const SignModel({
    required this.id,
    required this.arabicWord,
    required this.category,
    required this.description,
    required this.handShape,
    required this.movementSteps,
    required this.usageNote,
    this.difficulty = 'سهل',
    this.isPopular = false,
    this.gestureSymbol = '✋',
    this.relatedSignIds = const [],
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
      );
}
