import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/empty_state.dart';
import '../../shared/providers/app_state_provider.dart';
import 'widgets/category_chips.dart';
import 'widgets/sign_card.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _onlyFavorites = false;

  @override
  void initState() {
    super.initState();
    final query = ref.read(appStateProvider).searchQuery;
    _searchController.text = query;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    var signs = ref.watch(filteredSignsProvider);

    if (_onlyFavorites) {
      signs = signs.where((s) => appState.favoriteSignIds.contains(s.id)).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('قاموس الإشارات'),
        actions: [
          IconButton(
            tooltip: 'المفضلة فقط',
            icon: Icon(
              _onlyFavorites ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _onlyFavorites ? AppColors.softCoral : AppColors.primaryNavy,
            ),
            onPressed: () {
              setState(() => _onlyFavorites = !_onlyFavorites);
            },
          ),
          const SizedBox(width: 8),
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
                            ref.read(appStateProvider.notifier).setSearchQuery('');
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
                  ref.read(appStateProvider.notifier).setSearchQuery(val);
                  setState(() {});
                },
              ),
            ),
          ),

          // Categories Chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.compact),
            child: CategoryChips(
              selectedCategory: appState.selectedCategory,
              onSelected: (cat) {
                ref.read(appStateProvider.notifier).setSelectedCategory(cat);
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
                if (_onlyFavorites)
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
                    message: _onlyFavorites
                        ? 'لم تقم بإضافة أي إشارات للمفضلة بعد.'
                        : 'جرب البحث بكلمة أخرى أو اختر تصنيفاً مختلفاً.',
                    buttonText: _onlyFavorites ? 'إلغاء تصفية المفضلة' : 'عرض جميع الإشارات',
                    onButtonPressed: () {
                      if (_onlyFavorites) {
                        setState(() => _onlyFavorites = false);
                      } else {
                        _searchController.clear();
                        ref.read(appStateProvider.notifier).setSearchQuery('');
                        ref.read(appStateProvider.notifier).setSelectedCategory('الكل');
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
  }
}
