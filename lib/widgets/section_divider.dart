import 'package:flutter/material.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 1.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.cyan.withValues(alpha: 0.5),
              Colors.blue.withValues(alpha: 0.5),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}
