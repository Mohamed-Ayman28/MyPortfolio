import 'dart:math';
import 'package:flutter/material.dart';

class FloatingParticles extends StatefulWidget {
  final int particleCount;
  final Widget child;

  const FloatingParticles({
    super.key,
    this.particleCount = 20,
    required this.child,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late List<_Particle> particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    particles = List.generate(
      widget.particleCount,
      (index) => _Particle.random(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ParticlePainter(
                    particles: particles,
                    animationValue: _controller.value,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
  });

  factory _Particle.random() {
    final random = Random();
    final colors = [Colors.cyan, Colors.blue, Colors.purple, Colors.teal];
    return _Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 4 + 1,
      speed: random.nextDouble() * 0.5 + 0.2,
      opacity: random.nextDouble() * 0.4 + 0.1,
      color: colors[random.nextInt(colors.length)],
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;

  _ParticlePainter({required this.particles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final animatedY = (particle.y + animationValue * particle.speed) % 1.0;
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(
        Offset(particle.x * size.width, animatedY * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}
