import 'dart:math';
import 'package:flutter/material.dart';

class DynamicParticlesBackground extends StatefulWidget {
  final List<Color> colors;
  final int count;
  final double opacity;

  const DynamicParticlesBackground({
    super.key,
    this.colors = const [Color(0xFF7C3AED), Color(0xFF3B82F6), Color(0xFFEC4899)],
    this.count = 20,
    this.opacity = 0.15,
  });

  @override
  _DynamicParticlesBackgroundState createState() => _DynamicParticlesBackgroundState();
}

class _DynamicParticlesBackgroundState extends State<DynamicParticlesBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    
    for (int i = 0; i < widget.count; i++) {
      _particles.add(_Particle(
        pos: Offset(_rnd.nextDouble(), _rnd.nextDouble()),
        size: _rnd.nextDouble() * 30 + 10,
        speed: Offset(_rnd.nextDouble() * 0.002 - 0.001, _rnd.nextDouble() * 0.002 - 0.001),
        color: widget.colors[_rnd.nextInt(widget.colors.length)],
        opacity: _rnd.nextDouble() * 0.3 + 0.1,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var p in _particles) {
          p.pos += p.speed;
          if (p.pos.dx < 0) p.pos = Offset(1.0, p.pos.dy);
          if (p.pos.dx > 1) p.pos = Offset(0.0, p.pos.dy);
          if (p.pos.dy < 0) p.pos = Offset(p.pos.dx, 1.0);
          if (p.pos.dy > 1) p.pos = Offset(p.pos.dx, 0.0);
        }
        return CustomPaint(
          painter: _ParticlePainter(_particles, widget.opacity),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  Offset pos;
  final double size;
  final Offset speed;
  final Color color;
  final double opacity;

  _Particle({
    required this.pos,
    required this.size,
    required this.speed,
    required this.color,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double baseOpacity;

  _ParticlePainter(this.particles, this.baseOpacity);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = p.color.withOpacity(p.opacity * baseOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      
      canvas.drawCircle(
        Offset(p.pos.dx * size.width, p.pos.dy * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
