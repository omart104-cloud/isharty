import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_preferences_entity.dart';
import '../../domain/repositories/app_preferences_repository.dart';
import 'app_preferences_state.dart';

/// ViewModel managing root navigation tab, accessibility, and user profile preferences.
class AppPreferencesCubit extends Cubit<AppPreferencesState> {
  final AppPreferencesRepository repository;

  AppPreferencesCubit({required this.repository}) : super(const AppPreferencesState()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await repository.getPreferences();
    emit(state.copyWith(preferences: prefs));
  }

  void setTabIndex(int index) {
    _updatePrefs(state.preferences.copyWith(currentTabIndex: index));
  }

  void setFontSizeScale(double scale) {
    _updatePrefs(state.preferences.copyWith(fontSizeScale: scale));
  }

  void toggleHighContrast(bool value) {
    _updatePrefs(state.preferences.copyWith(highContrast: value));
  }

  void toggleReduceMotion(bool value) {
    _updatePrefs(state.preferences.copyWith(reduceMotion: value));
  }

  void updateStudentName(String name) {
    _updatePrefs(state.preferences.copyWith(studentName: name));
  }

  void _updatePrefs(AppPreferencesEntity updated) {
    emit(state.copyWith(preferences: updated));
    repository.savePreferences(updated);
  }
}
