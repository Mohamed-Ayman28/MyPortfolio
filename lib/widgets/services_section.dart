import 'package:flutter/material.dart';

class ServicesSection extends StatefulWidget {
  final GlobalKey sectionKey;

  const ServicesSection({super.key, required this.sectionKey});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with TickerProviderStateMixin {
  late final AnimationController _titleController;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final List<AnimationController> _cardControllers;
  late final List<Animation<double>> _cardFades;
  late final List<Animation<Offset>> _cardSlides;

  final List<_ServiceData> _services = const [
    _ServiceData(
      icon: Icons.phone_android_rounded,
      title: 'Mobile App Development',
      description:
          'Building beautiful, high-performance cross-platform mobile applications using Flutter for iOS and Android.',
      gradientColors: [Colors.cyan, Colors.blue],
    ),
    _ServiceData(
      icon: Icons.palette_rounded,
      title: 'UI/UX Implementation',
      description:
          'Translating designs into pixel-perfect, responsive interfaces with smooth animations and intuitive interactions.',
      gradientColors: [Colors.purple, Colors.pink],
    ),
    _ServiceData(
      icon: Icons.local_fire_department_rounded,
      title: 'Firebase Integration',
      description:
          'Implementing Authentication, Firestore, Cloud Functions, Storage, and Push Notifications for robust backends.',
      gradientColors: [Colors.orange, Colors.deepOrange],
    ),
    _ServiceData(
      icon: Icons.bug_report_rounded,
      title: 'Testing & QA',
      description:
          'Writing comprehensive unit, widget, and integration tests to ensure app reliability and quality.',
      gradientColors: [Colors.green, Colors.teal],
    ),
    _ServiceData(
      icon: Icons.architecture_rounded,
      title: 'Clean Architecture',
      description:
          'Building scalable, maintainable codebases using SOLID principles, Bloc pattern, and clean architecture.',
      gradientColors: [Colors.blue, Colors.indigo],
    ),
    _ServiceData(
      icon: Icons.rocket_launch_rounded,
      title: 'App Deployment',
      description:
          'End-to-end deployment to Google Play Store and Apple App Store with CI/CD pipeline setup.',
      gradientColors: [Colors.teal, Colors.cyan],
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Title animation
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _titleFade = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutCubic,
    ));

    // Card staggered animations
    _cardControllers = List.generate(
      _services.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
    _cardFades = _cardControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();
    _cardSlides = _cardControllers
        .map(
          (c) => Tween<Offset>(
            begin: const Offset(0, 0.25),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic)),
        )
        .toList();

    // Kick off animations
    _titleController.forward();
    _startStaggeredCardAnimations();
  }

  Future<void> _startStaggeredCardAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i < _cardControllers.length; i++) {
      if (!mounted) return;
      _cardControllers[i].forward();
      if (i < _cardControllers.length - 1) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _cardControllers) {
      c.dispose();
    }
    super.dispose();
  }

  int _crossAxisCount(double width) {
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.sectionKey,
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
      child: Column(
        children: [
          // ── Header ──
          SlideTransition(
            position: _titleSlide,
            child: FadeTransition(
              opacity: _titleFade,
              child: Column(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.cyan, Colors.blue, Colors.purple],
                    ).createShader(bounds),
                    child: const Text(
                      'What I Do',
                      style: TextStyle(
                        fontFamily: 'NightPumpkind',
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Services I Offer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.cyan.withValues(alpha: 0.85),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.blue, Colors.purple],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),

          // ── Grid ──
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = _crossAxisCount(constraints.maxWidth);
              final spacing = 20.0;
              final cardWidth =
                  (constraints.maxWidth - spacing * (cols - 1)) / cols;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: WrapAlignment.center,
                children: List.generate(_services.length, (i) {
                  return SlideTransition(
                    position: _cardSlides[i],
                    child: FadeTransition(
                      opacity: _cardFades[i],
                      child: SizedBox(
                        width: cardWidth.clamp(0, 420),
                        child: _ServiceCard(data: _services[i]),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Service card with hover effects
// ─────────────────────────────────────────────────────────────────────────────
class _ServiceCard extends StatefulWidget {
  final _ServiceData data;

  const _ServiceCard({required this.data});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _hoverScale;
  late final Animation<double> _glowOpacity;
  late final Animation<double> _bgShift;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _hoverScale = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
    _glowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
    _bgShift = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent _) => _hoverController.forward();
  void _onExit(PointerEvent _) => _hoverController.reverse();

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _hoverScale.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      const Color(0xff0c1929),
                      data.gradientColors[0].withValues(alpha: 0.12),
                      _bgShift.value,
                    )!,
                    Color.lerp(
                      const Color(0xff1a2a3a),
                      data.gradientColors[1].withValues(alpha: 0.10),
                      _bgShift.value,
                    )!,
                  ],
                ),
                border: Border.all(
                  color: Color.lerp(
                    Colors.white.withValues(alpha: 0.06),
                    Colors.cyan.withValues(alpha: 0.55),
                    _glowOpacity.value,
                  )!,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.12 * _glowOpacity.value),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon container ──
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    data.gradientColors[0].withValues(alpha: 0.85),
                    data.gradientColors[1].withValues(alpha: 0.85),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: data.gradientColors[0].withValues(alpha: 0.30),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                data.icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 20),

            // ── Title ──
            Text(
              data.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),

            // ── Description ──
            Text(
              data.description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────
class _ServiceData {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradientColors;

  const _ServiceData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradientColors,
  });
}
