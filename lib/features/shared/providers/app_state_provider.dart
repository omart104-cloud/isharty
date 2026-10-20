import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dictionary/data/sign_model.dart';
import '../../dictionary/data/signs_data.dart';

class SavedSentence {
  final String id;
  final String sentenceText;
  final List<String> signIds;
  final String formattedDate;

  const SavedSentence({
    required this.id,
    required this.sentenceText,
    required this.signIds,
    required this.formattedDate,
  });
}

class AppState {
  final int currentTabIndex;
  final Set<String> favoriteSignIds;
  final Set<String> completedSignIds;
  final List<SavedSentence> savedSentences;
  final String searchQuery;
  final String selectedCategory;
  final double fontSizeScale;
  final bool highContrast;
  final bool reduceMotion;
  final String studentName;
  final int streakDays;

  const AppState({
    this.currentTabIndex = 0,
    this.favoriteSignIds = const {'s_salam', 's_shokran', 's_mosaada'},
    this.completedSignIds = const {
      's_salam',
      's_shokran',
      's_men_fadlak',
      's_sabah_elkhair',
      's_modir',
      's_moalem',
      's_fasl',
      's_madrasa',
      's_qalam',
      's_saeed',
      's_naam',
      's_laa',
      's_maa',
      's_hammam',
    },
    this.savedSentences = const [
      SavedSentence(
        id: 'sent_1',
        sentenceText: 'السلام عليكم يا معلم من فضلك',
        signIds: ['s_salam', 's_moalem', 's_men_fadlak'],
        formattedDate: '18 أكتوبر 2026',
      ),
      SavedSentence(
        id: 'sent_2',
        sentenceText: 'أنا سعيد في المدرسة شكراً',
        signIds: ['s_saeed', 's_madrasa', 's_shokran'],
        formattedDate: '19 أكتوبر 2026',
      ),
    ],
    this.searchQuery = '',
    this.selectedCategory = 'الكل',
    this.fontSizeScale = 1.0,
    this.highContrast = false,
    this.reduceMotion = false,
    this.studentName = 'أحمد مصطفى',
    this.streakDays = 7,
  });

  AppState copyWith({
    int? currentTabIndex,
    Set<String>? favoriteSignIds,
    Set<String>? completedSignIds,
    List<SavedSentence>? savedSentences,
    String? searchQuery,
    String? selectedCategory,
    double? fontSizeScale,
    bool? highContrast,
    bool? reduceMotion,
    String? studentName,
    int? streakDays,
  }) {
    return AppState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      favoriteSignIds: favoriteSignIds ?? this.favoriteSignIds,
      completedSignIds: completedSignIds ?? this.completedSignIds,
      savedSentences: savedSentences ?? this.savedSentences,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      studentName: studentName ?? this.studentName,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}

class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() => const AppState();

  void setTabIndex(int index) {
    state = state.copyWith(currentTabIndex: index);
  }

  void toggleFavorite(String signId) {
    final updated = Set<String>.from(state.favoriteSignIds);
    if (updated.contains(signId)) {
      updated.remove(signId);
    } else {
      updated.add(signId);
    }
    state = state.copyWith(favoriteSignIds: updated);
  }

  void toggleCompleted(String signId) {
    final updated = Set<String>.from(state.completedSignIds);
    if (updated.contains(signId)) {
      updated.remove(signId);
    } else {
      updated.add(signId);
    }
    state = state.copyWith(completedSignIds: updated);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setFontSizeScale(double scale) {
    state = state.copyWith(fontSizeScale: scale);
  }

  void toggleHighContrast(bool value) {
    state = state.copyWith(highContrast: value);
  }

  void toggleReduceMotion(bool value) {
    state = state.copyWith(reduceMotion: value);
  }

  void updateStudentName(String name) {
    state = state.copyWith(studentName: name);
  }

  void saveSentence(String sentenceText, List<String> signIds) {
    final now = DateTime.now();
    final newSentence = SavedSentence(
      id: 'sent_${now.millisecondsSinceEpoch}',
      sentenceText: sentenceText,
      signIds: signIds,
      formattedDate: '${now.day}/${now.month}/${now.year}',
    );
    state = state.copyWith(savedSentences: [newSentence, ...state.savedSentences]);
  }

  void deleteSavedSentence(String id) {
    state = state.copyWith(
      savedSentences: state.savedSentences.where((s) => s.id != id).toList(),
    );
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(AppStateNotifier.new);

// Filtered Signs Provider based on search and category
final filteredSignsProvider = Provider<List<SignModel>>((ref) {
  final state = ref.watch(appStateProvider);
  const all = SignsData.allSigns;

  return all.where((sign) {
    final matchesCategory =
        state.selectedCategory == 'الكل' || sign.category == state.selectedCategory;
    final query = state.searchQuery.trim().toLowerCase();
    final matchesQuery = query.isEmpty ||
        sign.arabicWord.toLowerCase().contains(query) ||
        sign.description.toLowerCase().contains(query) ||
        sign.category.toLowerCase().contains(query);

    return matchesCategory && matchesQuery;
  }).toList();
});

// Popular Signs Provider
final popularSignsProvider = Provider<List<SignModel>>((ref) {
  return SignsData.allSigns.where((s) => s.isPopular).toList();
});

// Favorite Signs Provider
final favoriteSignsProvider = Provider<List<SignModel>>((ref) {
  final favIds = ref.watch(appStateProvider.select((s) => s.favoriteSignIds));
  return SignsData.allSigns.where((s) => favIds.contains(s.id)).toList();
});
