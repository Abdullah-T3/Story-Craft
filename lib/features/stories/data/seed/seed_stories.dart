import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';
import 'package:story_craft/features/stories/domain/entities/story_page.dart';

abstract final class SeedStories {
  SeedStories._();

  static final List<Story> all = [
    Story(
      id: 'green-forest',
      title: 'سر الغابة الخضراء',
      summary:
          'انطلق في مغامرة شيقة داخل غابة سحرية لاكتشاف سرّها العظيم مع رفاق جدد.',
      categoryId: 'adventures',
      ageRangeFrom: 6,
      ageRangeTo: 9,
      durationMinutes: 5,
      coverEmoji: '🌳',
      coverColor: AppColors.primaryContainer,
      tags: const ['غابة', 'مغامرة', 'صداقة'],
      isFeatured: true,
      pages: [
        StoryPage(
          index: 0,
          emoji: '🌳',
          text: 'في صباحٍ مشرق، انطلق سامي إلى الغابة الخضراء بحثًا عن السر.',
        ),
        StoryPage(
          index: 1,
          emoji: '🦊',
          text: 'قابل سامي ثعلبًا لطيفًا قال له: تبعني بهدوء، فلديّ ما أريك.',
        ),
        StoryPage(
          index: 2,
          emoji: '🌼',
          text:
              'مرّا بحقلٍ من الزهور الذهبية، وكلما خطا سامي خطوةً أضاءت زهرة.',
        ),
        StoryPage(
          index: 3,
          emoji: '💎',
          text:
              'وفي قلب الغابة وجد سامي صندوقًا بداخله بذرةٌ تنمو منها أحلامٌ جميلة.',
        ),
        StoryPage(
          index: 4,
          emoji: '🌟',
          text:
              'فهم سامي أن سرّ الغابة هو أن نزرع الخير لنحصد الفرح. وعاد سعيدًا.',
        ),
      ],
    ),
    Story(
      id: 'space-trip',
      title: 'رحلة في الفضاء',
      summary:
          'سفينة صغيرة تحلّق بين النجوم لتتعرف على الكواكب وأسرار الكون.',
      categoryId: 'fantasy',
      ageRangeFrom: 7,
      ageRangeTo: 10,
      durationMinutes: 8,
      coverEmoji: '🚀',
      coverColor: AppColors.tertiaryContainer,
      tags: const ['فضاء', 'كواكب', 'علم'],
      pages: [
        StoryPage(
          index: 0,
          emoji: '🚀',
          text: 'استعدّت سفينة "نجمة" للإقلاع، والكابتن نور يلوّح للعائلة.',
        ),
        StoryPage(
          index: 1,
          emoji: '🪐',
          text: 'مرّت السفينة قرب زحل، فذكّرتها حلقاته بطبق العائلة الكبير.',
        ),
        StoryPage(
          index: 2,
          emoji: '🌑',
          text: 'هبطت نور على القمر، وقفزت قفزات طويلة بفضل الجاذبية الخفيفة.',
        ),
        StoryPage(
          index: 3,
          emoji: '✨',
          text:
              'في نهاية الرحلة، عادت نور وهي تحمل صورًا للنجوم لتُريها لأصدقائها.',
        ),
      ],
    ),
    Story(
      id: 'little-boat',
      title: 'قارب الصيد الصغير',
      summary: 'قاربٌ صغير يخوض البحر مع الأسماك ويتعلّم أهمية الصبر والتعاون.',
      categoryId: 'animals',
      ageRangeFrom: 5,
      ageRangeTo: 8,
      durationMinutes: 6,
      coverEmoji: '⛵',
      coverColor: AppColors.secondaryContainer,
      tags: const ['بحر', 'حيوانات', 'تعاون'],
      pages: [
        StoryPage(
          index: 0,
          emoji: '⛵',
          text: 'أبحر القارب الصغير في فجرٍ هادئ يرافقه نسيم لطيف.',
        ),
        StoryPage(
          index: 1,
          emoji: '🐟',
          text: 'سبحت سمكة فضية بجانبه وقالت: تعال نلعب معًا.',
        ),
        StoryPage(
          index: 2,
          emoji: '🌊',
          text: 'هبت موجة كبيرة فتعاون القارب والأسماك للوصول إلى الشاطئ.',
        ),
      ],
    ),
    Story(
      id: 'magic-colors',
      title: 'مملكة الألوان السحرية',
      summary: 'فتاة فضولية تكتشف مملكةً سرّية تتحوّل فيها الألوان إلى مشاعر.',
      categoryId: 'fantasy',
      ageRangeFrom: 6,
      ageRangeTo: 9,
      durationMinutes: 7,
      coverEmoji: '✨',
      coverColor: AppColors.headerBackground,
      tags: const ['ألوان', 'خيال', 'مشاعر'],
      pages: [
        StoryPage(
          index: 0,
          emoji: '🎨',
          text: 'فتحت ليان دفترها فاندفعت ألوانٌ ساحرة وقادتها إلى مملكة عجيبة.',
        ),
        StoryPage(
          index: 1,
          emoji: '💛',
          text: 'الأصفر يبتسم، والأزرق يهدئ القلب، والأخضر يدعو للعب في الحقل.',
        ),
        StoryPage(
          index: 2,
          emoji: '🌈',
          text: 'تعلّمت ليان أن لكل لونٍ قصة، وأن المشاعر تستحق أن نسمّيها.',
        ),
      ],
    ),
    Story(
      id: 'numbers-adventure',
      title: 'مغامرة الأرقام',
      summary: 'رحلة لعبٍ وتعلّم مع الأرقام تكشف لطلاب الصفّ أسرار الحساب.',
      categoryId: 'educational',
      ageRangeFrom: 5,
      ageRangeTo: 8,
      durationMinutes: 4,
      coverEmoji: '🔢',
      coverColor: AppColors.primaryContainer,
      tags: const ['أرقام', 'تعليم', 'رياضيات'],
      pages: [
        StoryPage(
          index: 0,
          emoji: '1️⃣',
          text: 'بدأ الواحد رحلته وحيدًا، فقابل الاثنين فأصبحا فريقًا.',
        ),
        StoryPage(
          index: 1,
          emoji: '➕',
          text:
              'انضمّ الثلاثة، وعرفوا أن الجمع يجعل الأشياء أكبر والصداقات أقوى.',
        ),
        StoryPage(
          index: 2,
          emoji: '🏆',
          text: 'في النهاية، ربح الفريق سباق الأرقام لأنهم تعاونوا.',
        ),
      ],
    ),
    Story(
      id: 'kind-rabbit',
      title: 'الأرنب الطيب',
      summary:
          'أرنبٌ صغير يساعد جيرانه في الغابة ويتعلّم درسًا جميلًا في العطاء.',
      categoryId: 'animals',
      ageRangeFrom: 4,
      ageRangeTo: 7,
      durationMinutes: 4,
      coverEmoji: '🐰',
      coverColor: AppColors.tertiaryContainer,
      tags: const ['أرنب', 'عطاء', 'حيوانات'],
      pages: [
        StoryPage(
          index: 0,
          emoji: '🐰',
          text: 'استيقظ الأرنب الصغير ووجد سلّةً من الجزر أمام بابه.',
        ),
        StoryPage(
          index: 1,
          emoji: '🥕',
          text: 'قسّم الجزر على جيرانه السنجاب والقنفذ والسلحفاة.',
        ),
        StoryPage(
          index: 2,
          emoji: '💖',
          text: 'في المساء، شعر الأرنب أنه أسعد من في الغابة.',
        ),
      ],
    ),
  ];

  static Story get storyOfTheDay =>
      all.firstWhere((s) => s.isFeatured, orElse: () => all.first);
}
