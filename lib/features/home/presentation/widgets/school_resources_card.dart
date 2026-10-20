import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class SchoolResourcesCard extends StatelessWidget {
  const SchoolResourcesCard({super.key});

  void _openQuizDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _SignQuizDialog(),
    );
  }

  void _openContactsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(LucideIcons.phoneCall, color: AppColors.primaryBlue),
            SizedBox(width: 8),
            Text('أرقام التواصل المدرسي'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _contactItem('إدارة مدرسة الأمل', '02-23456789', 'متاح أثناء الطابور والحصص'),
            const Divider(height: 16),
            _contactItem('الأخصائي الاجتماعي', '02-23456790', 'للدعم النفسي والتوجيه'),
            const Divider(height: 16),
            _contactItem('العيادة المدرسية', '02-23456791', 'للطوارئ والإسعافات الأولية'),
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

  static Widget _contactItem(String title, String phone, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.call_rounded, color: AppColors.primaryBlue, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.secondaryText, fontSize: 11),
              ),
            ],
          ),
        ),
        Text(
          phone,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryNavy,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _openFaqDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الأسئلة الشائعة حول لغة الإشارة'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _faqItem(
                'ما هي لغة الإشارة المصرية (ESL)؟',
                'هي اللغة البصرية الطبيعية المعتمدة في جمهورية مصر العربية للتواصل بين مجتمع الصم وضعاف السمع، ولها مفرداتها وقواعدها الخاصة.',
              ),
              const SizedBox(height: 12),
              _faqItem(
                'هل الإشارات موحدة في جميع المدارس؟',
                'نعم، تعتمد الوزارة القاموس الإشاري الموحد لمدارس الأمل لتسهيل تواصل الطلاب والكوادر التعليمية.',
              ),
              const SizedBox(height: 12),
              _faqItem(
                'كيف يساعدني هذا التطبيق في الفصل؟',
                'يوفر مرجعاً فورياً بالرسوم التوضيحية والخطوات، ويساعد في تكوين الجمل السريعة أثناء التعامل مع المعلمين.',
              ),
            ],
          ),
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

  static Widget _faqItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryNavy),
        ),
        const SizedBox(height: 4),
        Text(
          answer,
          style: const TextStyle(color: AppColors.primaryText, fontSize: 12.5, height: 1.4),
        ),
      ],
    );
  }

  void _openGuidelinesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إرشادات وتعليمات مدرسية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _guideBullet('الالتزام بالتواصل البصري المباشر عند التحدث بلغة الإشارة.'),
            _guideBullet('استخدام تعبيرات الوجه المصاحبة لتوضيح نبرة الحديث والمشاعر.'),
            _guideBullet('طلب إعادة الشرح فوراً عند عدم وضوح أي نقطة بالدرس.'),
            _guideBullet('إبلاغ المشرف فوراً عبر إشارة المساعدة في حالات التعب أو الطوارئ.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت ذلك'),
          ),
        ],
      ),
    );
  }

  static Widget _guideBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primaryBlue, fontSize: 16)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12.5, height: 1.35)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resources = [
      _ResourceButtonData(
        title: 'الاختبارات والتمارين',
        subtitle: 'اختبر حصيلتك الإشارية',
        icon: LucideIcons.award,
        color: AppColors.primaryBlue,
        onTap: () => _openQuizDialog(context),
      ),
      _ResourceButtonData(
        title: 'أرقام التواصل',
        subtitle: 'الإدارة، العيادة والأخصائي',
        icon: LucideIcons.phone,
        color: AppColors.emeraldGreen,
        onTap: () => _openContactsDialog(context),
      ),
      _ResourceButtonData(
        title: 'الأسئلة الشائعة',
        subtitle: 'إجابات حول لغة الإشارة',
        icon: LucideIcons.helpCircle,
        color: const Color(0xFFE5A429),
        onTap: () => _openFaqDialog(context),
      ),
      _ResourceButtonData(
        title: 'الإرشادات المدرسية',
        subtitle: 'تعليمات الفصل والتواصل',
        icon: LucideIcons.fileText,
        color: AppColors.softLavender,
        onTap: () => _openGuidelinesDialog(context),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.standard),
      child: Column(
        children: resources.map((r) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.compact),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: AppSpacing.softShadow,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: ListTile(
                onTap: r.onTap,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: r.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(r.icon, color: r.color, size: 19),
                ),
                title: Text(
                  r.title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: AppColors.primaryNavy,
                  ),
                ),
                subtitle: Text(
                  r.subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.secondaryText,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: AppColors.mutedText,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ResourceButtonData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ResourceButtonData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _SignQuizDialog extends StatefulWidget {
  const _SignQuizDialog();

  @override
  State<_SignQuizDialog> createState() => _SignQuizDialogState();
}

class _SignQuizDialogState extends State<_SignQuizDialog> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedOption;

  final questions = [
    {
      'question': 'ما هي الحركة المناسبة لإشارة "السلام عليكم"؟',
      'options': [
        'رفع كف اليد بمستوى الجبين وتحريكه للأمام بانسيابية',
        'التصفيق المزدوج بكفي اليدين',
        'هز السبابة يميناً ويساراً',
        'وضع اليد على البطن',
      ],
      'correct': 0,
      'symbol': '👋',
    },
    {
      'question': 'أي إشارة تستخدم للتعبير عن الذهاب إلى العيادة المدرسية؟',
      'options': [
        'فتح كفي اليدين ككتاب',
        'فحص النبض على معصم اليد وإشارة الصليب الطبي',
        'تحريك اليدين كسيارة',
        'مسح الصدر للأعلى',
      ],
      'correct': 1,
      'symbol': '🏥',
    },
    {
      'question': 'كيف تؤدي إشارة "شكرًا" في لغة الإشارة المصرية؟',
      'options': [
        'وضع أطراف الأصابع عند الذقن/الشفاه ثم مد اليد للأمام',
        'إغلاق العينين',
        'وضع قبضة اليد خلف الرأس',
        'رفع الإبهام لأعلى فقط',
      ],
      'correct': 0,
      'symbol': '🙏',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final q = questions[_currentQuestionIndex];
    final options = q['options'] as List<String>;
    final correctIndex = q['correct'] as int;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'اختبار سريع (${_currentQuestionIndex + 1}/${questions.length})',
            style: const TextStyle(fontSize: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.warmGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'النقاط: $_score',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFFC78408),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                q['symbol'] as String,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              q['question'] as String,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 14),
            ...options.asMap().entries.map((entry) {
              final idx = entry.key;
              final opt = entry.value;

              Color? bgColor;
              if (_answered) {
                if (idx == correctIndex) {
                  bgColor = AppColors.emeraldGreen.withOpacity(0.15);
                } else if (idx == _selectedOption) {
                  bgColor = AppColors.softCoral.withOpacity(0.15);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: _answered
                      ? null
                      : () {
                          setState(() {
                            _answered = true;
                            _selectedOption = idx;
                            if (idx == correctIndex) {
                              _score++;
                            }
                          });
                        },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bgColor ?? AppColors.mainBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _answered && idx == correctIndex
                            ? AppColors.emeraldGreen
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: _answered && idx == correctIndex
                              ? AppColors.emeraldGreen
                              : AppColors.primaryBlue.withOpacity(0.2),
                          child: Text(
                            '${idx + 1}',
                            style: TextStyle(
                              fontSize: 10,
                              color: _answered && idx == correctIndex
                                  ? Colors.white
                                  : AppColors.primaryNavy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(opt, style: const TextStyle(fontSize: 12.5)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        if (_answered)
          ElevatedButton(
            onPressed: () {
              if (_currentQuestionIndex < questions.length - 1) {
                setState(() {
                  _currentQuestionIndex++;
                  _answered = false;
                  _selectedOption = null;
                });
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('أحسنت! نتيجتك النهائية هي $_score من ${questions.length} 🎉'),
                    backgroundColor: AppColors.emeraldGreen,
                  ),
                );
              }
            },
            child: Text(
              _currentQuestionIndex < questions.length - 1 ? 'السؤال التالي' : 'إنهاء الاختبار',
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
      ],
    );
  }
}
