import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// An adaptive back button that automatically renders:
/// - iOS / macOS: Authentic Apple Liquid Glass circular frosted capsule with haptic touch
/// - Android / other: Material 3 rounded back button with ripple
///
/// Fully supports RTL (Arabic) layout direction and optional custom callbacks.
class AppAdaptiveBackButton extends StatefulWidget {
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
  State<AppAdaptiveBackButton> createState() => _AppAdaptiveBackButtonState();
}

class _AppAdaptiveBackButtonState extends State<AppAdaptiveBackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handlePress() {
    HapticFeedback.lightImpact();
    if (widget.onPressed != null) {
      widget.onPressed!();
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS ||
        theme.platform == TargetPlatform.macOS;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final effectiveColor = widget.color ?? AppColors.primaryNavy;
    final effectiveTooltip = widget.tooltip ??
        MaterialLocalizations.of(context).backButtonTooltip;
    final isDark = theme.brightness == Brightness.dark;

    if (isIOS) {
      return Tooltip(
        message: effectiveTooltip,
        child: GestureDetector(
          onTapDown: (_) => _animController.forward(),
          onTapUp: (_) {
            _animController.reverse();
            _handlePress();
          },
          onTapCancel: () => _animController.reverse(),
          behavior: HitTestBehavior.opaque,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF2C2C2E).withValues(alpha: 0.70)
                          : Colors.white.withValues(alpha: 0.72),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.18)
                            : Colors.white.withValues(alpha: 0.90),
                        width: 0.8,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: isRtl ? 0 : 2,
                          left: isRtl ? 2 : 0,
                        ),
                        child: Icon(
                          isRtl
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.arrow_back_ios_new_rounded,
                          size: 17,
                          color: effectiveColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return IconButton(
      icon: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.04),
        ),
        child: Icon(
          isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
          size: 22,
          color: effectiveColor,
        ),
      ),
      tooltip: effectiveTooltip,
      splashColor: AppColors.primaryBlue.withValues(alpha: 0.12),
      onPressed: _handlePress,
    );
  }
}
