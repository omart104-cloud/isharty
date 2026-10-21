import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_adaptive_app_bar.dart';
import '../../../core/widgets/app_center_toast.dart';
import '../../dictionary/presentation/cubit/dictionary_cubit.dart';
import 'cubit/sentence_builder_cubit.dart';
import 'cubit/sentence_builder_state.dart';
import 'widgets/sign_sequence_viewer.dart';

class SentenceBuilderScreen extends StatelessWidget {
  const SentenceBuilderScreen({super.key});

  void _copyText(BuildContext context, String text) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    AppCenterToast.showCopySuccess(
      context,
      message: 'تم نسخ الجملة بنجاح',
    );
  }

  void _saveSentence(BuildContext context) {
    context.read<SentenceBuilderCubit>().saveCurrentSentence();
    AppCenterToast.showSaveSuccess(
      context,
      message: 'تم حفظ الجملة في ملفك الشخصي ⭐',
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableSigns = context.watch<DictionaryCubit>().state.allSigns;

    return BlocBuilder<SentenceBuilderCubit, SentenceBuilderState>(
      builder: (context, state) {
        final selectedSigns = state.selectedSigns;
        final sentenceText = state.sentenceText;

        return Scaffold(
          backgroundColor: AppColors.mainBackground,
          appBar: AppAdaptiveAppBar(
            titleText: 'تركيب جملة بلغة الإشارة',
            actions: selectedSigns.isNotEmpty
                ? [
                    AppAdaptiveAppBarAction(
                      tooltip: 'نسخ النص',
                      materialIcon: LucideIcons.copy,
                      cupertinoIcon: CupertinoIcons.doc_on_doc,
                      color: AppColors.primaryNavy,
                      onPressed: () => _copyText(context, sentenceText),
                    ),
                    AppAdaptiveAppBarAction(
                      tooltip: 'حفظ الجملة',
                      materialIcon: LucideIcons.bookmark,
                      cupertinoIcon: CupertinoIcons.bookmark,
                      color: AppColors.primaryNavy,
                      onPressed: () => _saveSentence(context),
                    ),
                    AppAdaptiveAppBarAction(
                      tooltip: 'مسح الكل',
                      materialIcon: LucideIcons.trash2,
                      cupertinoIcon: CupertinoIcons.trash,
                      color: AppColors.softCoral,
                      onPressed: () =>
                          context.read<SentenceBuilderCubit>().clearSentence(),
                    ),
                  ]
                : null,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: AppSpacing.standard,
              right: AppSpacing.standard,
              top: AppSpacing.compact,
              bottom: 96,
            ),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Educational Clarification Banner
                Container(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.18)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: AppSpacing.compact),
                      Expanded(
                        child: Text(
                          'اختر الكلمات لتكوين الجملة ومشاهدة تسلسل أدائها بلغة الإشارة المصرية المعتمدة.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primaryNavy,
                            fontSize: 11.5,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),

                // Interactive Sentence Tray / Chips Area
                Container(
                  padding: const EdgeInsets.all(AppSpacing.standard),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppSpacing.roundedCard,
                    border: Border.all(
                      color: selectedSigns.isNotEmpty
                          ? AppColors.primaryBlue.withOpacity(0.3)
                          : AppColors.cardBorder,
                      width: 1.5,
                    ),
                    boxShadow: AppSpacing.softShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'شريط تكوين الجملة',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${selectedSigns.length} كلمات',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.small),

                      if (selectedSigns.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                          child: Center(
                            child: Text(
                              'انقر على الكلمات من بنك الكلمات بالأسفل لإضافتها هنا',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.mutedText,
                              ),
                            ),
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedSigns.asMap().entries.map((entry) {
                            final index = entry.key;
                            final sign = entry.value;
                            return Chip(
                              avatar: Text(sign.gestureSymbol, style: const TextStyle(fontSize: 14)),
                              label: Text(
                                sign.arabicWord,
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.primaryNavy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              deleteIcon: const Icon(Icons.close_rounded, size: 16),
                              onDeleted: () => context.read<SentenceBuilderCubit>().removeSignAt(index),
                              backgroundColor: AppColors.mainBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: AppColors.cardBorder),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.standard),

                // Sign Sequence Animated Viewer
                SignSequenceViewer(signs: selectedSigns),

                const SizedBox(height: AppSpacing.section),

                // Word Bank (بنك الكلمات المدرسية المتاحة)
                Text(
                  'بنك الكلمات المعتمدة للإضافة',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primaryNavy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'اضغط على أي كلمة لإضافتها إلى شريط الجملة',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.secondaryText),
                ),
                const SizedBox(height: AppSpacing.compact),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableSigns.map((sign) {
                    return ActionChip(
                      avatar: Text(sign.gestureSymbol),
                      label: Text(sign.arabicWord),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.cardBorder, width: 1.2),
                      ),
                      labelStyle: AppTypography.labelLarge.copyWith(
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.w600,
                      ),
                      onPressed: () => context.read<SentenceBuilderCubit>().addSign(sign),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
