import 'package:flutter/material.dart';
import 'package:my_portfolio/data/skills.dart';
import 'package:my_portfolio/models/skillsList.dart';

class custom_card extends StatelessWidget {
  final String image;
  final String scetionTitle;
  final String subTitle;
  final String content;

  const custom_card({
    super.key,
    this.image = '',
    this.scetionTitle = '',
    this.subTitle = '',
    this.content = '',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        double cardWidth = constraints.maxWidth > 900
            ? 900
            : constraints.maxWidth * 0.95;

        return Column(
          children: [
            Text(
              scetionTitle,
              style: TextStyle(
                fontSize: isMobile ? 35 : 50,
                fontFamily: "NightPumpkind",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: cardWidth,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.grey.shade900,
                elevation: 12,
                shadowColor: Colors.black54,
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 20 : 30),
                  child: isMobile
                      ? Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                image,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  subTitle,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                if (content.isNotEmpty)
                                  Text(
                                    content,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70,
                                      height: 1.6,
                                    ),
                                  ),
                                if (content.isEmpty)
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    children: skills.map((skill) {
                                      return _SkillChip(skill: skill);
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                image,
                                width: 180,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subTitle,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (content.isNotEmpty)
                                    Text(
                                      content,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white70,
                                        height: 1.6,
                                      ),
                                    ),
                                  if (content.isEmpty)
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: skills.map((skill) {
                                        return _SkillChip(skill: skill);
                                      }).toList(),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SkillChip extends StatefulWidget {
  final Skillslist skill;

  const _SkillChip({required this.skill});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xff3E5262) : const Color(0xff2E4252),
          borderRadius: BorderRadius.circular(30),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                widget.skill.imagePath,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.code,
                    size: 28,
                    color: Colors.orangeAccent,
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.skill.skillName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
