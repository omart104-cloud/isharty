import 'package:flutter/foundation.dart';
import '../../domain/entities/app_preferences_entity.dart';

@immutable
class AppPreferencesState {
  final AppPreferencesEntity preferences;

  const AppPreferencesState({
    this.preferences = const AppPreferencesEntity(),
  });

  int get currentTabIndex => preferences.currentTabIndex;
  double get fontSizeScale => preferences.fontSizeScale;
  bool get highContrast => preferences.highContrast;
  bool get reduceMotion => preferences.reduceMotion;
  String get studentName => preferences.studentName;
  int get streakDays => preferences.streakDays;

  AppPreferencesState copyWith({
    AppPreferencesEntity? preferences,
  }) {
    return AppPreferencesState(
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPreferencesState &&
          runtimeType == other.runtimeType &&
          preferences == other.preferences;

  @override
  int get hashCode => preferences.hashCode;
}
