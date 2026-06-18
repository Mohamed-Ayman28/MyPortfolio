import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_portfolio/data/skills.dart';
import 'package:my_portfolio/models/skillsList.dart';

class SkillsSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const SkillsSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xff0a0a0a),
            const Color(0xff0d1520).withValues(alpha: 0.9),
            const Color(0xff0a0a0a),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          final cardWidth =
              constraints.maxWidth > 1100 ? 1100.0 : constraints.maxWidth * 0.95;

          return Column(
            children: [
              // ===== TITLE =====
              _buildTitle(isMobile),
              const SizedBox(height: 8),
              Text(
                'Flutter Developer',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.cyan,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),

              // ===== MAIN CARD =====
              SizedBox(
                width: cardWidth,
                child: _SkillsCard(isMobile: isMobile),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitle(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDecoLine(),
        const SizedBox(width: 16),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.cyan, Colors.blue, Colors.purple],
          ).createShader(bounds),
          child: Text(
            'SKILLS',
            style: TextStyle(
              fontSize: isMobile ? 35 : 50,
              fontFamily: 'NightPumpkind',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildDecoLine(),
      ],
    );
  }

  Widget _buildDecoLine() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.transparent, Colors.cyan, Colors.transparent],
      ).createShader(bounds),
      child: Container(
        width: 40,
        height: 2,
        color: Colors.white,
      ),
    );
  }
}

// ===================================================================
// MAIN SKILLS CARD
// ===================================================================
class _SkillsCard extends StatelessWidget {
  final bool isMobile;

  const _SkillsCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0c1929),
        border: Border.all(
          color: Colors.cyan.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withValues(alpha: 0.06),
            blurRadius: 40,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Flutter logo on the left
        _buildFlutterLogo(),
        const SizedBox(width: 36),
        // Skill categories on the right
        Expanded(child: _buildAllCategories()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildFlutterLogo(),
        const SizedBox(height: 28),
        _buildAllCategories(),
      ],
    );
  }

  Widget _buildFlutterLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isMobile ? 140 : 180,
          height: isMobile ? 140 : 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xff1a3a5c).withValues(alpha: 0.8),
                const Color(0xff0c1929),
              ],
            ),
            border: Border.all(
              color: Colors.cyan.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/images/skills/flutter.png',
              width: isMobile ? 70 : 90,
              height: isMobile ? 70 : 90,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.flutter_dash,
                  size: isMobile ? 60 : 80,
                  color: Colors.cyan,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'FLUTTER',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'D E V E L O P E R',
          style: TextStyle(
            color: Colors.cyan.withValues(alpha: 0.7),
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildAllCategories() {
    // Split categories: first 5 normal, last 2 (Testing & Other) side by side on desktop
    final mainCategories = skillCategories.take(5).toList();
    final bottomCategories = skillCategories.skip(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main categories
        ...mainCategories.map(
          (cat) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _SkillCategoryRow(category: cat),
          ),
        ),
        // Bottom categories: Testing & Other Skills
        if (!isMobile && bottomCategories.length >= 2)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SkillCategoryRow(category: bottomCategories[0]),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _SkillCategoryRow(category: bottomCategories[1]),
              ),
            ],
          )
        else
          ...bottomCategories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _SkillCategoryRow(category: cat),
            ),
          ),
      ],
    );
  }
}

// ===================================================================
// SKILL CATEGORY ROW
// ===================================================================
class _SkillCategoryRow extends StatelessWidget {
  final SkillCategory category;

  const _SkillCategoryRow({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category.categoryEmoji,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              category.categoryName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Skill chips
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: category.skills
              .map((skill) => _SkillChipEnhanced(skill: skill))
              .toList(),
        ),
      ],
    );
  }
}

// ===================================================================
// ENHANCED SKILL CHIP
// ===================================================================
class _SkillChipEnhanced extends StatefulWidget {
  final Skillslist skill;

  const _SkillChipEnhanced({required this.skill});

  @override
  State<_SkillChipEnhanced> createState() => _SkillChipEnhancedState();
}

class _SkillChipEnhancedState extends State<_SkillChipEnhanced> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered
              ? const Color(0xff1e3a5c)
              : const Color(0xff111d2e),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _isHovered
                ? Colors.cyan.withValues(alpha: 0.6)
                : Colors.cyan.withValues(alpha: 0.12),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(width: 8),
            Text(
              widget.skill.skillName,
              style: TextStyle(
                color: _isHovered ? Colors.white : Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final skill = widget.skill;

    // If it has a network SVG image
    if (skill.isSvg && skill.isNetwork && skill.imagePath.isNotEmpty) {
      return SizedBox(
        width: 20,
        height: 20,
        child: SvgPicture.network(
          skill.imagePath,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
          colorFilter: skill.invertColors
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null,
          placeholderBuilder: (context) => SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Colors.cyan.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    // If it has a local asset image
    if (skill.imagePath.isNotEmpty && !skill.isNetwork) {
      return SizedBox(
        width: 20,
        height: 20,
        child: Image.asset(
          skill.imagePath,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.code,
              size: 18,
              color: skill.iconColor ?? Colors.cyan,
            );
          },
        ),
      );
    }

    // Use Material Icon
    return Icon(
      skill.icon ?? Icons.code,
      size: 18,
      color: skill.iconColor ?? Colors.cyan,
    );
  }
}
