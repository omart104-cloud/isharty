import 'package:flutter/foundation.dart';
import '../../data/sign_model.dart';

enum DictionaryStatus { initial, loading, loaded, error }

@immutable
class DictionaryState {
  final DictionaryStatus status;
  final List<SignModel> allSigns;
  final List<SignModel> filteredSigns;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final bool onlyFavorites;
  final bool onlyVideos;
  final Set<String> favoriteSignIds;
  final Set<String> completedSignIds;
  final String? errorMessage;

  const DictionaryState({
    this.status = DictionaryStatus.initial,
    this.allSigns = const [],
    this.filteredSigns = const [],
    this.categories = const [],
    this.selectedCategory = 'الكل',
    this.searchQuery = '',
    this.onlyFavorites = false,
    this.onlyVideos = false,
    this.favoriteSignIds = const {},
    this.completedSignIds = const {},
    this.errorMessage,
  });

  List<SignModel> get popularSigns => allSigns.where((s) => s.isPopular).toList();

  List<SignModel> get favoriteSigns =>
      allSigns.where((s) => favoriteSignIds.contains(s.id)).toList();

  SignModel? get nextSignToLearn {
    if (allSigns.isEmpty) return null;
    try {
      return allSigns.firstWhere((s) => !completedSignIds.contains(s.id));
    } catch (_) {
      return allSigns.first;
    }
  }

  int get completedCount => completedSignIds.length;
  int get totalCount => allSigns.length;

  DictionaryState copyWith({
    DictionaryStatus? status,
    List<SignModel>? allSigns,
    List<SignModel>? filteredSigns,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    bool? onlyFavorites,
    bool? onlyVideos,
    Set<String>? favoriteSignIds,
    Set<String>? completedSignIds,
    String? errorMessage,
  }) {
    return DictionaryState(
      status: status ?? this.status,
      allSigns: allSigns ?? this.allSigns,
      filteredSigns: filteredSigns ?? this.filteredSigns,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
      onlyVideos: onlyVideos ?? this.onlyVideos,
      favoriteSignIds: favoriteSignIds ?? this.favoriteSignIds,
      completedSignIds: completedSignIds ?? this.completedSignIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DictionaryState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          selectedCategory == other.selectedCategory &&
          searchQuery == other.searchQuery &&
          onlyFavorites == other.onlyFavorites &&
          onlyVideos == other.onlyVideos &&
          listEquals(filteredSigns, other.filteredSigns) &&
          setEquals(favoriteSignIds, other.favoriteSignIds) &&
          setEquals(completedSignIds, other.completedSignIds);

  @override
  int get hashCode =>
      status.hashCode ^
      selectedCategory.hashCode ^
      searchQuery.hashCode ^
      onlyFavorites.hashCode ^
      onlyVideos.hashCode ^
      Object.hashAll(favoriteSignIds) ^
      Object.hashAll(completedSignIds);
}
