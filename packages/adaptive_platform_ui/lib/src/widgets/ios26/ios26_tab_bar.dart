import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/services.dart';
import '../adaptive_scaffold.dart';

/// iOS 26 styled tab bar with Liquid Glass effect
class IOS26TabBar extends StatelessWidget implements PreferredSizeWidget {
  const IOS26TabBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<AdaptiveNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;
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
                color: Color(0x0C000000),
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
              children: List.generate(
                destinations.length,
                (index) => Expanded(
                  child: _TabBarItem(
                    destination: destinations[index],
                    isSelected: index == selectedIndex,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onTap(index);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBarItem extends StatelessWidget {
  const _TabBarItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final AdaptiveNavigationDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;

    final activeColor = CupertinoTheme.of(context).primaryColor;
    final iconColor = isSelected
        ? activeColor
        : (isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2);

    final textColor = isSelected
        ? activeColor
        : (isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 0.7,
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getIcon(), color: iconColor, size: 24),
          const SizedBox(height: 2),
          Text(
            destination.label,
            style: TextStyle(
              fontSize: 10.5,
              color: textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    final icon = isSelected && destination.selectedIcon != null
        ? destination.selectedIcon
        : destination.icon;

    if (icon is IconData) {
      return icon;
    } else if (icon is String) {
      return _sfSymbolToCupertinoIcon(icon);
    }
    return CupertinoIcons.circle;
  }

  IconData _sfSymbolToCupertinoIcon(String sfSymbol) {
    const iconMap = {
      'house': CupertinoIcons.house,
      'house.fill': CupertinoIcons.house_fill,
      'book': CupertinoIcons.book,
      'book.fill': CupertinoIcons.book_fill,
      'bubble.left.and.bubble.right': CupertinoIcons.chat_bubble_2,
      'bubble.left.and.bubble.right.fill': CupertinoIcons.chat_bubble_2_fill,
      'building.2': CupertinoIcons.building_2_fill,
      'building.2.fill': CupertinoIcons.building_2_fill,
      'magnifyingglass': CupertinoIcons.search,
      'heart': CupertinoIcons.heart,
      'heart.fill': CupertinoIcons.heart_fill,
      'person': CupertinoIcons.person,
      'person.fill': CupertinoIcons.person_fill,
      'gear': CupertinoIcons.settings,
      'star': CupertinoIcons.star,
      'star.fill': CupertinoIcons.star_fill,
    };
    return iconMap[sfSymbol] ?? CupertinoIcons.circle;
  }
}
