import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../dictionary/data/signs_data.dart';
import '../../dictionary/presentation/sign_detail_sheet.dart';
import '../domain/entities/situation_entity.dart';

class SituationDetailScreen extends StatelessWidget {
  final SchoolSituationEntity situation;

  const SituationDetailScreen({
    super.key,
    required this.situation,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(situation.colorValue);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: Text(situation.title),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          left: AppSpacing.standard,
          right: AppSpacing.standard,
          top: AppSpacing.compact,
          bottom: 40,
        ),
        physics: const BouncingScrollPhysics(),
        children: [
          // Header Card with Gradient Accent
          Container(
            padding: const EdgeInsets.all(AppSpacing.medium),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeColor,
                  themeColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppSpacing.roundedCard,
              boxShadow: AppSpacing.mediumShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      situation.iconEmoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        situation.title,
                        style: AppTypography.headlineLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        situation.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.92),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.section),

          Text(
            'حوارات وعبارات الموقف',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'انقر على الإشارات المرتبطة لمشاهدة الحركة بالتفصيل',
            style: AppTypography.bodySmall.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: AppSpacing.standard),

          // Dialogue Phrases
          ...situation.phrases.map((phrase) {
            final isStudent = phrase.speaker == 'الطالب';
            final matchedSigns = SignsData.allSigns
                .where((s) => phrase.matchedSignIds.contains(s.id))
                .toList();

            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.medium),
              padding: const EdgeInsets.all(AppSpacing.medium),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSpacing.roundedCard,
                border: Border.all(
                  color: phrase.isUrgent
                      ? AppColors.softCoral.withOpacity(0.5)
                      : AppColors.cardBorder,
                  width: phrase.isUrgent ? 1.5 : 1,
                ),
                boxShadow: AppSpacing.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Speaker Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isStudent
                              ? AppColors.primaryBlue.withOpacity(0.12)
                              : AppColors.emeraldGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          phrase.speaker,
                          style: AppTypography.labelSmall.copyWith(
                            color: isStudent ? AppColors.primaryBlue : AppColors.emeraldGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (phrase.isUrgent)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.softCoral.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'موقف عاجل ⚠️',
                            style: TextStyle(
                              color: AppColors.softCoral,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.small),

                  // Arabic Dialogue Text
                  Text(
                    phrase.arabicText,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),

                  // ESL Sign Instruction
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    decoration: BoxDecoration(
                      color: AppColors.mainBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.accessibility_new_rounded,
                          size: 16,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            phrase.signGuidance,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primaryText,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Matched Signs Links
                  if (matchedSigns.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.compact),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: matchedSigns.map((sign) {
                        return ActionChip(
                          avatar: Text(sign.gestureSymbol, style: const TextStyle(fontSize: 12)),
                          label: Text(
                            'إشارة "${sign.arabicWord}"',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: AppColors.cardBorder),
                          onPressed: () => SignDetailSheet.show(context, sign),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
