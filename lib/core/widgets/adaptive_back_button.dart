import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// An adaptive back button that automatically selects the appropriate design:
/// - iOS / macOS: Native iOS-style chevron with smooth touch response
/// - Android / other: Material 3 rounded arrow with ripple
///
/// Fully supports RTL (Arabic) layout direction and optional custom callbacks.
class AppAdaptiveBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final String? tooltip;

  const AppAdaptiveBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS ||
        theme.platform == TargetPlatform.macOS;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final effectiveColor = color ?? AppColors.primaryNavy;
    final effectiveTooltip = tooltip ??
        MaterialLocalizations.of(context).backButtonTooltip;

    void handlePress() {
      HapticFeedback.lightImpact();
      if (onPressed != null) {
        onPressed!();
      } else {
        Navigator.maybePop(context);
      }
    }

    if (isIOS) {
      return IconButton(
        icon: Icon(
          isRtl
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: effectiveColor,
        ),
        tooltip: effectiveTooltip,
        splashColor: Colors.transparent,
        highlightColor: AppColors.primaryBlue.withOpacity(0.08),
        onPressed: handlePress,
      );
    }

    return IconButton(
      icon: Icon(
        isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
        size: 24,
        color: effectiveColor,
      ),
      tooltip: effectiveTooltip,
      splashColor: AppColors.primaryBlue.withOpacity(0.12),
      onPressed: handlePress,
    );
  }
}
