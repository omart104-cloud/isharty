import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Configuration for individual navigation destinations.
class NavigationItemConfig {
  final int index;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String sfSymbol;
  final String selectedSfSymbol;

  const NavigationItemConfig({
    required this.index,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.sfSymbol,
    required this.selectedSfSymbol,
  });
}

/// Centralized adaptive navigation destination configurations.
class AppAdaptiveNavigationBar {
  static const List<NavigationItemConfig> destinations = [
    NavigationItemConfig(
      index: 0,
      label: 'الرئيسية',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      sfSymbol: 'house',
      selectedSfSymbol: 'house.fill',
    ),
    NavigationItemConfig(
      index: 1,
      label: 'القاموس',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book_rounded,
      sfSymbol: 'book',
      selectedSfSymbol: 'book.fill',
    ),
    NavigationItemConfig(
      index: 2,
      label: 'اكتب جملة',
      icon: Icons.chat_bubble_outline_rounded,
      selectedIcon: Icons.chat_bubble_rounded,
      sfSymbol: 'bubble.left.and.bubble.right',
      selectedSfSymbol: 'bubble.left.and.bubble.right.fill',
    ),
    NavigationItemConfig(
      index: 3,
      label: 'المواقف',
      icon: Icons.school_outlined,
      selectedIcon: Icons.school_rounded,
      sfSymbol: 'building.2',
      selectedSfSymbol: 'building.2.fill',
    ),
    NavigationItemConfig(
      index: 4,
      label: 'حسابي',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      sfSymbol: 'person',
      selectedSfSymbol: 'person.fill',
    ),
  ];

  static List<AdaptiveNavigationDestination> get adaptiveDestinations =>
      destinations
          .map((d) => AdaptiveNavigationDestination(
                icon: d.icon,
                selectedIcon: d.selectedIcon,
                sfSymbol: d.sfSymbol,
                selectedSfSymbol: d.selectedSfSymbol,
                label: d.label,
              ))
          .toList();

  /// Builds a platform-adaptive bottom navigation bar widget.
  static Widget build({
    required BuildContext context,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return IOS26NativeTabBar(
        destinations: adaptiveDestinations,
        selectedIndex: currentIndex,
        onTap: onTap,
        tint: AppColors.primaryBlue,
        unselectedItemTint: AppColors.secondaryText,
      );
    }

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        height: 66,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryBlue.withValues(alpha: 0.12),
        elevation: 2,
        shadowColor: const Color(0x1E0E3264),
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.primaryBlue,
              size: 24,
            );
          }
          return const IconThemeData(
            color: AppColors.secondaryText,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            );
          }
          return const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
          );
        }),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: destinations.map((d) {
          return NavigationDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: d.label,
          );
        }).toList(),
      ),
    );
  }
}

/// An adaptive scaffold using adaptive_platform_ui:
/// - iOS: Native Cupertino-style Liquid Glass navigation bar via UITabBar / UIVisualEffectView
/// - Android: Material 3 NavigationBar
class AppAdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const AppAdaptiveScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: body,
      enableBlur: true,
      minimizeBehavior: TabBarMinimizeBehavior.never,
      bottomNavigationBar: AdaptiveBottomNavigationBar(
        selectedIndex: currentIndex,
        onTap: onTabSelected,
        useNativeBottomBar: true,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.secondaryText,
        bottomNavigationBar: AppAdaptiveNavigationBar.build(
          context: context,
          currentIndex: currentIndex,
          onTap: onTabSelected,
        ),
        items: AppAdaptiveNavigationBar.adaptiveDestinations,
      ),
    );
  }
}
