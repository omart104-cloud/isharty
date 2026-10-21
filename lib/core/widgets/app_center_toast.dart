import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// A sleek, centered platform-adaptive toast/HUD.
///
/// Displayed in the center of the screen so it never gets obscured by
/// bottom navigation bars or keyboard insets.
class AppCenterToast {
  static OverlayEntry? _activeEntry;

  /// Shows a centered toast with an icon and message.
  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    Color? iconColor,
    Duration duration = const Duration(milliseconds: 1700),
  }) {
    _activeEntry?.remove();
    _activeEntry = null;

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _CenterToastWidget(
        message: message,
        icon: icon,
        iconColor: iconColor,
        duration: duration,
        onDismiss: () {
          if (_activeEntry == entry) {
            entry.remove();
            _activeEntry = null;
          }
        },
      ),
    );

    _activeEntry = entry;
    overlay.insert(entry);
  }

  /// Helper to show a copy success toast in the center of the screen.
  static void showCopySuccess(
    BuildContext context, {
    String message = 'تم نسخ النص بنجاح',
  }) {
    HapticFeedback.lightImpact();
    show(
      context,
      message: message,
      icon: CupertinoIcons.checkmark_circle_fill,
      iconColor: AppColors.emeraldGreen,
    );
  }

  /// Helper to show a save success toast in the center of the screen.
  static void showSaveSuccess(
    BuildContext context, {
    String message = 'تم حفظ الجملة في ملفك الشخصي',
  }) {
    HapticFeedback.lightImpact();
    show(
      context,
      message: message,
      icon: CupertinoIcons.bookmark_fill,
      iconColor: AppColors.warmGold,
    );
  }
}

class _CenterToastWidget extends StatefulWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final Duration duration;
  final VoidCallback onDismiss;

  const _CenterToastWidget({
    required this.message,
    this.icon,
    this.iconColor,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_CenterToastWidget> createState() => _CenterToastWidgetState();
}

class _CenterToastWidgetState extends State<_CenterToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 260,
                    minWidth: 140,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xDD181E29),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.16),
                      width: 1.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 28,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (widget.iconColor ?? Colors.white)
                                .withValues(alpha: 0.15),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            widget.icon,
                            size: 26,
                            color: widget.iconColor ?? Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.35,
                        ),
                      ),
                    ],
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
