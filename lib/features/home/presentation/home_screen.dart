import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/section_header.dart';
import '../../dictionary/data/signs_data.dart';
import '../../shared/providers/app_state_provider.dart';
import 'widgets/hero_banner.dart';
import 'widgets/learning_progress_card.dart';
import 'widgets/popular_signs_section.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/school_resources_card.dart';
import 'widgets/smart_search_field.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final popularSigns = ref.watch(popularSignsProvider);

    // Find the next sign that the student hasn't completed yet
    final nextSign = SignsData.allSigns.firstWhere(
      (s) => !appState.completedSignIds.contains(s.id),
      orElse: () => SignsData.allSigns.first,
    );

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
              studentName: appState.studentName,
              onAvatarTap: () {
                ref.read(appStateProvider.notifier).setTabIndex(4); // Profile tab
              },
            ),
            const SizedBox(height: AppSpacing.small),

            // Hero Section Banner
            HeroBanner(
              onStartLearning: () {
                ref.read(appStateProvider.notifier).setTabIndex(1); // Dictionary tab
              },
              onExploreDictionary: () {
                ref.read(appStateProvider.notifier).setTabIndex(1);
              },
            ),
            const SizedBox(height: AppSpacing.medium),

            // Smart Search Bar
            SmartSearchField(
              onTap: () {
                ref.read(appStateProvider.notifier).setTabIndex(1); // Switch to dictionary
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
                ref.read(appStateProvider.notifier).setTabIndex(tabIndex);
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
                ref.read(appStateProvider.notifier).setTabIndex(1);
              },
            ),
            const SizedBox(height: AppSpacing.compact),
            PopularSignsSection(signs: popularSigns),
            const SizedBox(height: AppSpacing.section),

            // Learning Progress Card
            LearningProgressCard(
              completedCount: appState.completedSignIds.length,
              totalCount: SignsData.allSigns.length,
              streakDays: appState.streakDays,
              nextSignToLearn: nextSign,
              onResume: () {
                ref.read(appStateProvider.notifier).setTabIndex(1);
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
  }
}
