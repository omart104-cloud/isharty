import 'situation_model.dart';

class SituationsData {
  static const List<SchoolSituationModel> allSituations = [
    SchoolSituationModel(
      id: 'sit_fasl',
      title: 'داخل الفصل الدراسي',
      description: 'عبارات وحوارات يومية أثناء الحصة والشرح والمشاركة التفاعلية.',
      iconEmoji: '🏫',
      colorValue: 0xFF2675E8, // Primary Blue
      phrases: [
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'من فضلك يا أستاذ، هل يمكن إعادة الشرح ببطء؟',
          signGuidance: 'إشارة "من فضلك" + إشارة "المعلم" + حركة اليدين معاً للدلالة على الإعادة والتكرار بتؤدة.',
          matchedSignIds: ['s_men_fadlak', 's_moalem'],
        ),
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'هل يمكنني الإجابة على السؤال؟',
          signGuidance: 'رفع اليد اليمنى كفاً مفروداً للأعلى مع ابتسامة حماس ونظرة نحو السبورة والمعلم.',
          matchedSignIds: ['s_fasl', 's_saeed'],
        ),
        SituationPhrase(
          speaker: 'المعلم',
          arabicText: 'ممتاز يا بطل، إجابتك صحيحة تماماً!',
          signGuidance: 'إشارة الإبهام لأعلى مع التصفيق الصامت بالأيدي المرفوعة الملوحة بفرح.',
          matchedSignIds: ['s_naam', 's_saeed'],
        ),
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'هل يمكنني استعارة قلم لكتابة الملخص؟',
          signGuidance: 'إشارة "قلم" + إشارة "من فضلك" موجهة إلى الزميل المجاور.',
          matchedSignIds: ['s_qalam', 's_men_fadlak'],
        ),
      ],
    ),
    SchoolSituationModel(
      id: 'sit_modares',
      title: 'مع المدرس بعد الحصة',
      description: 'الاستفسار عن الواجبات المدرسية، مواعيد الامتحانات، وتوضيح الدروس.',
      iconEmoji: '👨‍🏫',
      colorValue: 0xFF19A878, // Emerald Green
      phrases: [
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'السلام عليكم يا أستاذ، متى موعد تسليم الواجب المدرسي؟',
          signGuidance: 'إشارة "السلام عليكم" + فتح كفي اليدين ككتاب ثم الاستفسار عن الوقت بهز السبابة.',
          matchedSignIds: ['s_salam', 's_moalem', 's_ketab'],
        ),
        SituationPhrase(
          speaker: 'المعلم',
          arabicText: 'تسليم الواجب بعد غدٍ صباحاً في بداية الحصة الأولى.',
          signGuidance: 'إشارة رقم اثنين بالأصابع متبوعة بإشارة شروق الصباح.',
          matchedSignIds: ['s_sabah_elkhair'],
        ),
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'شكرًا جزيلاً على مجهودك ووقتك معنا.',
          signGuidance: 'إشارة "شكرًا" باليدين من الذقن إلى الأمام مع انحناءة تقدير محترمة.',
          matchedSignIds: ['s_shokran'],
        ),
      ],
    ),
    SchoolSituationModel(
      id: 'sit_idara',
      title: 'في إدارة المدرسة',
      description: 'التواصل مع المدير، استخراج الأوراق الرسمية، وأذونات الخروج والغياب.',
      iconEmoji: '👔',
      colorValue: 0xFF123B72, // Primary Navy
      phrases: [
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'أريد مقابلة السيد مدير المدرسة أو الوكيل للأهمية.',
          signGuidance: 'إشارة "المدير" (شارة الرأس) متبوعة بإشارة التلاقي بالسبابتين.',
          matchedSignIds: ['s_modir', 's_madrasa'],
        ),
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'معي إذن استئذان وموافقة خطية من ولي أمري.',
          signGuidance: 'إشارة الورقة المسطحة مع إشارة التوقيع بالقلم وإشارة الوالد.',
          matchedSignIds: ['s_qalam', 's_naam'],
        ),
        SituationPhrase(
          speaker: 'الإداري',
          arabicText: 'أهلاً بك، تفضل بالجلوس واسترح حتى ننتهي من اعتماد الورقة.',
          signGuidance: 'بسط الكفين للأمام نحو الكرسي في دعوة للجلوس مع ملامح ترحيبية.',
          matchedSignIds: ['s_salam'],
        ),
      ],
    ),
    SchoolSituationModel(
      id: 'sit_eyada',
      title: 'في العيادة المدرسية',
      description: 'شرح الأعراض الصحية للطبيب أو الزائرة الصحية والحصول على الإسعافات.',
      iconEmoji: '🏥',
      colorValue: 0xFFFF6B6B, // Coral Red
      phrases: [
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'أشعر بصداع شديد وألم في رأسي، أحتاج لقياس الحرارة.',
          signGuidance: 'إشارة "أشعر بألم" موجهة إلى جانبي الرأس ثم إشارة مقياس الحرارة عند الفم.',
          matchedSignIds: ['s_alam', 's_eyada'],
          isUrgent: true,
        ),
        SituationPhrase(
          speaker: 'الطبيب',
          arabicText: 'لا تقلق، استلقِ على السرير واشرب قليلاً من الماء الآن.',
          signGuidance: 'إشارة بسط اليد للراحة متبوعة بإشارة "شرب الماء" الهادئة.',
          matchedSignIds: ['s_maa'],
        ),
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'أحتاج للاتصال بولي أمري للحضور إلى المدرسة.',
          signGuidance: 'إشارة الهاتف بالأصابع عند الأذن مع إشارة المنزل والعائلة.',
          matchedSignIds: ['s_mosaada'],
          isUrgent: true,
        ),
      ],
    ),
    SchoolSituationModel(
      id: 'sit_asdekaa',
      title: 'مع الزملاء والأصدقاء',
      description: 'حوارات الفسحة والأنشطة المشتركة ومشاركة الألعاب وتبادل الحديث الودي.',
      iconEmoji: '🤝',
      colorValue: 0xFFF4B942, // Warm Gold
      phrases: [
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'هيا نتناول وجبة الإفطار معاً في فناء المدرسة أثناء الفسحة!',
          signGuidance: 'إشارة تقريب أصابع اليد من الفم (طعام) ثم إشارة الجمع معاً بحركة دائرية سعيدة.',
          matchedSignIds: ['s_saeed'],
        ),
        SituationPhrase(
          speaker: 'الصديق',
          arabicText: 'فكرة رائعة! هل نلعب كرة السلة بعد الانتهاء؟',
          signGuidance: 'إشارة الكرة والرمي في السلة مع ابتسامة حماس كبيرة.',
          matchedSignIds: ['s_naam', 's_saeed'],
        ),
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'أنا سعيد جداً بوجودك معي صديقاً مخلصاً في مدرستنا.',
          signGuidance: 'إشارة "سعيد" بالمسح على الصدر متبوعة بإشارة تشابك الأصابع دلالة الصداقة.',
          matchedSignIds: ['s_saeed', 's_madrasa'],
        ),
      ],
    ),
    SchoolSituationModel(
      id: 'sit_tawaree',
      title: 'طلب المساعدة العاجلة والطوارئ',
      description: 'إشارات سريعة للسلامة العامة والإبلاغ عن أي خطر أو ظرف طارئ.',
      iconEmoji: '🚨',
      colorValue: 0xFF8B64E8, // Lavender / Violet
      phrases: [
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'أحتاج مساعدة عاجلة وفورية، ساعدوني من فضلكم!',
          signGuidance: 'رفع الإبهام الأيمن فوق راحة اليسرى بحركة سريعة ومكررة مع نظرة طلب النجدة.',
          matchedSignIds: ['s_mosaada', 's_men_fadlak'],
          isUrgent: true,
        ),
        SituationPhrase(
          speaker: 'الطالب',
          arabicText: 'أحد زملائي تعثر وسقط على الأرض وتأذى!',
          signGuidance: 'إشارة المشي بالإصبعين ثم قلبهما لأسفل فجأة والإشارة لمكان السقوط.',
          matchedSignIds: ['s_alam', 's_eyada'],
          isUrgent: true,
        ),
        SituationPhrase(
          speaker: 'المشرف',
          arabicText: 'ابقوا هادئين، فريق المساعدة والإسعاف في الطريق إليكم.',
          signGuidance: 'خفض الكفين مفتوحين للأسفل ببطء كإشارة للهدوء والأمان التام.',
          matchedSignIds: ['s_naam'],
        ),
      ],
    ),
  ];
}
