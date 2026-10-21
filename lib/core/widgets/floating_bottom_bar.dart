import 'package:flutter/material.dart';
import 'app_adaptive_navigation_bar.dart';

/// Legacy alias for the navigation bar, now powered by [AppAdaptiveNavigationBar].
/// Provided for backwards compatibility.
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
    return AppAdaptiveNavigationBar.build(
      context: context,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
