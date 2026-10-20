import '../../domain/entities/app_preferences_entity.dart';
import '../../domain/repositories/app_preferences_repository.dart';
import '../datasources/preferences_local_data_source.dart';

class AppPreferencesRepositoryImpl implements AppPreferencesRepository {
  final PreferencesLocalDataSource _dataSource;

  AppPreferencesRepositoryImpl({PreferencesLocalDataSource? dataSource})
      : _dataSource = dataSource ?? PreferencesLocalDataSourceImpl();

  @override
  Future<AppPreferencesEntity> getPreferences() => _dataSource.loadPreferences();

  @override
  Future<void> savePreferences(AppPreferencesEntity preferences) =>
      _dataSource.savePreferences(preferences);
}
