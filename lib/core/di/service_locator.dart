import '../../features/app_navigation/data/datasources/preferences_local_data_source.dart';
import '../../features/app_navigation/data/repositories/app_preferences_repository_impl.dart';
import '../../features/app_navigation/domain/repositories/app_preferences_repository.dart';
import '../../features/app_navigation/presentation/cubit/app_preferences_cubit.dart';
import '../../features/dictionary/data/datasources/signs_local_data_source.dart';
import '../../features/dictionary/data/repositories/sign_repository_impl.dart';
import '../../features/dictionary/domain/repositories/sign_repository.dart';
import '../../features/dictionary/presentation/cubit/dictionary_cubit.dart';
import '../../features/school_situations/data/datasources/situations_local_data_source.dart';
import '../../features/school_situations/data/repositories/situation_repository_impl.dart';
import '../../features/school_situations/domain/repositories/situation_repository.dart';
import '../../features/school_situations/presentation/cubit/situations_cubit.dart';
import '../../features/sentence_builder/data/datasources/sentence_builder_local_data_source.dart';
import '../../features/sentence_builder/data/repositories/sentence_builder_repository_impl.dart';
import '../../features/sentence_builder/domain/repositories/sentence_builder_repository.dart';
import '../../features/sentence_builder/presentation/cubit/sentence_builder_cubit.dart';
import '../../features/sign_gloss/repository/signbank_repository.dart';

/// Centralized service locator establishing dependency injection across Clean Architecture layers.
class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  // Repositories
  late SignRepository signRepository;
  late SentenceBuilderRepository sentenceBuilderRepository;
  late SituationRepository situationRepository;
  late AppPreferencesRepository appPreferencesRepository;
  late SignbankRepository signbankRepository;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  void init({bool force = false}) {
    if (_isInitialized && !force) return;

    signRepository = SignRepositoryImpl(
      localDataSource: SignsLocalDataSourceImpl(),
    );

    sentenceBuilderRepository = SentenceBuilderRepositoryImpl(
      dataSource: SentenceBuilderLocalDataSourceImpl(),
    );

    situationRepository = SituationRepositoryImpl(
      dataSource: SituationsLocalDataSourceImpl(),
    );

    appPreferencesRepository = AppPreferencesRepositoryImpl(
      dataSource: PreferencesLocalDataSourceImpl(),
    );

    signbankRepository = SignbankRepository();
    _isInitialized = true;
  }

  // Cubit Factories
  DictionaryCubit createDictionaryCubit() =>
      DictionaryCubit(repository: signRepository);

  SentenceBuilderCubit createSentenceBuilderCubit() =>
      SentenceBuilderCubit(repository: sentenceBuilderRepository);

  SituationsCubit createSituationsCubit() =>
      SituationsCubit(repository: situationRepository);

  AppPreferencesCubit createAppPreferencesCubit() =>
      AppPreferencesCubit(repository: appPreferencesRepository);
}
