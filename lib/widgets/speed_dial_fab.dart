import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpeedDialFab extends StatefulWidget {
  final ScrollController scrollController;

  const SpeedDialFab({super.key, required this.scrollController});

  @override
  State<SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<SpeedDialFab>
    with TickerProviderStateMixin {
  bool _isExpanded = false;

  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late final AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;

  // Staggered animations for each mini button
  late final Animation<double> _button1Animation;
  late final Animation<double> _button2Animation;
  late final Animation<double> _button3Animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    // Staggered intervals for each button (bottom to top)
    _button1Animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    );
    _button2Animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.75, curve: Curves.easeOutBack),
    );
    _button3Animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.9, curve: Curves.easeOutBack),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.625).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
        _rotationController.forward();
      } else {
        _controller.reverse();
        _rotationController.reverse();
      }
    });
  }

  void _collapse() {
    if (_isExpanded) {
      _toggle();
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
    _collapse();
  }

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse('https://wa.me/201204726601');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    _collapse();
  }

  Future<void> _launchEmail() async {
    final uri = Uri.parse('mailto:mohameda.ayman8@gmail.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    _collapse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // --- Backdrop overlay ---
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _collapse,
              child: FadeTransition(
                opacity: _expandAnimation,
                child: Container(
                  color: const Color(0xFF0a0a0a).withValues(alpha: 0.6),
                ),
              ),
            ),
          ),

        // --- Mini buttons + Main FAB column ---
        Positioned(
          bottom: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // --- Button 3: Email (top) ---
              _buildMiniButton(
                animation: _button3Animation,
                label: 'Email',
                icon: Icons.email_rounded,
                color: Colors.orange,
                onTap: _launchEmail,
              ),
              const SizedBox(height: 12),

              // --- Button 2: WhatsApp ---
              _buildMiniButton(
                animation: _button2Animation,
                label: 'WhatsApp',
                icon: Icons.chat_rounded,
                color: Colors.green,
                onTap: _launchWhatsApp,
              ),
              const SizedBox(height: 12),

              // --- Button 1: Scroll to Top ---
              _buildMiniButton(
                animation: _button1Animation,
                label: 'Scroll to Top',
                icon: Icons.arrow_upward_rounded,
                color: Colors.cyan,
                onTap: _scrollToTop,
              ),
              const SizedBox(height: 16),

              // --- Main FAB ---
              _buildMainFab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniButton({
    required Animation<double> animation,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final scale = animation.value;
        final opacity = animation.value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: scale,
          alignment: Alignment.centerRight,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF0c1929),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Mini FAB
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF1a2a3a),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainFab() {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.cyan.withValues(alpha: _isExpanded ? 0.9 : 1.0),
              Colors.blue.withValues(alpha: _isExpanded ? 0.9 : 1.0),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.withValues(alpha: _isExpanded ? 0.4 : 0.3),
              blurRadius: _isExpanded ? 20 : 12,
              spreadRadius: _isExpanded ? 2 : 0,
            ),
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: RotationTransition(
          turns: _rotationAnimation,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
