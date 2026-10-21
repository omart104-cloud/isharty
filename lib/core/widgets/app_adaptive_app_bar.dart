import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import 'adaptive_back_button.dart';

/// Configuration for an action in [AppAdaptiveAppBar].
class AppAdaptiveAppBarAction {
  /// Icon for Material (Android) platform.
  final IconData? materialIcon;

  /// Icon for Cupertino / iOS platform.
  final IconData? cupertinoIcon;

  /// Custom icon widget if IconData is not sufficient.
  final Widget? customIcon;

  /// Tooltip / accessibility label.
  final String? tooltip;

  /// Callback when pressed.
  final VoidCallback onPressed;

  /// Default icon color when inactive.
  final Color? color;

  /// Active icon color when [isActive] is true.
  final Color? activeColor;

  /// Whether the action is currently in an active/toggled state.
  final bool isActive;

  const AppAdaptiveAppBarAction({
    this.materialIcon,
    this.cupertinoIcon,
    this.customIcon,
    this.tooltip,
    required this.onPressed,
    this.color,
    this.activeColor,
    this.isActive = false,
  });
}

/// An adaptive App Bar implementing [PreferredSizeWidget].
///
/// Automatically presents:
/// - **iOS 26+**: Apple Liquid Glass frosted backdrop navigation bar with
///   centered title, liquid-glass circular action capsules, haptic feedback,
///   and RTL-aware back chevron.
/// - **Android**: Clean Material 3 [AppBar] with standard icon buttons,
///   ripple splash, and start-aligned title.
class AppAdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title widget (often a [Text]).
  final Widget? title;

  /// Shortcut for text title.
  final String? titleText;

  /// Optional subtitle.
  final String? subtitleText;

  /// List of adaptive action buttons.
  final List<AppAdaptiveAppBarAction>? actions;

  /// Custom leading widget.
  final Widget? leading;

  /// Whether to automatically show the back button if navigation can pop.
  final bool automaticallyImplyLeading;

  /// Optional bottom widget (e.g. tabs or search bar).
  final PreferredSizeWidget? bottom;

  /// Background color override.
  final Color? backgroundColor;

  /// Elevation on Android.
  final double elevation;

  /// Whether to center title on Android (always centered on iOS).
  final bool? centerTitle;

  const AppAdaptiveAppBar({
    super.key,
    this.title,
    this.titleText,
    this.subtitleText,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.backgroundColor,
    this.elevation = 0,
    this.centerTitle,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  Widget _buildTitleWidget(BuildContext context, bool isIOS) {
    if (title != null) return title!;

    final text = titleText ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : AppColors.primaryNavy;

    if (subtitleText != null && subtitleText!.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              fontSize: isIOS ? 16 : 18,
              color: primaryTextColor,
            ),
          ),
          Text(
            subtitleText!,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontWeight: FontWeight.w700,
        fontSize: isIOS ? 17 : 19,
        color: primaryTextColor,
      ),
    );
  }

  Widget _buildIOSActionButton(
    BuildContext context,
    AppAdaptiveAppBarAction action,
    bool isDark,
  ) {
    final effectiveActiveColor = action.activeColor ?? AppColors.primaryBlue;
    final effectiveInactiveColor =
        action.color ?? (isDark ? Colors.white : AppColors.primaryNavy);
    final iconColor =
        action.isActive ? effectiveActiveColor : effectiveInactiveColor;

    final iconData = action.cupertinoIcon ?? action.materialIcon;
    final iconWidget = action.customIcon ??
        (iconData != null
            ? Icon(
                iconData,
                size: 20,
                color: iconColor,
              )
            : const SizedBox.shrink());

    final button = CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 36,
      pressedOpacity: 0.65,
      onPressed: () {
        HapticFeedback.lightImpact();
        action.onPressed();
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: action.isActive
              ? effectiveActiveColor.withValues(alpha: 0.16)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.10)
                  : Colors.black.withValues(alpha: 0.05)),
          border: Border.all(
            color: action.isActive
                ? effectiveActiveColor.withValues(alpha: 0.35)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.14)
                    : Colors.black.withValues(alpha: 0.08)),
            width: 0.8,
          ),
        ),
        alignment: Alignment.center,
        child: iconWidget,
      ),
    );

    if (action.tooltip != null) {
      return Tooltip(
        message: action.tooltip!,
        child: button,
      );
    }

    return button;
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isIOS) {
      final canPop = Navigator.of(context).canPop();

      Widget? leadingWidget = leading;
      if (leadingWidget == null && automaticallyImplyLeading && canPop) {
        leadingWidget = const AppAdaptiveBackButton();
      }

      final actionsList = actions ?? const <AppAdaptiveAppBarAction>[];

      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor ??
                  (isDark
                      ? const Color(0xFF1C1C1E).withValues(alpha: 0.75)
                      : Colors.white.withValues(alpha: 0.82)),
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : const Color(0x1F000000),
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: kToolbarHeight - 0.5,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            // Leading widget or symmetric spacer
                            if (leadingWidget != null)
                              leadingWidget
                            else if (actionsList.isNotEmpty)
                              // Spacer to balance the actions on the trailing side
                              SizedBox(width: actionsList.length * 42.0),

                            // Centered Title
                            Expanded(
                              child: Center(
                                child: _buildTitleWidget(context, true),
                              ),
                            ),

                            // Actions row
                            if (actionsList.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: actionsList.map((action) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: _buildIOSActionButton(
                                      context,
                                      action,
                                      isDark,
                                    ),
                                  );
                                }).toList(),
                              )
                            else if (leadingWidget != null)
                              // Spacer to balance leading on left
                              const SizedBox(width: 42),
                          ],
                        ),
                      ),
                    ),
                    if (bottom != null) bottom!,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Material (Android / Other)
    final actionsList = actions ?? const <AppAdaptiveAppBarAction>[];
    return AppBar(
      title: _buildTitleWidget(context, false),
      centerTitle: centerTitle ?? false,
      elevation: elevation,
      backgroundColor: backgroundColor ?? Colors.white,
      surfaceTintColor: Colors.transparent,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actionsList.isNotEmpty
          ? [
              ...actionsList.map((action) {
                final effectiveActiveColor =
                    action.activeColor ?? AppColors.primaryBlue;
                final effectiveInactiveColor =
                    action.color ?? AppColors.primaryNavy;
                final iconColor = action.isActive
                    ? effectiveActiveColor
                    : effectiveInactiveColor;

                final iconData = action.materialIcon ?? action.cupertinoIcon;
                final iconWidget = action.customIcon ??
                    (iconData != null
                        ? Icon(iconData, color: iconColor)
                        : const SizedBox.shrink());

                return IconButton(
                  tooltip: action.tooltip,
                  icon: iconWidget,
                  onPressed: action.onPressed,
                );
              }),
              const SizedBox(width: 6),
            ]
          : null,
      bottom: bottom,
    );
  }
}
