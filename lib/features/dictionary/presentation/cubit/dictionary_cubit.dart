import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/sign_model.dart';
import '../../domain/repositories/sign_repository.dart';
import 'dictionary_state.dart';

/// ViewModel managing dictionary search, categorization, favorites, and completions.
class DictionaryCubit extends Cubit<DictionaryState> {
  final SignRepository repository;

  DictionaryCubit({required this.repository}) : super(const DictionaryState()) {
    loadDictionary();
  }

  Future<void> loadDictionary() async {
    emit(state.copyWith(status: DictionaryStatus.loading));
    try {
      final signs = await repository.getAllSigns();
      final categories = await repository.getCategories();
      final favorites = await repository.getFavoriteSignIds();
      final completed = await repository.getCompletedSignIds();

      final filtered = _filterSigns(
        allSigns: signs,
        category: state.selectedCategory,
        query: state.searchQuery,
        onlyFavs: state.onlyFavorites,
        onlyVids: state.onlyVideos,
        favoriteIds: favorites,
      );

      emit(state.copyWith(
        status: DictionaryStatus.loaded,
        allSigns: signs,
        categories: categories,
        favoriteSignIds: favorites,
        completedSignIds: completed,
        filteredSigns: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DictionaryStatus.error,
        errorMessage: 'Failed to load signs: $e',
      ));
    }
  }

  void setSearchQuery(String query) {
    final filtered = _filterSigns(
      allSigns: state.allSigns,
      category: state.selectedCategory,
      query: query,
      onlyFavs: state.onlyFavorites,
      onlyVids: state.onlyVideos,
      favoriteIds: state.favoriteSignIds,
    );

    emit(state.copyWith(
      searchQuery: query,
      filteredSigns: filtered,
    ));
  }

  void setSelectedCategory(String category) {
    final filtered = _filterSigns(
      allSigns: state.allSigns,
      category: category,
      query: state.searchQuery,
      onlyFavs: state.onlyFavorites,
      onlyVids: state.onlyVideos,
      favoriteIds: state.favoriteSignIds,
    );

    emit(state.copyWith(
      selectedCategory: category,
      filteredSigns: filtered,
    ));
  }

  void toggleOnlyFavorites([bool? value]) {
    final newValue = value ?? !state.onlyFavorites;
    final filtered = _filterSigns(
      allSigns: state.allSigns,
      category: state.selectedCategory,
      query: state.searchQuery,
      onlyFavs: newValue,
      onlyVids: state.onlyVideos,
      favoriteIds: state.favoriteSignIds,
    );

    emit(state.copyWith(
      onlyFavorites: newValue,
      filteredSigns: filtered,
    ));
  }

  void toggleOnlyVideos([bool? value]) {
    final newValue = value ?? !state.onlyVideos;
    final filtered = _filterSigns(
      allSigns: state.allSigns,
      category: state.selectedCategory,
      query: state.searchQuery,
      onlyFavs: state.onlyFavorites,
      onlyVids: newValue,
      favoriteIds: state.favoriteSignIds,
    );

    emit(state.copyWith(
      onlyVideos: newValue,
      filteredSigns: filtered,
    ));
  }

  void resetFilters() {
    final filtered = _filterSigns(
      allSigns: state.allSigns,
      category: 'الكل',
      query: '',
      onlyFavs: false,
      onlyVids: false,
      favoriteIds: state.favoriteSignIds,
    );

    emit(state.copyWith(
      selectedCategory: 'الكل',
      searchQuery: '',
      onlyFavorites: false,
      onlyVideos: false,
      filteredSigns: filtered,
    ));
  }

  Future<void> toggleFavorite(String signId) async {
    final updatedFavorites = await repository.toggleFavoriteSign(signId);
    final filtered = _filterSigns(
      allSigns: state.allSigns,
      category: state.selectedCategory,
      query: state.searchQuery,
      onlyFavs: state.onlyFavorites,
      onlyVids: state.onlyVideos,
      favoriteIds: updatedFavorites,
    );

    emit(state.copyWith(
      favoriteSignIds: updatedFavorites,
      filteredSigns: filtered,
    ));
  }

  Future<void> toggleCompleted(String signId) async {
    final updatedCompleted = await repository.toggleCompletedSign(signId);
    emit(state.copyWith(completedSignIds: updatedCompleted));
  }

  static List<SignModel> _filterSigns({
    required List<SignModel> allSigns,
    required String category,
    required String query,
    required bool onlyFavs,
    required bool onlyVids,
    required Set<String> favoriteIds,
  }) {
    final cleanQuery = query.trim().toLowerCase();

    return allSigns.where((sign) {
      if (onlyFavs && !favoriteIds.contains(sign.id)) {
        return false;
      }
      if (onlyVids && !sign.hasVideo) {
        return false;
      }
      if (category != 'الكل' && sign.category != category) {
        return false;
      }
      if (cleanQuery.isNotEmpty) {
        final matchesWord = sign.arabicWord.toLowerCase().contains(cleanQuery);
        final matchesDesc = sign.description.toLowerCase().contains(cleanQuery);
        final matchesCat = sign.category.toLowerCase().contains(cleanQuery);
        final matchesGloss = sign.glossEnglish?.toLowerCase().contains(cleanQuery) ?? false;
        if (!matchesWord && !matchesDesc && !matchesCat && !matchesGloss) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}
