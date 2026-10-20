import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../app_navigation/presentation/cubit/app_preferences_cubit.dart';
import '../../app_navigation/presentation/cubit/app_preferences_state.dart';
import '../../dictionary/presentation/cubit/dictionary_cubit.dart';
import '../../dictionary/presentation/cubit/dictionary_state.dart';
import '../../dictionary/presentation/sign_detail_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('تعديل اسم الطالب'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'الاسم',
            hintText: 'اكتب اسمك هنا',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<AppPreferencesCubit>().updateStudentName(controller.text.trim());
              }
              Navigator.pop(dialogCtx);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.navyToBlueGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('🤟', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 8),
            const Text('عن تطبيق إشارتي معاك'),
          ],
        ),
        content: Column(
          mainAxisSize: minAxisSize(),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تطبيق تعليمي ومساعد تواصل حديث ومبتكر مخصص لطلاب الصم وضعاف السمع في المدارس المصرية، صُمم لمساعدتهم في التفاعل السلس واليومي مع المعلمين، الإدارة والزملاء بلغة الإشارة المصرية المعتمدة (ESL).',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'الإصدار: 2026.1 (نسخة تجريبية متطورة)',
              style: AppTypography.bodySmall.copyWith(color: AppColors.mutedText),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  static MainAxisSize minAxisSize() => MainAxisSize.min;

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سياسة الخصوصية'),
        content: Text(
          'تطبيق "إشارتي معاك" يحترم خصوصية الطلاب والمعلمين تماماً. جميع البيانات والإشارات المحفوظة والتقدم التعليمي تُحفظ محلياً على جهازك ولا تتم مشاركتها مع أي جهات خارجية.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسنًا'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
      builder: (context, prefsState) {
        return BlocBuilder<DictionaryCubit, DictionaryState>(
          builder: (context, dictState) {
            final favSigns = dictState.favoriteSigns;
            final totalSignsCount = dictState.totalCount;
            final completedCount = dictState.completedCount;
            final progressRatio = totalSignsCount > 0 ? (completedCount / totalSignsCount) : 0.0;

            return Scaffold(
              backgroundColor: AppColors.mainBackground,
              appBar: AppBar(
                title: const Text('حسابي والإعدادات'),
              ),
              body: ListView(
                padding: const EdgeInsets.only(
                  left: AppSpacing.standard,
                  right: AppSpacing.standard,
                  top: AppSpacing.compact,
                  bottom: 96,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Profile Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppSpacing.roundedCard,
                      border: Border.all(color: AppColors.cardBorder, width: 1.2),
                      boxShadow: AppSpacing.softShadow,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.blueToCyanGradient,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: AppSpacing.softShadow,
                                  ),
                                  child: Center(
                                    child: Text(
                                      prefsState.studentName.isNotEmpty ? prefsState.studentName[0] : 'أ',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: AppColors.emeraldGreen,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: AppSpacing.medium),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        prefsState.studentName,
                                        style: AppTypography.headlineMedium.copyWith(
                                          color: AppColors.primaryNavy,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(LucideIcons.edit2, size: 16, color: AppColors.primaryBlue),
                                        onPressed: () => _showEditNameDialog(context, prefsState.studentName),
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'طالب - مدرسة الأمل للصم وضعاف السمع',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        const Divider(color: AppColors.cardBorder, height: 1),
                        const SizedBox(height: AppSpacing.medium),

                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              label: 'إشارة مكتملة',
                              value: '$completedCount / $totalSignsCount',
                              color: AppColors.primaryBlue,
                            ),
                            _buildStatDivider(),
                            _buildStatItem(
                              label: 'إشارات مفضلة',
                              value: '${dictState.favoriteSignIds.length}',
                              color: AppColors.softCoral,
                            ),
                            _buildStatDivider(),
                            _buildStatItem(
                              label: 'أيام التدريب',
                              value: '${prefsState.streakDays} أيام 🔥',
                              color: AppColors.warmGold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),

                  // Learning Progress Section
                  Container(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نسبة إنجاز قاموس الإشارات',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                            Text(
                              '${(progressRatio * 100).toInt()}%',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.small),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progressRatio,
                            minHeight: 10,
                            backgroundColor: AppColors.mainBackground,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.section),

                  // Favorite Signs Preview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إشاراتك المفضلة ⭐',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${favSigns.length} إشارة',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.compact),
                  if (favSigns.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.medium),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppSpacing.roundedCard,
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: const Center(
                        child: Text('لم تقم بإضافة أي إشارات للمفضلة بعد.'),
                      ),
                    )
                  else
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: favSigns.length,
                        itemBuilder: (context, index) {
                          final sign = favSigns[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ActionChip(
                              avatar: Text(sign.gestureSymbol),
                              label: Text(sign.arabicWord),
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: AppColors.cardBorder),
                              onPressed: () => SignDetailSheet.show(context, sign),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: AppSpacing.section),

                  // Accessibility Settings
                  Text(
                    'إمكانية الوصول وسهولة الاستخدام',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.compact),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppSpacing.roundedCard,
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: AppSpacing.softShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: AppSpacing.roundedCard,
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text(
                              'التباين العالي للألوان',
                              style: AppTypography.titleMedium.copyWith(fontSize: 14.5),
                            ),
                            subtitle: const Text('تعزيز وضوح النصوص والرموز للمساعدة البصرية'),
                            value: prefsState.highContrast,
                            activeColor: AppColors.primaryBlue,
                            onChanged: (val) {
                              context.read<AppPreferencesCubit>().toggleHighContrast(val);
                            },
                          ),
                          const Divider(color: AppColors.cardBorder, height: 1),
                          SwitchListTile(
                            title: Text(
                              'تقليل الحركة والمؤثرات',
                              style: AppTypography.titleMedium.copyWith(fontSize: 14.5),
                            ),
                            subtitle: const Text('إيقاف الحركات الممتدة لتوفير البطارية والراحة'),
                            value: prefsState.reduceMotion,
                            activeColor: AppColors.primaryBlue,
                            onChanged: (val) {
                              context.read<AppPreferencesCubit>().toggleReduceMotion(val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.section),

                  // General App Info
                  Text(
                    'عن التطبيق والدعم',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.compact),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppSpacing.roundedCard,
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: AppSpacing.softShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: AppSpacing.roundedCard,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(LucideIcons.info, color: AppColors.primaryNavy),
                            title: const Text('عن تطبيق إشارتي معاك'),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            onTap: () => _showAboutDialog(context),
                          ),
                          const Divider(color: AppColors.cardBorder, height: 1),
                          ListTile(
                            leading: const Icon(LucideIcons.shieldCheck, color: AppColors.primaryNavy),
                            title: const Text('سياسة الخصوصية والأمان'),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            onTap: () => _showPrivacyDialog(context),
                          ),
                          const Divider(color: AppColors.cardBorder, height: 1),
                          ListTile(
                            leading: const Icon(LucideIcons.messageSquare, color: AppColors.primaryNavy),
                            title: const Text('الدعم الفني وملاحظات المدارس'),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('يمكنك إرسال مقترحاتك عبر البريد: support@isharaty.edu.eg'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 11,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.cardBorder,
    );
  }
}
