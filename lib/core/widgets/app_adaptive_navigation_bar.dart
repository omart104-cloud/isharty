import 'dart:ui';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_liquid_glass/native_liquid_glass.dart';
import '../theme/app_colors.dart';

/// Navigation item configuration shared across platforms.
class NavigationItemConfig {
  final int index;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String sfSymbol;
  final String selectedSfSymbol;
  final IconData cupertinoIcon;
  final IconData selectedCupertinoIcon;

  const NavigationItemConfig({
    required this.index,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.sfSymbol,
    required this.selectedSfSymbol,
    required this.cupertinoIcon,
    required this.selectedCupertinoIcon,
  });
}

/// Adaptive navigation destinations definition
class AppAdaptiveNavigationBar {
  static const List<NavigationItemConfig> destinations = [
    NavigationItemConfig(
      index: 0,
      label: 'الرئيسية',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      sfSymbol: 'house',
      selectedSfSymbol: 'house.fill',
      cupertinoIcon: CupertinoIcons.house,
      selectedCupertinoIcon: CupertinoIcons.house_fill,
    ),
    NavigationItemConfig(
      index: 1,
      label: 'القاموس',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book_rounded,
      sfSymbol: 'book',
      selectedSfSymbol: 'book.fill',
      cupertinoIcon: CupertinoIcons.book,
      selectedCupertinoIcon: CupertinoIcons.book_fill,
    ),
    NavigationItemConfig(
      index: 2,
      label: 'اكتب جملة',
      icon: Icons.chat_bubble_outline_rounded,
      selectedIcon: Icons.chat_bubble_rounded,
      sfSymbol: 'bubble.left.and.bubble.right',
      selectedSfSymbol: 'bubble.left.and.bubble.right.fill',
      cupertinoIcon: CupertinoIcons.chat_bubble_2,
      selectedCupertinoIcon: CupertinoIcons.chat_bubble_2_fill,
    ),
    NavigationItemConfig(
      index: 3,
      label: 'المواقف',
      icon: Icons.school_outlined,
      selectedIcon: Icons.school_rounded,
      sfSymbol: 'building.2',
      selectedSfSymbol: 'building.2.fill',
      cupertinoIcon: CupertinoIcons.building_2_fill,
      selectedCupertinoIcon: CupertinoIcons.building_2_fill,
    ),
    NavigationItemConfig(
      index: 4,
      label: 'حسابي',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      sfSymbol: 'person',
      selectedSfSymbol: 'person.fill',
      cupertinoIcon: CupertinoIcons.person,
      selectedCupertinoIcon: CupertinoIcons.person_fill,
    ),
  ];

  static List<AdaptiveNavigationDestination> get adaptiveDestinations =>
      destinations
          .map((d) => AdaptiveNavigationDestination(
                icon: PlatformInfo.isIOS ? d.sfSymbol : d.icon,
                selectedIcon:
                    PlatformInfo.isIOS ? d.selectedSfSymbol : d.selectedIcon,
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
      if (NativeLiquidGlassUtils.supportsLiquidGlass) {
        return SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: LiquidGlassTabBar(
            items: destinations.map((d) {
              return LiquidGlassTabItem(
                label: d.label,
                icon: NativeLiquidGlassIcon.sfSymbol(d.sfSymbol),
                selectedIcon: NativeLiquidGlassIcon.sfSymbol(d.selectedSfSymbol),
                selectedItemColor: AppColors.primaryBlue,
              );
            }).toList(),
            currentIndex: currentIndex,
            onTabSelected: onTap,
            height: 64,
            showLabels: true,
            selectedItemColor: AppColors.primaryBlue,
            labelTextStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }

      return AppLiquidGlassNavigationBar(
        destinations: destinations,
        currentIndex: currentIndex,
        onTap: onTap,
      );
    }

    // Android: Modern curved top surface navigation bar
    return AppAndroidCurvedNavigationBar(
      destinations: destinations,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}

/// Modern Material 3 edge-to-edge bar for Android with curved top corners (24px)
/// and soft elevation indicator capsule.
class AppAndroidCurvedNavigationBar extends StatelessWidget {
  final List<NavigationItemConfig> destinations;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppAndroidCurvedNavigationBar({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final surfaceColor = isDark ? const Color(0xFF1E222B) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0x180E3264),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0x140E3264),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: bottomInset, top: 8),
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(destinations.length, (index) {
            final item = destinations[index];
            final isSelected = index == currentIndex;

            return Expanded(
              child: InkResponse(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTap(index);
                },
                radius: 28,
                highlightColor: Colors.transparent,
                splashColor: AppColors.primaryBlue.withValues(alpha: 0.12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryBlue.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        isSelected ? item.selectedIcon : item.icon,
                        size: 22,
                        color: isSelected
                            ? AppColors.primaryBlue
                            : AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10.5,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryBlue
                            : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// iOS Liquid Glass navigation bar with frosted blur,
/// safe area padding, and smooth haptic feedback.
class AppLiquidGlassNavigationBar extends StatelessWidget {
  final List<NavigationItemConfig> destinations;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppLiquidGlassNavigationBar({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1C1C1E).withValues(alpha: 0.72)
                : Colors.white.withValues(alpha: 0.75),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.85),
                width: 0.5,
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(destinations.length, (index) {
                final item = destinations[index];
                final isSelected = index == currentIndex;

                return Expanded(
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    pressedOpacity: 0.65,
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      onTap(index);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected
                              ? item.selectedCupertinoIcon
                              : item.cupertinoIcon,
                          size: 23,
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.secondaryText,
                        ),
                        const SizedBox(height: 2.5),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10.5,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primaryBlue
                                : AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// An adaptive scaffold:
/// - iOS: native_liquid_glass LiquidGlassTabBar (with authentic blur fallback)
/// - Android: Modern curved top surface navigation bar
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
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      final bottomInset = MediaQuery.paddingOf(context).bottom;
      final barHeight = 56.0 + bottomInset;

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding: MediaQuery.paddingOf(context).copyWith(
                  bottom: barHeight,
                ),
              ),
              child: body,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppAdaptiveNavigationBar.build(
                context: context,
                currentIndex: currentIndex,
                onTap: onTabSelected,
              ),
            ),
          ],
        ),
      );
    }

    // Android: Modern curved top surface navigation bar
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: body,
      bottomNavigationBar: AppAndroidCurvedNavigationBar(
        destinations: AppAdaptiveNavigationBar.destinations,
        currentIndex: currentIndex,
        onTap: onTabSelected,
      ),
    );
  }
}
