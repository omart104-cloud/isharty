import '../entities/app_preferences_entity.dart';

abstract class AppPreferencesRepository {
  Future<AppPreferencesEntity> getPreferences();
  Future<void> savePreferences(AppPreferencesEntity preferences);
}
