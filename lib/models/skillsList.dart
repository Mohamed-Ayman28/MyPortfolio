import 'package:flutter/material.dart';
import 'package:my_portfolio/data/skills.dart';

// DevIcons CDN base URL
const String _devIconBase =
    'https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons';

final List<SkillCategory> skillCategories = [
  // ==================== LANGUAGES ====================
  SkillCategory(
    categoryName: 'LANGUAGES',
    categoryEmoji: '👨‍💻',
    skills: [
      Skillslist(
        skillName: 'Dart',
        imagePath: '$_devIconBase/dart/dart-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'Flutter',
        imagePath: '$_devIconBase/flutter/flutter-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'C',
        imagePath: '$_devIconBase/c/c-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'C++',
        imagePath: '$_devIconBase/cplusplus/cplusplus-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
    ],
  ),

  // ==================== STATE MANAGEMENT ====================
  SkillCategory(
    categoryName: 'STATE MANAGEMENT',
    categoryEmoji: '⚙️',
    skills: [
      Skillslist(
        skillName: 'Provider',
        icon: Icons.account_tree_rounded,
        iconColor: Color(0xffFF6B35),
      ),
      Skillslist(
        skillName: 'Riverpod',
        icon: Icons.hub_rounded,
        iconColor: Color(0xff0553B1),
      ),
      Skillslist(
        skillName: 'Bloc',
        icon: Icons.view_in_ar_rounded,
        iconColor: Color(0xff00B4D8),
      ),
      Skillslist(
        skillName: 'GetX',
        icon: Icons.close_rounded,
        iconColor: Color(0xff8338EC),
      ),
      Skillslist(
        skillName: 'MobX',
        icon: Icons.auto_graph_rounded,
        iconColor: Color(0xffFF6D00),
      ),
    ],
  ),

  // ==================== UI & STYLING ====================
  SkillCategory(
    categoryName: 'UI & STYLING',
    categoryEmoji: '🎨',
    skills: [
      Skillslist(
        skillName: 'Material Design',
        imagePath: '$_devIconBase/materialui/materialui-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'Cupertino',
        icon: Icons.apple_rounded,
        iconColor: Color(0xffA2AAAD),
      ),
      Skillslist(
        skillName: 'Responsive UI',
        icon: Icons.devices_rounded,
        iconColor: Color(0xff4CAF50),
      ),
      Skillslist(
        skillName: 'Animations',
        icon: Icons.animation_rounded,
        iconColor: Color(0xffFF4081),
      ),
      Skillslist(
        skillName: 'Theme & Dark Mode',
        icon: Icons.dark_mode_rounded,
        iconColor: Color(0xff7C4DFF),
      ),
    ],
  ),

  // ==================== FIREBASE & BACKEND ====================
  SkillCategory(
    categoryName: 'FIREBASE & BACKEND',
    categoryEmoji: '🔥',
    skills: [
      Skillslist(
        skillName: 'Firebase',
        imagePath: '$_devIconBase/firebase/firebase-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'Firestore',
        icon: Icons.cloud_rounded,
        iconColor: Color(0xff039BE5),
      ),
      Skillslist(
        skillName: 'Firebase Auth',
        icon: Icons.security_rounded,
        iconColor: Color(0xff4CAF50),
      ),
      Skillslist(
        skillName: 'Cloud Functions',
        icon: Icons.functions_rounded,
        iconColor: Color(0xffFF9800),
      ),
      Skillslist(
        skillName: 'Firebase Storage',
        icon: Icons.storage_rounded,
        iconColor: Color(0xff1565C0),
      ),
      Skillslist(
        skillName: 'Firebase Messaging',
        icon: Icons.notifications_active_rounded,
        iconColor: Color(0xffFFC107),
      ),
    ],
  ),

  // ==================== TOOLS & DEVOPS ====================
  SkillCategory(
    categoryName: 'TOOLS & DEVOPS',
    categoryEmoji: '🛠️',
    skills: [
      Skillslist(
        skillName: 'Git',
        imagePath: '$_devIconBase/git/git-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'GitHub',
        imagePath: '$_devIconBase/github/github-original.svg',
        isNetwork: true,
        isSvg: true,
        invertColors: true,
      ),
      Skillslist(
        skillName: 'Docker',
        imagePath: '$_devIconBase/docker/docker-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'VS Code',
        imagePath: '$_devIconBase/vscode/vscode-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'Android Studio',
        imagePath: '$_devIconBase/androidstudio/androidstudio-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'Postman',
        imagePath: '$_devIconBase/postman/postman-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'CI/CD (GitHub Actions)',
        icon: Icons.settings_suggest_rounded,
        iconColor: Color(0xff2088FF),
      ),
      Skillslist(
        skillName: 'Jira',
        imagePath: '$_devIconBase/jira/jira-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'Figma',
        imagePath: '$_devIconBase/figma/figma-original.svg',
        isNetwork: true,
        isSvg: true,
      ),
    ],
  ),

  // ==================== TESTING ====================
  SkillCategory(
    categoryName: 'TESTING',
    categoryEmoji: '🧪',
    skills: [
      Skillslist(
        skillName: 'Unit Test',
        icon: Icons.check_circle_rounded,
        iconColor: Color(0xff4CAF50),
      ),
      Skillslist(
        skillName: 'Widget Test',
        icon: Icons.widgets_rounded,
        iconColor: Color(0xff2196F3),
      ),
      Skillslist(
        skillName: 'Integration Test',
        icon: Icons.integration_instructions_rounded,
        iconColor: Color(0xffFF9800),
      ),
    ],
  ),

  // ==================== OTHER SKILLS ====================
  SkillCategory(
    categoryName: 'OTHER SKILLS',
    categoryEmoji: '⭐',
    skills: [
      Skillslist(
        skillName: 'REST APIs',
        icon: Icons.api_rounded,
        iconColor: Color(0xffFF5722),
      ),
      Skillslist(
        skillName: 'GraphQL',
        imagePath: '$_devIconBase/graphql/graphql-plain.svg',
        isNetwork: true,
        isSvg: true,
      ),
      Skillslist(
        skillName: 'Clean Architecture',
        icon: Icons.architecture_rounded,
        iconColor: Color(0xff00BCD4),
      ),
      Skillslist(
        skillName: 'SOLID Principles',
        icon: Icons.code_rounded,
        iconColor: Color(0xff8BC34A),
      ),
      Skillslist(
        skillName: 'Agile Methodology',
        icon: Icons.loop_rounded,
        iconColor: Color(0xff9C27B0),
      ),
    ],
  ),
];

// Keep backwards-compatible flat list for any other usage
final List<Skillslist> skills = skillCategories
    .expand((category) => category.skills)
    .toList();
