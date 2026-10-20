import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/floating_bottom_bar.dart';
import '../features/dictionary/presentation/dictionary_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/school_situations/presentation/situations_screen.dart';
import '../features/sentence_builder/presentation/sentence_builder_screen.dart';
import '../features/shared/providers/app_state_provider.dart';

class IsharatyApp extends ConsumerWidget {
  const IsharatyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

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
            textScaler: TextScaler.linear(appState.fontSizeScale),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
      home: const MainShellScreen(),
    );
  }
}

class MainShellScreen extends ConsumerWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appStateProvider.select((s) => s.currentTabIndex));

    const screens = [
      HomeScreen(),
      DictionaryScreen(),
      SentenceBuilderScreen(),
      SituationsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: FloatingBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(appStateProvider.notifier).setTabIndex(index);
        },
      ),
    );
  }
}
