import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../dictionary/data/sign_model.dart';
import '../../dictionary/data/signs_data.dart';
import '../../shared/providers/app_state_provider.dart';
import 'widgets/sign_sequence_viewer.dart';

class SentenceBuilderScreen extends ConsumerStatefulWidget {
  const SentenceBuilderScreen({super.key});

  @override
  ConsumerState<SentenceBuilderScreen> createState() => _SentenceBuilderScreenState();
}

class _SentenceBuilderScreenState extends ConsumerState<SentenceBuilderScreen> {
  final List<SignModel> _selectedSigns = [];
  final TextEditingController _customWordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-populate with a friendly greeting sentence
    _selectedSigns.addAll([
      SignsData.allSigns.firstWhere((s) => s.id == 's_salam'),
      SignsData.allSigns.firstWhere((s) => s.id == 's_moalem'),
      SignsData.allSigns.firstWhere((s) => s.id == 's_shokran'),
    ]);
  }

  @override
  void dispose() {
    _customWordController.dispose();
    super.dispose();
  }

  void _addSign(SignModel sign) {
    setState(() {
      _selectedSigns.add(sign);
    });
  }

  void _removeSignAt(int index) {
    setState(() {
      _selectedSigns.removeAt(index);
    });
  }

  void _clearSentence() {
    setState(() {
      _selectedSigns.clear();
    });
  }

  String get _currentSentenceString =>
      _selectedSigns.map((s) => s.arabicWord).join(' ');

  void _copyText() {
    if (_selectedSigns.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _currentSentenceString));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ الجملة: "$_currentSentenceString"'),
        backgroundColor: AppColors.emeraldGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveSentence() {
    if (_selectedSigns.isEmpty) return;
    final ids = _selectedSigns.map((s) => s.id).toList();
    ref.read(appStateProvider.notifier).saveSentence(_currentSentenceString, ids);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ الجملة بنجاح في ملفك الشخصي ⭐'),
        backgroundColor: AppColors.primaryBlue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const availableSigns = SignsData.allSigns;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('تركيب جملة بلغة الإشارة'),
        actions: [
          if (_selectedSigns.isNotEmpty) ...[
            IconButton(
              tooltip: 'نسخ النص',
              icon: const Icon(LucideIcons.copy, color: AppColors.primaryNavy),
              onPressed: _copyText,
            ),
            IconButton(
              tooltip: 'حفظ الجملة',
              icon: const Icon(LucideIcons.bookmark, color: AppColors.primaryNavy),
              onPressed: _saveSentence,
            ),
            IconButton(
              tooltip: 'مسح الكل',
              icon: const Icon(LucideIcons.trash2, color: AppColors.softCoral),
              onPressed: _clearSentence,
            ),
          ],
          const SizedBox(width: 8),
        ],
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
                  color: _selectedSigns.isNotEmpty
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
                        '${_selectedSigns.length} كلمات',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.small),

                  if (_selectedSigns.isEmpty)
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
                      children: _selectedSigns.asMap().entries.map((entry) {
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
                          onDeleted: () => _removeSignAt(index),
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
            SignSequenceViewer(signs: _selectedSigns),

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
                  onPressed: () => _addSign(sign),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
