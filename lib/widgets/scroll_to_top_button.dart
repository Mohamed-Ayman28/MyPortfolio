import 'package:flutter/material.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollToTopButton({super.key, required this.scrollController});

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton>
    with TickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController.offset > 300 && !_isVisible) {
      setState(() => _isVisible = true);
      _controller.forward();
    } else if (widget.scrollController.offset <= 300 && _isVisible) {
      setState(() => _isVisible = false);
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: FloatingActionButton(
        onPressed: () {
          widget.scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.transparent,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.cyan, Colors.blue],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.4),
                    blurRadius: 15 * _pulseAnimation.value,
                    spreadRadius: 2 * _pulseAnimation.value,
                  ),
                ],
              ),
              child: const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.white,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }
}
