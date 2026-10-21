import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Configuration for individual navigation destinations.
class NavigationItemConfig {
  final int index;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final IconData cupertinoIcon;
  final IconData cupertinoSelectedIcon;

  const NavigationItemConfig({
    required this.index,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.cupertinoIcon,
    required this.cupertinoSelectedIcon,
  });
}

/// Centralized adaptive navigation destination configurations.
class AppAdaptiveNavigationBar {
  static const List<NavigationItemConfig> destinations = [
    NavigationItemConfig(
      index: 0,
      label: 'الرئيسية',
      icon: Icons.home_rounded,
      selectedIcon: Icons.home_rounded,
      cupertinoIcon: CupertinoIcons.house_fill,
      cupertinoSelectedIcon: CupertinoIcons.house_fill,
    ),
    NavigationItemConfig(
      index: 1,
      label: 'القاموس',
      icon: Icons.menu_book_rounded,
      selectedIcon: Icons.menu_book_rounded,
      cupertinoIcon: CupertinoIcons.book_fill,
      cupertinoSelectedIcon: CupertinoIcons.book_fill,
    ),
    NavigationItemConfig(
      index: 2,
      label: 'اكتب جملة',
      icon: Icons.chat_bubble_rounded,
      selectedIcon: Icons.chat_bubble_rounded,
      cupertinoIcon: CupertinoIcons.bubble_left_bubble_right_fill,
      cupertinoSelectedIcon: CupertinoIcons.bubble_left_bubble_right_fill,
    ),
    NavigationItemConfig(
      index: 3,
      label: 'المواقف',
      icon: Icons.school_rounded,
      selectedIcon: Icons.school_rounded,
      cupertinoIcon: CupertinoIcons.building_2_fill,
      cupertinoSelectedIcon: CupertinoIcons.building_2_fill,
    ),
    NavigationItemConfig(
      index: 4,
      label: 'حسابي',
      icon: Icons.person_rounded,
      selectedIcon: Icons.person_rounded,
      cupertinoIcon: CupertinoIcons.person_fill,
      cupertinoSelectedIcon: CupertinoIcons.person_fill,
    ),
  ];

  /// Builds a platform-adaptive bottom navigation bar widget.
  static Widget build({
    required BuildContext context,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return _buildIOSLiquidGlassBar(
        context: context,
        currentIndex: currentIndex,
        onTap: onTap,
      );
    }

    return _buildMaterialNavigationBar(
      context: context,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }

  /// High-performance iOS Liquid Glass bottom navigation bar.
  /// Features translucent backdrop blur, subtle top border highlight,
  /// and iOS-standard Cupertino iconography.
  static Widget _buildIOSLiquidGlassBar({
    required BuildContext context,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white.withOpacity(0.85),
            border: Border(
              top: BorderSide(
                color: CupertinoColors.systemGrey4.withOpacity(0.4),
                width: 0.5,
              ),
            ),
          ),
          child: CupertinoTabBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.transparent,
            border: null,
            activeColor: AppColors.primaryBlue,
            inactiveColor: AppColors.secondaryText,
            iconSize: 22,
            items: destinations.map((d) {
              final isSelected = d.index == currentIndex;
              return BottomNavigationBarItem(
                icon: Icon(
                  isSelected ? d.cupertinoSelectedIcon : d.cupertinoIcon,
                  size: 22,
                ),
                label: d.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Modern Material 3 NavigationBar with soft indicator pill and Cairo font.
  static Widget _buildMaterialNavigationBar({
    required BuildContext context,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        height: 66,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryBlue.withOpacity(0.12),
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

/// An adaptive scaffold that provides platform-specific bottom navigation:
/// - iOS: Native Cupertino-style liquid glass navigation
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
    return Scaffold(
      body: body,
      bottomNavigationBar: AppAdaptiveNavigationBar.build(
        context: context,
        currentIndex: currentIndex,
        onTap: onTabSelected,
      ),
    );
  }
}
