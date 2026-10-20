import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class FloatingBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    const navItems = [
      _NavItem(
        index: 0,
        label: 'الرئيسية',
        icon: LucideIcons.home,
        activeIcon: Icons.home_rounded,
      ),
      _NavItem(
        index: 1,
        label: 'القاموس',
        icon: LucideIcons.bookOpen,
        activeIcon: Icons.menu_book_rounded,
      ),
      _NavItem(
        index: 2,
        label: 'اكتب جملة',
        icon: LucideIcons.messageSquare,
        activeIcon: Icons.chat_bubble_rounded,
      ),
      _NavItem(
        index: 3,
        label: 'المواقف',
        icon: LucideIcons.school,
        activeIcon: Icons.school_rounded,
      ),
      _NavItem(
        index: 4,
        label: 'حسابي',
        icon: LucideIcons.user,
        activeIcon: Icons.person_rounded,
      ),
    ];

    return Container(
      margin: EdgeInsets.only(
        left: AppSpacing.standard,
        right: AppSpacing.standard,
        bottom: bottomInset > 0 ? bottomInset + 4 : AppSpacing.standard,
      ),
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: AppSpacing.roundedPill,
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E0E3264),
            blurRadius: 28,
            offset: Offset(0, 10),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Color(0x0C2675E8),
            blurRadius: 10,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppSpacing.roundedPill,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: navItems.map((item) {
                final isSelected = currentIndex == item.index;
                return Expanded(
                  child: _NavBarButton(
                    item: item,
                    isSelected: isSelected,
                    onTap: () => onTap(item.index),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final int index;
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class _NavBarButton extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: item.label,
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.roundedPill,
        splashColor: AppColors.primaryBlue.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.blueToCyanGradient : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: AppSpacing.roundedPill,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 20,
                  color: isSelected ? Colors.white : AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.secondaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
