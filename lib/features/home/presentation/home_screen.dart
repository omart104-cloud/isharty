import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/section_header.dart';
import '../../app_navigation/presentation/cubit/app_preferences_cubit.dart';
import '../../app_navigation/presentation/cubit/app_preferences_state.dart';
import '../../dictionary/presentation/cubit/dictionary_cubit.dart';
import '../../dictionary/presentation/cubit/dictionary_state.dart';
import 'widgets/hero_banner.dart';
import 'widgets/learning_progress_card.dart';
import 'widgets/popular_signs_section.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/school_resources_card.dart';
import 'widgets/smart_search_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
      builder: (context, prefsState) {
        return BlocBuilder<DictionaryCubit, DictionaryState>(
          builder: (context, dictState) {
            final popularSigns = dictState.popularSigns;
            final nextSign = dictState.nextSignToLearn;

            return Scaffold(
              backgroundColor: AppColors.mainBackground,
              body: SafeArea(
                bottom: false,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 100),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Top App Header
                    AppHeader(
                      studentName: prefsState.studentName,
                      onAvatarTap: () {
                        context.read<AppPreferencesCubit>().setTabIndex(4); // Profile tab
                      },
                    ),
                    const SizedBox(height: AppSpacing.small),

                    // Hero Section Banner
                    HeroBanner(
                      onStartLearning: () {
                        context.read<AppPreferencesCubit>().setTabIndex(1); // Dictionary tab
                      },
                      onExploreDictionary: () {
                        context.read<AppPreferencesCubit>().setTabIndex(1);
                      },
                    ),
                    const SizedBox(height: AppSpacing.medium),

                    // Smart Search Bar
                    SmartSearchField(
                      onTap: () {
                        context.read<AppPreferencesCubit>().setTabIndex(1); // Switch to dictionary
                      },
                    ),
                    const SizedBox(height: AppSpacing.section),

                    // Quick Actions 2x2 Grid
                    const SectionHeader(
                      title: 'الوصول السريع',
                      subtitle: 'الخدمات والأدوات التعليمية اليومية',
                      icon: Icons.flash_on_rounded,
                      iconColor: AppColors.warmGold,
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    QuickActionsGrid(
                      onNavigateTab: (tabIndex) {
                        context.read<AppPreferencesCubit>().setTabIndex(tabIndex);
                      },
                    ),
                    const SizedBox(height: AppSpacing.section),

                    // Popular Signs ("إشارات هتحتاجها كتير")
                    SectionHeader(
                      title: 'إشارات هتحتاجها كتير',
                      subtitle: 'أهم الكلمات المتكررة في البيئة المدرسية',
                      icon: Icons.star_rounded,
                      iconColor: AppColors.primaryBlue,
                      actionText: 'عرض الكل',
                      onAction: () {
                        context.read<AppPreferencesCubit>().setTabIndex(1);
                      },
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    PopularSignsSection(signs: popularSigns),
                    const SizedBox(height: AppSpacing.section),

                    // Learning Progress Card
                    LearningProgressCard(
                      completedCount: dictState.completedCount,
                      totalCount: dictState.totalCount,
                      streakDays: prefsState.streakDays,
                      nextSignToLearn: nextSign,
                      onResume: () {
                        context.read<AppPreferencesCubit>().setTabIndex(1);
                      },
                    ),
                    const SizedBox(height: AppSpacing.section),

                    // Helpful School Resources
                    const SectionHeader(
                      title: 'موارد وخدمات المدرسة',
                      subtitle: 'أدوات مساعدة للتواصل وحل الاستفسارات',
                      icon: Icons.menu_book_rounded,
                      iconColor: AppColors.emeraldGreen,
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    const SchoolResourcesCard(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
