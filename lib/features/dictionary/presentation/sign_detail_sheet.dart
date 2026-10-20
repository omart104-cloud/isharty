import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../sign_gloss/sign_gloss.dart';
import 'cubit/dictionary_cubit.dart';
import '../data/sign_model.dart';
import '../data/signs_data.dart';

class SignDetailSheet extends StatefulWidget {
  final SignModel sign;

  const SignDetailSheet({
    super.key,
    required this.sign,
  });

  static Future<void> show(BuildContext context, SignModel sign) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SignDetailSheet(sign: sign),
    );
  }

  @override
  State<SignDetailSheet> createState() => _SignDetailSheetState();
}

class _SignDetailSheetState extends State<SignDetailSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _waveAnimation;
  bool _isPlaying = true;
  late int _viewModeIndex;

  @override
  void initState() {
    super.initState();
    _viewModeIndex = widget.sign.hasVideo ? 0 : 1;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic),
    );

    _waveAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _animController.repeat(reverse: true);
      } else {
        _animController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<DictionaryCubit, bool>(
      (c) => c.state.favoriteSignIds.contains(widget.sign.id),
    );
    final isCompleted = context.select<DictionaryCubit, bool>(
      (c) => c.state.completedSignIds.contains(widget.sign.id),
    );

    // Look up related signs
    final relatedSigns = SignsData.allSigns
        .where((s) => widget.sign.relatedSignIds.contains(s.id))
        .toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: AppSpacing.small),
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.compact),

          // Header with Title & Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.standard),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.primaryNavy),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.sign.arabicWord,
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.primaryNavy,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'تصنيف: ${widget.sign.category}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Favorite Toggle
                    IconButton(
                      onPressed: () {
                        context.read<DictionaryCubit>().toggleFavorite(widget.sign.id);
                      },
                      icon: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? AppColors.softCoral : AppColors.secondaryText,
                      ),
                    ),
                    // Completion Toggle
                    IconButton(
                      onPressed: () {
                        context.read<DictionaryCubit>().toggleCompleted(widget.sign.id);
                      },
                      icon: Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.check_circle_outline_rounded,
                        color: isCompleted ? AppColors.emeraldGreen : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.cardBorder, height: 1),

          // Scrollable Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.standard),
              children: [
                // Visual Mode Switcher (Video vs Gesture Animation)
                if (widget.sign.hasVideo) ...[
                  _buildViewModeSwitcher(),
                  const SizedBox(height: AppSpacing.standard),
                ],

                // Video Player or Animated Gesture Visualization Area
                if (_viewModeIndex == 0 && widget.sign.hasVideo)
                  _buildVideoSection()
                else
                  _buildGestureAnimation(),

                const SizedBox(height: AppSpacing.standard),

                // Movement Description Box
                Container(
                  padding: const EdgeInsets.all(AppSpacing.standard),
                  decoration: BoxDecoration(
                    color: AppColors.mainBackground,
                    borderRadius: AppSpacing.roundedMedium,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'الوصف الحركي المعتمد للإشارة',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.sign.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primaryText,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.standard),

                // Step-by-Step Instructions
                Text(
                  'خطوات أداء الإشارة بالتفصيل',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: AppSpacing.compact),
                ...widget.sign.movementSteps.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final step = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.compact),
                    padding: const EdgeInsets.all(AppSpacing.small),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primaryBlue,
                          child: Text(
                            '$index',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.compact),
                        Expanded(
                          child: Text(
                            step,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.standard),

                // Educational Usage Note
                Container(
                  padding: const EdgeInsets.all(AppSpacing.standard),
                  decoration: BoxDecoration(
                    color: AppColors.warmGold.withOpacity(0.08),
                    borderRadius: AppSpacing.roundedMedium,
                    border: Border.all(color: AppColors.warmGold.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Color(0xFFC78408),
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.compact),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'متى وكيف تستخدمها؟',
                              style: AppTypography.titleMedium.copyWith(
                                color: const Color(0xFF946200),
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.sign.usageNote,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primaryText,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.standard),

                // Related Signs
                if (relatedSigns.isNotEmpty) ...[
                  Text(
                    'إشارات مرتبطة هامة',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.compact),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: relatedSigns.map((rel) {
                      return ActionChip(
                        avatar: Text(rel.gestureSymbol),
                        label: Text(rel.arabicWord),
                        backgroundColor: AppColors.surfaceWhite,
                        side: const BorderSide(color: AppColors.cardBorder),
                        labelStyle: AppTypography.labelLarge.copyWith(
                          color: AppColors.primaryNavy,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          SignDetailSheet.show(context, rel);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.large),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.mainBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _viewModeIndex = 0),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _viewModeIndex == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _viewModeIndex == 0
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_fill_rounded,
                      size: 18,
                      color: _viewModeIndex == 0 ? AppColors.primaryNavy : AppColors.secondaryText,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'فيديو الإشارة',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _viewModeIndex == 0 ? FontWeight.bold : FontWeight.w500,
                        color: _viewModeIndex == 0 ? AppColors.primaryNavy : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _viewModeIndex = 1),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _viewModeIndex == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _viewModeIndex == 1
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.gesture_rounded,
                      size: 18,
                      color: _viewModeIndex == 1 ? AppColors.primaryNavy : AppColors.secondaryText,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'الحركة التوضيحية',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _viewModeIndex == 1 ? FontWeight.bold : FontWeight.w500,
                        color: _viewModeIndex == 1 ? AppColors.primaryNavy : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: SignGlossVideoPlayer(
            videoUrl: widget.sign.videoUrl!,
            glossTitle: widget.sign.arabicWord,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.mainBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.emeraldGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: AppColors.emeraldGreen,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'فيديو معتمد من Yale ASL Signbank',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    if (widget.sign.glossEnglish != null)
                      Text(
                        'Annotation: ${widget.sign.glossEnglish} • Gloss #${widget.sign.signbankGlossId ?? ""}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.sign.signbankGlossId != null)
                FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SignGlossScreen(
                          initialGlossId: widget.sign.signbankGlossId!,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('تفاصيل', style: TextStyle(fontSize: 11)),
                      SizedBox(width: 2),
                      Icon(Icons.arrow_forward_ios_rounded, size: 10),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGestureAnimation() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: AppColors.heroCardGradient,
        borderRadius: AppSpacing.roundedCard,
        boxShadow: AppSpacing.softShadow,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background rings
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Container(
                width: 140 * _scaleAnimation.value,
                height: 140 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cyanAccent.withOpacity(0.25),
                    width: 2,
                  ),
                ),
              );
            },
          ),
          // Animated Gesture Hand
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_waveAnimation.value, 0),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyanAccent.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.sign.gestureSymbol,
                        style: const TextStyle(fontSize: 44),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // ESL Tag Badge
          Positioned(
            top: AppSpacing.small,
            right: AppSpacing.small,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Text(
                'لغة الإشارة المصرية ESL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Animation Control (Play / Pause)
          Positioned(
            bottom: AppSpacing.small,
            left: AppSpacing.small,
            child: InkWell(
              onTap: _togglePlay,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isPlaying ? 'إيقاف مؤقت' : 'تشغيل الحركة',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
