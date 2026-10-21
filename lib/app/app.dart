import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/di/service_locator.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_adaptive_navigation_bar.dart';
import '../features/app_navigation/presentation/cubit/app_preferences_cubit.dart';
import '../features/app_navigation/presentation/cubit/app_preferences_state.dart';
import '../features/dictionary/presentation/cubit/dictionary_cubit.dart';
import '../features/dictionary/presentation/dictionary_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/school_situations/presentation/cubit/situations_cubit.dart';
import '../features/school_situations/presentation/situations_screen.dart';
import '../features/sentence_builder/presentation/cubit/sentence_builder_cubit.dart';
import '../features/sentence_builder/presentation/sentence_builder_screen.dart';

class IsharatyApp extends StatelessWidget {
  const IsharatyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppPreferencesCubit>(
          create: (_) => ServiceLocator.instance.createAppPreferencesCubit(),
        ),
        BlocProvider<DictionaryCubit>(
          create: (_) => ServiceLocator.instance.createDictionaryCubit(),
        ),
        BlocProvider<SentenceBuilderCubit>(
          create: (_) => ServiceLocator.instance.createSentenceBuilderCubit(),
        ),
        BlocProvider<SituationsCubit>(
          create: (_) => ServiceLocator.instance.createSituationsCubit(),
        ),
      ],
      child: BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
        buildWhen: (previous, current) =>
            previous.fontSizeScale != current.fontSizeScale ||
            previous.highContrast != current.highContrast ||
            previous.reduceMotion != current.reduceMotion,
        builder: (context, prefsState) {
          return MaterialApp(
            title: 'إشارتي معاك',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: const Locale('ar', 'EG'),
            supportedLocales: const [
              Locale('ar', 'EG'),
              Locale('ar'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(prefsState.fontSizeScale),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: child!,
                ),
              );
            },
            home: const MainShellScreen(),
          );
        },
      ),
    );
  }
}

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select<AppPreferencesCubit, int>(
      (c) => c.state.currentTabIndex,
    );

    const screens = [
      HomeScreen(),
      DictionaryScreen(),
      SentenceBuilderScreen(),
      SituationsScreen(),
      ProfileScreen(),
    ];

    return AppAdaptiveScaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      currentIndex: currentIndex,
      onTabSelected: (index) {
        context.read<AppPreferencesCubit>().setTabIndex(index);
      },
    );
  }
}
