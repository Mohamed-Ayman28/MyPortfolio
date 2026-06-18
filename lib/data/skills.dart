import 'package:flutter/material.dart';

class Skillslist {
  final String skillName;
  final String imagePath;
  final bool isNetwork;
  final bool isSvg;
  final IconData? icon;
  final Color? iconColor;
  final bool invertColors; // For dark SVGs on dark background (e.g. GitHub)

  Skillslist({
    required this.skillName,
    this.imagePath = '',
    this.isNetwork = false,
    this.isSvg = false,
    this.icon,
    this.iconColor,
    this.invertColors = false,
  });
}

class SkillCategory {
  final String categoryName;
  final String categoryEmoji;
  final List<Skillslist> skills;

  SkillCategory({
    required this.categoryName,
    required this.categoryEmoji,
    required this.skills,
  });
}
