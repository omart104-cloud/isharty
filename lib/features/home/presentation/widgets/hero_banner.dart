import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';

class HeroBanner extends StatelessWidget {
  final VoidCallback onStartLearning;
  final VoidCallback onExploreDictionary;

  const HeroBanner({
    super.key,
    required this.onStartLearning,
    required this.onExploreDictionary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.standard),
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        gradient: AppColors.heroCardGradient,
        borderRadius: AppSpacing.roundedCard,
        boxShadow: AppSpacing.mediumShadow,
      ),
      child: Stack(
        children: [
          // Background abstract luminous shapes
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyanAccent.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🇪🇬', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'لغة الإشارة المصرية المعتمدة',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.small),

              // Headline & Visual Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'خلّي التواصل أسهل ✨',
                          style: AppTypography.displayMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'اتعلّم لغة الإشارة المصرية وعبّر عن نفسك في الفصل والمدرسة بثقة كاملة.',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            height: 1.45,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),

                  // Floating 3D Hand Gestures Badge
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryNavy.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '🤝',
                        style: TextStyle(fontSize: 34),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: 'ابدأ التعلّم',
                      icon: Icons.play_arrow_rounded,
                      isSmall: true,
                      onPressed: onStartLearning,
                      backgroundColor: Colors.white,
                      textColor: AppColors.primaryNavy,
                      gradient: const LinearGradient(
                        colors: [Colors.white, Color(0xFFF0F4FF)],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.compact),
                  Expanded(
                    child: PrimaryButton(
                      text: 'اكتشف القاموس',
                      isSecondary: true,
                      isSmall: true,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      textColor: Colors.white,
                      onPressed: onExploreDictionary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
