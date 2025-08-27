import 'package:flutter/material.dart';
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
    return Column(
      children: [
        // Section Title
        Text(
          scetionTitle,
          style: const TextStyle(
            fontSize: 50,
            fontFamily: "NightPumpkind",
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),

        // Content Card
        SizedBox(
          width: 900,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.grey.shade900,
            elevation: 12,
            shadowColor: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: Section image
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

                  // Right side: Subtitle + content/skills
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

                        // If normal content exists → show text
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

                        // If no content → show skills list
                        if (content.isEmpty)
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: skills.map((skill) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xff2E4252),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      skill.imagePath,
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      skill.skillName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
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
  }
}
