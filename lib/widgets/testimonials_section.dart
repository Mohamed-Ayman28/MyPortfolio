import 'dart:async';
import 'package:flutter/material.dart';

class TestimonialsSection extends StatefulWidget {
  final GlobalKey sectionKey;

  const TestimonialsSection({super.key, required this.sectionKey});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  double _currentFraction = 0.85;

  final List<Map<String, String>> _testimonials = const [
    {
      'name': 'Ahmed Hassan',
      'role': 'Senior Flutter Developer',
      'initials': 'AH',
      'text':
          'Mohamed is an exceptional Flutter developer with a keen eye for detail. His ability to translate complex designs into beautiful, functional apps is remarkable. A true asset to any development team.',
    },
    {
      'name': 'Eng. Fady Sameh',
      'role': 'DEPI Flutter Instructor',
      'initials': 'FS',
      'text':
          'One of the most dedicated students I have mentored. Mohamed consistently demonstrated strong problem-solving skills and a deep understanding of clean architecture principles throughout the program.',
    },
    {
      'name': 'Esraa Ali',
      'role': 'UI/UX Designer',
      'initials': 'EA',
      'text':
          'Mohamed has an incredible ability to bring designs to life with pixel-perfect accuracy. His understanding of animations and micro-interactions elevates every project he works on.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: _currentFraction);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _testimonials.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _updateViewportFraction(double newFraction) {
    if ((_currentFraction - newFraction).abs() > 0.01) {
      _currentFraction = newFraction;
      _pageController.dispose();
      _pageController = PageController(
        viewportFraction: newFraction,
        initialPage: _currentPage,
      );
      // Rebuild so PageView picks up the new controller
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      key: widget.sectionKey,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xff0d1520),
            const Color(0xff0a0a0a),
            const Color(0xff0d1520).withValues(alpha: 0.8),
          ],
        ),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // --- Section Title ---
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.cyan, Colors.blue, Colors.purple],
              ).createShader(bounds),
              child: const Text(
                'Testimonials',
                style: TextStyle(
                  fontFamily: 'NightPumpkind',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // --- Subtitle ---
            Text(
              'What People Say',
              style: TextStyle(
                fontSize: 16,
                color: Colors.cyan.withValues(alpha: 0.85),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 40),

            // --- Carousel ---
            SizedBox(
              height: isDesktop ? 320 : 360,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final fraction = constraints.maxWidth > 800 ? 0.85 : 0.9;
                  _updateViewportFraction(fraction);

                  return PageView.builder(
                    controller: _pageController,
                    itemCount: _testimonials.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      _startAutoScroll();
                    },
                    itemBuilder: (context, index) {
                      return _TestimonialCard(
                        testimonial: _testimonials[index],
                        isActive: index == _currentPage,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // --- Dot Indicators ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _testimonials.length,
                (index) => _AnimatedDot(isActive: index == _currentPage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Animated Dot Indicator
// ---------------------------------------------------------------------------
class _AnimatedDot extends StatelessWidget {
  final bool isActive;

  const _AnimatedDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 28 : 10,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: isActive
            ? const LinearGradient(colors: [Colors.cyan, Colors.blueAccent])
            : null,
        color: isActive ? null : Colors.white.withValues(alpha: 0.2),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.45),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Testimonial Card (with hover glow)
// ---------------------------------------------------------------------------
class _TestimonialCard extends StatefulWidget {
  final Map<String, String> testimonial;
  final bool isActive;

  const _TestimonialCard({required this.testimonial, required this.isActive});

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _scaleController.forward();
    } else {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.testimonial;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xff0c1929),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? Colors.cyan.withValues(alpha: 0.5)
                  : Colors.cyan.withValues(alpha: 0.12),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? Colors.cyan.withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: 0.3),
                blurRadius: _isHovered ? 28 : 12,
                spreadRadius: _isHovered ? 2 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote icon
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.cyan, Colors.cyan.withValues(alpha: 0.4)],
                ).createShader(bounds),
                child: const Icon(
                  Icons.format_quote_rounded,
                  size: 38,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),

              // Testimonial text
              Expanded(
                child: Text(
                  data['text'] ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gradient divider
              Container(
                height: 1.2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.cyan.withValues(alpha: 0.7),
                      Colors.cyan.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Author row
              Row(
                children: [
                  // Avatar with gradient ring
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff0c1929),
                        ),
                        child: Center(
                          child: Text(
                            data['initials'] ?? '',
                            style: const TextStyle(
                              color: Colors.cyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Name & role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data['role'] ?? '',
                          style: TextStyle(
                            color: Colors.cyan.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
