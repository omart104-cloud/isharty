import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isSmall;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isSmall = false,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.width,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = widget.isSmall ? 40.0 : 50.0;
    final textStyle = (widget.isSmall ? AppTypography.labelLarge : AppTypography.titleMedium).copyWith(
      color: widget.textColor ??
          (widget.isSecondary ? AppColors.primaryNavy : Colors.white),
      fontWeight: FontWeight.w700,
    );

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: Container(
        width: widget.width,
        height: effectiveHeight,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.roundedMedium,
          gradient: widget.isSecondary
              ? null
              : (widget.gradient ?? AppColors.blueToCyanGradient),
          color: widget.isSecondary
              ? (widget.backgroundColor ?? Colors.white.withOpacity(0.9))
              : null,
          border: widget.isSecondary
              ? Border.all(color: AppColors.primaryBlue.withOpacity(0.2), width: 1.2)
              : null,
          boxShadow: widget.isSecondary
              ? AppSpacing.softShadow
              : [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppSpacing.roundedMedium,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: widget.onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isSmall ? 14 : 20,
              ),
              child: Row(
                mainAxisSize: widget.width == null ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: widget.isSmall ? 18 : 20,
                      color: widget.textColor ??
                          (widget.isSecondary ? AppColors.primaryNavy : Colors.white),
                    ),
                    const SizedBox(width: AppSpacing.compact),
                  ],
                  Flexible(
                    child: Text(
                      widget.text,
                      style: textStyle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
