import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppHeader extends StatelessWidget {
  final String? studentName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const AppHeader({
    super.key,
    this.studentName,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.standard,
        vertical: AppSpacing.small,
      ),
      child: Row(
        children: [
          // Hand Sign / App Logo Icon Badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.navyToBlueGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryNavy.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '🤟',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.small),

          // Titles & Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'إشارتي معاك',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'مدرستي',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.emeraldGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'أهلًا ${studentName ?? "أحمد"} 👋 • التواصل أسهل لما نفهم بعض',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                    fontSize: 11.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Notification Button with Badge
          InkWell(
            onTap: onNotificationTap ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('لا توجد إشعارات جديدة حالياً'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder, width: 1.2),
                boxShadow: AppSpacing.softShadow,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    LucideIcons.bell,
                    size: 19,
                    color: AppColors.primaryNavy,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.softCoral,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.compact),

          // User Avatar Button
          InkWell(
            onTap: onAvatarTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: AppColors.blueToCyanGradient,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: AppSpacing.softShadow,
              ),
              child: const Center(
                child: Text(
                  'أ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
