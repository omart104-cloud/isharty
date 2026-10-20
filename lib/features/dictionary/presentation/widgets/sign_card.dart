import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../shared/providers/app_state_provider.dart';
import '../../data/sign_model.dart';
import '../sign_detail_sheet.dart';

class SignCard extends ConsumerStatefulWidget {
  final SignModel sign;
  final bool isHorizontalCompact;

  const SignCard({
    super.key,
    required this.sign,
    this.isHorizontalCompact = false,
  });

  @override
  ConsumerState<SignCard> createState() => _SignCardState();
}

class _SignCardState extends ConsumerState<SignCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(
      appStateProvider.select((s) => s.favoriteSignIds.contains(widget.sign.id)),
    );
    final isCompleted = ref.watch(
      appStateProvider.select((s) => s.completedSignIds.contains(widget.sign.id)),
    );

    if (widget.isHorizontalCompact) {
      return _buildCompactCard(context, isFav, isCompleted);
    }

    return _buildStandardCard(context, isFav, isCompleted);
  }

  Widget _buildCompactCard(BuildContext context, bool isFav, bool isCompleted) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      onTap: () => SignDetailSheet.show(context, widget.sign),
      child: AnimatedScale(
        scale: _isHovered ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 156,
          padding: const EdgeInsets.all(AppSpacing.small),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: AppSpacing.roundedCard,
            border: Border.all(
              color: isCompleted
                  ? AppColors.emeraldGreen.withOpacity(0.35)
                  : AppColors.cardBorder,
              width: 1.2,
            ),
            boxShadow: AppSpacing.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Category tag + favorite button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.sign.category,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref.read(appStateProvider.notifier).toggleFavorite(widget.sign.id);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 18,
                        color: isFav ? AppColors.softCoral : AppColors.mutedText,
                      ),
                    ),
                  ),
                ],
              ),

              // Sign Visual Gesture Avatar
              Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryBlue.withOpacity(0.12),
                        AppColors.cyanAccent.withOpacity(0.08),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.sign.gestureSymbol,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
              ),

              // Title and Completion badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sign.arabicWord,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.primaryNavy,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        isCompleted ? Icons.check_circle_rounded : Icons.play_circle_outline_rounded,
                        size: 13,
                        color: isCompleted ? AppColors.emeraldGreen : AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isCompleted ? 'مكتمل' : 'عرض الحركة',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isCompleted ? AppColors.emeraldGreen : AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandardCard(BuildContext context, bool isFav, bool isCompleted) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      onTap: () => SignDetailSheet.show(context, widget.sign),
      child: AnimatedScale(
        scale: _isHovered ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: AppSpacing.roundedCard,
            border: Border.all(
              color: isCompleted
                  ? AppColors.emeraldGreen.withOpacity(0.35)
                  : AppColors.cardBorder,
              width: 1.2,
            ),
            boxShadow: AppSpacing.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryNavy.withOpacity(0.08),
                          AppColors.primaryBlue.withOpacity(0.12),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primaryBlue.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.sign.gestureSymbol,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.sign.arabicWord,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.sign.category,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primaryBlue,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warmGold.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.sign.difficulty,
                                style: AppTypography.labelSmall.copyWith(
                                  color: const Color(0xFFC78408),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(appStateProvider.notifier).toggleFavorite(widget.sign.id);
                    },
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? AppColors.softCoral : AppColors.mutedText,
                      size: 22,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.small),

              // Description
              Text(
                widget.sign.description,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.small),
              const Divider(color: AppColors.cardBorder, height: 1),
              const SizedBox(height: AppSpacing.small),

              // Footer row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.touch_app_rounded,
                          size: 14,
                          color: AppColors.secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.sign.handShape,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.secondaryText,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'عرض الحركة',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppColors.primaryBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
