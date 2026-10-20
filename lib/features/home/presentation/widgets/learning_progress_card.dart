import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../dictionary/data/sign_model.dart';
import '../../../dictionary/presentation/sign_detail_sheet.dart';

class LearningProgressCard extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final int streakDays;
  final SignModel? nextSignToLearn;
  final VoidCallback onResume;

  const LearningProgressCard({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.streakDays,
    this.nextSignToLearn,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = totalCount > 0 ? (completedCount / totalCount).clamp(0.0, 1.0) : 0.0;
    final percent = (ratio * 100).toInt();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.standard),
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSpacing.roundedCard,
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.15),
          width: 1.2,
        ),
        boxShadow: AppSpacing.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      size: 18,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Text(
                    'رحلتك في التعلّم 🚀',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warmGold.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      '$streakDays أيام متتالية',
                      style: AppTypography.labelSmall.copyWith(
                        color: const Color(0xFFC78408),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),

          // Progress Bar and Percent
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أتقنت $completedCount من أصل $totalCount إشارة',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              Text(
                '$percent%',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: AppColors.mainBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),

          // Resume action row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (nextSignToLearn != null)
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'التالي:',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        nextSignToLearn!.arabicWord,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ElevatedButton.icon(
                onPressed: () {
                  if (nextSignToLearn != null) {
                    SignDetailSheet.show(context, nextSignToLearn!);
                  } else {
                    onResume();
                  }
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('كمّل تعلّمك'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
