import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'cubit/situations_cubit.dart';
import 'cubit/situations_state.dart';
import 'situation_detail_screen.dart';

class SituationsScreen extends StatelessWidget {
  const SituationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SituationsCubit, SituationsState>(
      builder: (context, state) {
        final situations = state.situations;

        return Scaffold(
          backgroundColor: AppColors.mainBackground,
          appBar: AppBar(
            title: const Text('مواقف المدرسة'),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.only(
              left: AppSpacing.standard,
              right: AppSpacing.standard,
              top: AppSpacing.compact,
              bottom: 96,
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: situations.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.small),
            itemBuilder: (context, index) {
              final situation = situations[index];
              final color = Color(situation.colorValue);

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SituationDetailScreen(situation: situation),
                    ),
                  );
                },
                borderRadius: AppSpacing.roundedCard,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppSpacing.roundedCard,
                    border: Border.all(color: AppColors.cardBorder, width: 1.2),
                    boxShadow: AppSpacing.softShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: color.withOpacity(0.2)),
                        ),
                        child: Center(
                          child: Text(
                            situation.iconEmoji,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    situation.title,
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.primaryNavy,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${situation.phrasesCount} عبارات',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              situation.description,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.secondaryText,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.compact),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.mutedText,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
