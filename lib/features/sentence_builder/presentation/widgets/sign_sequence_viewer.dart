import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../dictionary/data/sign_model.dart';
import '../../../dictionary/presentation/sign_detail_sheet.dart';

class SignSequenceViewer extends StatefulWidget {
  final List<SignModel> signs;

  const SignSequenceViewer({
    super.key,
    required this.signs,
  });

  @override
  State<SignSequenceViewer> createState() => _SignSequenceViewerState();
}

class _SignSequenceViewerState extends State<SignSequenceViewer> {
  int _activeStepIndex = 0;
  bool _isPlayingSequence = false;

  @override
  void didUpdateWidget(covariant SignSequenceViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.signs.isEmpty) {
      _activeStepIndex = 0;
      _isPlayingSequence = false;
    } else if (_activeStepIndex >= widget.signs.length) {
      _activeStepIndex = widget.signs.length - 1;
    }
  }

  void _nextStep() {
    if (_activeStepIndex < widget.signs.length - 1) {
      setState(() => _activeStepIndex++);
    }
  }

  void _prevStep() {
    if (_activeStepIndex > 0) {
      setState(() => _activeStepIndex--);
    }
  }

  Future<void> _playFullSequence() async {
    if (widget.signs.isEmpty) return;
    setState(() {
      _isPlayingSequence = true;
      _activeStepIndex = 0;
    });

    for (int i = 0; i < widget.signs.length; i++) {
      if (!mounted || !_isPlayingSequence || i >= widget.signs.length) break;
      setState(() => _activeStepIndex = i);
      await Future.delayed(const Duration(milliseconds: 1400));
    }

    if (mounted) {
      setState(() => _isPlayingSequence = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.signs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.large),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSpacing.roundedCard,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            const Icon(Icons.touch_app_rounded, size: 36, color: AppColors.mutedText),
            const SizedBox(height: AppSpacing.compact),
            Text(
              'أضف كلمات من القاموس لعرض تسلسل الإشارات',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final safeIndex = _activeStepIndex.clamp(0, widget.signs.length - 1);
    if (safeIndex != _activeStepIndex) {
      _activeStepIndex = safeIndex;
    }
    final activeSign = widget.signs[safeIndex];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSpacing.roundedCard,
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppSpacing.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Counter & Play All Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'الإشارة ${safeIndex + 1} من ${widget.signs.length}',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _isPlayingSequence ? null : _playFullSequence,
                icon: Icon(
                  _isPlayingSequence ? Icons.hourglass_top_rounded : Icons.play_arrow_rounded,
                  size: 18,
                ),
                label: Text(_isPlayingSequence ? 'جارٍ العرض...' : 'تشغيل التسلسل'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),

          // Main Display Card for the Active Sign in Sequence
          Container(
            padding: const EdgeInsets.all(AppSpacing.standard),
            decoration: BoxDecoration(
              gradient: AppColors.heroCardGradient,
              borderRadius: AppSpacing.roundedCard,
              boxShadow: AppSpacing.mediumShadow,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activeSign.arabicWord,
                      style: AppTypography.headlineLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        activeSign.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.medium),

                // Center visual
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyanAccent.withOpacity(0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      activeSign.gestureSymbol,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),

                Text(
                  activeSign.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.92),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.small),

                TextButton.icon(
                  onPressed: () => SignDetailSheet.show(context, activeSign),
                  icon: const Icon(Icons.visibility_rounded, size: 16, color: AppColors.cyanAccent),
                  label: const Text(
                    'تفاصيل الخطوات واليد',
                    style: TextStyle(
                      color: AppColors.cyanAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),

          // Stepper Controls
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: safeIndex > 0 ? _prevStep : null,
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const FittedBox(fit: BoxFit.scaleDown, child: Text('الإشارة السابقة')),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.compact),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: safeIndex < widget.signs.length - 1 ? _nextStep : null,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const FittedBox(fit: BoxFit.scaleDown, child: Text('الإشارة التالية')),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),

          // Bottom Timeline of Signs
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.signs.length,
              itemBuilder: (context, index) {
                final s = widget.signs[index];
                final isSelected = index == safeIndex;
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap: () => setState(() => _activeStepIndex = index),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryBlue : AppColors.mainBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryBlue : AppColors.cardBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(s.gestureSymbol, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            s.arabicWord,
                            style: AppTypography.labelSmall.copyWith(
                              color: isSelected ? Colors.white : AppColors.primaryNavy,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
