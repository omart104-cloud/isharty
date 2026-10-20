import '../../domain/entities/app_preferences_entity.dart';

abstract class PreferencesLocalDataSource {
  Future<AppPreferencesEntity> loadPreferences();
  Future<void> savePreferences(AppPreferencesEntity preferences);
}

class PreferencesLocalDataSourceImpl implements PreferencesLocalDataSource {
  AppPreferencesEntity _preferences = const AppPreferencesEntity();

  @override
  Future<AppPreferencesEntity> loadPreferences() async {
    return _preferences;
  }

  @override
  Future<void> savePreferences(AppPreferencesEntity preferences) async {
    _preferences = preferences;
  }
}
