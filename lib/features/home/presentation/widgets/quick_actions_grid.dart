import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class QuickActionItem {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const QuickActionItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });
}

class QuickActionsGrid extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;

  const QuickActionsGrid({
    super.key,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      QuickActionItem(
        title: 'ابحث عن كلمة',
        description: 'البحث الفوري عن أي إشارة وممارستها',
        icon: LucideIcons.search,
        accentColor: AppColors.primaryBlue,
        onTap: () => onNavigateTab(1), // Dictionary
      ),
      QuickActionItem(
        title: 'اكتب جملة',
        description: 'تكوين جملة وعرض تسلسل إشاراتها',
        icon: LucideIcons.messageCircle,
        accentColor: AppColors.emeraldGreen,
        onTap: () => onNavigateTab(2), // Sentence builder
      ),
      QuickActionItem(
        title: 'مواقف المدرسة',
        description: 'حوارات الفصل، الإدارة والعيادة المدرسية',
        icon: LucideIcons.school,
        accentColor: const Color(0xFFE5A429), // Warm gold
        onTap: () => onNavigateTab(3), // Situations
      ),
      QuickActionItem(
        title: 'قاموس الإشارات',
        description: 'استكشاف جميع التصنيفات المعتمدة',
        icon: LucideIcons.bookOpen,
        accentColor: AppColors.softLavender,
        onTap: () => onNavigateTab(1), // Dictionary
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.standard),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive 2-column or 1-column layout
          final isNarrow = constraints.maxWidth < 320;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isNarrow ? 1 : 2,
              crossAxisSpacing: AppSpacing.small,
              mainAxisSpacing: AppSpacing.small,
              childAspectRatio: isNarrow ? 2.8 : 1.35,
            ),
            itemBuilder: (context, index) {
              return _QuickActionCard(item: actions[index]);
            },
          );
        },
      ),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final QuickActionItem item;

  const _QuickActionCard({required this.item});

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSpacing.roundedCard,
          border: Border.all(
            color: item.accentColor.withOpacity(0.18),
            width: 1.2,
          ),
          boxShadow: AppSpacing.softShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: item.onTap,
            borderRadius: AppSpacing.roundedCard,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.small),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: item.accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.icon,
                          size: 19,
                          color: item.accentColor,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: item.accentColor.withOpacity(0.6),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryNavy,
                          fontSize: 13.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10.5,
                          color: AppColors.secondaryText,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
