import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_adaptive_app_bar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../sign_gloss/sign_gloss.dart';
import 'cubit/dictionary_cubit.dart';
import 'cubit/dictionary_state.dart';
import 'widgets/category_chips.dart';
import 'widgets/sign_card.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final query = context.read<DictionaryCubit>().state.searchQuery;
    _searchController.text = query;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DictionaryCubit, DictionaryState>(
      builder: (context, state) {
        final signs = state.filteredSigns;

        return Scaffold(
          backgroundColor: AppColors.mainBackground,
          appBar: AppAdaptiveAppBar(
            titleText: 'قاموس الإشارات',
            actions: [
              AppAdaptiveAppBarAction(
                tooltip: 'قاموس ASL Signbank (Yale)',
                materialIcon: Icons.video_library_rounded,
                cupertinoIcon: CupertinoIcons.film,
                color: AppColors.primaryNavy,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SignGlossScreen(),
                    ),
                  );
                },
              ),
              AppAdaptiveAppBarAction(
                tooltip: state.onlyVideos ? 'عرض الكل' : 'بالفيديو فقط',
                materialIcon: state.onlyVideos
                    ? Icons.videocam_rounded
                    : Icons.videocam_outlined,
                cupertinoIcon: state.onlyVideos
                    ? CupertinoIcons.video_camera_solid
                    : CupertinoIcons.video_camera,
                isActive: state.onlyVideos,
                activeColor: AppColors.emeraldGreen,
                color: AppColors.primaryNavy,
                onPressed: () {
                  context.read<DictionaryCubit>().toggleOnlyVideos();
                },
              ),
              AppAdaptiveAppBarAction(
                tooltip: 'المفضلة فقط',
                materialIcon: state.onlyFavorites
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                cupertinoIcon: state.onlyFavorites
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                isActive: state.onlyFavorites,
                activeColor: AppColors.softCoral,
                color: AppColors.primaryNavy,
                onPressed: () {
                  context.read<DictionaryCubit>().toggleOnlyFavorites();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Input Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.standard,
                  vertical: AppSpacing.compact,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppSpacing.roundedMedium,
                    border: Border.all(color: AppColors.cardBorder, width: 1.2),
                    boxShadow: AppSpacing.softShadow,
                  ),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    style: AppTypography.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن إشارة أو كلمة (مثال: السلام، كتاب)...',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.mutedText,
                      ),
                      prefixIcon: const Icon(
                        LucideIcons.search,
                        color: AppColors.primaryBlue,
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                context.read<DictionaryCubit>().setSearchQuery('');
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (val) {
                      context.read<DictionaryCubit>().setSearchQuery(val);
                      setState(() {});
                    },
                  ),
                ),
              ),

              // Categories Chips
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.compact),
                child: CategoryChips(
                  selectedCategory: state.selectedCategory,
                  onSelected: (cat) {
                    context.read<DictionaryCubit>().setSelectedCategory(cat);
                  },
                ),
              ),

              // Results Count & Status indicator
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.standard,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'عدد الإشارات المتاحة: ${signs.length}',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    if (state.onlyFavorites)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.softCoral.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'المفضلة نشطة',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.softCoral,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Signs List / Grid
              Expanded(
                child: signs.isEmpty
                    ? EmptyStateWidget(
                        icon: LucideIcons.searchX,
                        title: 'لم يتم العثور على إشارات',
                        message: state.onlyFavorites
                            ? 'لم تقم بإضافة أي إشارات للمفضلة بعد.'
                            : 'جرب البحث بكلمة أخرى أو اختر تصنيفاً مختلفاً.',
                        buttonText: state.onlyFavorites ? 'إلغاء تصفية المفضلة' : 'عرض جميع الإشارات',
                        onButtonPressed: () {
                          if (state.onlyFavorites) {
                            context.read<DictionaryCubit>().toggleOnlyFavorites(false);
                          } else {
                            _searchController.clear();
                            context.read<DictionaryCubit>().resetFilters();
                            setState(() {});
                          }
                        },
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.standard,
                          right: AppSpacing.standard,
                          top: AppSpacing.compact,
                          bottom: 90, // Leave room for floating bottom bar
                        ),
                        itemCount: signs.length,
                        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.small),
                        itemBuilder: (context, index) {
                          final sign = signs[index];
                          return SignCard(sign: sign);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
