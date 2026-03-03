import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Particle Background: Shimmering Gold Dust
// ─────────────────────────────────────────────────────────────────────────────
class ParticleBackground extends StatefulWidget {
  final Color baseColor;
  const ParticleBackground({super.key, this.baseColor = const Color(0xFF0B1D35)});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = List.generate(40, (index) => Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 10))
      ..repeat();
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
        return CustomPaint(
          painter: ParticlePainter(_particles, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  double x = math.Random().nextDouble();
  double y = math.Random().nextDouble();
  double size = math.Random().nextDouble() * 2 + 0.5;
  double speed = math.Random().nextDouble() * 0.02 + 0.005;
  double opacity = math.Random().nextDouble() * 0.5 + 0.1;

  void update() {
    y -= speed * 0.1;
    if (y < 0) {
      y = 1.0;
      x = math.Random().nextDouble();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A017).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      particle.update();
      final pos = Offset(particle.x * size.width, particle.y * size.height);
      
      // Floating effect
      final pulse = math.sin(animationValue * math.pi * 2 + particle.x * 10) * 0.2 + 0.8;
      
      canvas.drawCircle(
        pos,
        particle.size * pulse,
        paint..color = const Color(0xFFD4A017).withOpacity(particle.opacity * pulse),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// Legal Marquee: Scrolling News Ticker
// ─────────────────────────────────────────────────────────────────────────────
class LegalMarquee extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double velocity;

  const LegalMarquee({
    super.key,
    required this.text,
    this.style = const TextStyle(
        color: Color(0xFFF5EDD6),
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0.5),
    this.velocity = 30.0,
  });

  @override
  State<LegalMarquee> createState() => _LegalMarqueeState();
}

class _LegalMarqueeState extends State<LegalMarquee> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      
      if (currentScroll >= maxScroll) {
        _scrollController.jumpTo(0);
      }
      
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: (maxScroll / widget.velocity).toInt()),
        curve: Curves.linear,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF122644).withOpacity(0.5),
        border: Border.symmetric(
          horizontal: BorderSide(color: const Color(0xFFD4A017).withOpacity(0.2), width: 0.5),
        ),
      ),
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.gavel_rounded, color: Color(0xFFD4A017), size: 14),
                const SizedBox(width: 8),
                Text(widget.text, style: widget.style),
                const SizedBox(width: 100), // Gap before loop
                const Icon(Icons.gavel_rounded, color: Color(0xFFD4A017), size: 14),
                const SizedBox(width: 8),
                Text(widget.text, style: widget.style),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ... (previous widgets remain same)

// ─────────────────────────────────────────────────────────────────────────────
// Meteor Shower: Falling Stars
// ─────────────────────────────────────────────────────────────────────────────

class Meteor {
  final double startX;
  final double startY;
  late double endX;
  late double endY;
  final double delay;
  final double duration;

  Meteor(double angle, Size size)
      : startX = math.Random().nextDouble() * size.width,
        startY = math.Random().nextDouble() * size.height / 2 - size.height / 2,
        delay = math.Random().nextDouble(),
        duration = 0.4 + math.Random().nextDouble() * 0.6 {
    var distance = size.height * 0.8;
    endX = startX + math.cos(angle) * distance;
    endY = startY + math.sin(angle) * distance;
  }
}

class MeteorPainter extends CustomPainter {
  final Color color;
  MeteorPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trailPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.6), color.withOpacity(0)],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw long trail
    final path = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(0, 0);
    
    canvas.drawPath(
      path, 
      Paint()
        ..shader = trailPaint.shader
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
    );

    // Draw head
    final Paint circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width, size.height), 1.2, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MeteorShower extends StatefulWidget {
  final int numberOfMeteors;
  final Duration duration;
  final Color meteorColor;
  final Widget? child;

  const MeteorShower({
    super.key,
    this.numberOfMeteors = 8,
    this.duration = const Duration(seconds: 4),
    this.meteorColor = const Color(0xFFD4A017),
    this.child,
  });

  @override
  _MeteorShowerState createState() => _MeteorShowerState();
}

class _MeteorShowerState extends State<MeteorShower>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Meteor> _meteors = [];
  final double meteorAngle = math.pi / 3; // 60 degrees

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeMeteors(Size size) {
    if (_meteors.isEmpty || _meteors.length != widget.numberOfMeteors) {
      _meteors = List.generate(
          widget.numberOfMeteors, (_) => Meteor(meteorAngle, size));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initializeMeteors(size);

        return Stack(
          children: [
            if (widget.child != null) widget.child!,
            ...List.generate(widget.numberOfMeteors, (index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final meteor = _meteors[index];
                  // Calculate progress based on controller value and meteor delay
                  double progress = (_controller.value - meteor.delay);
                  if (progress < 0) progress += 1.0;
                  progress = progress / meteor.duration;
                  
                  if (progress < 0 || progress > 1) return const SizedBox.shrink();

                  return Positioned(
                    left: meteor.startX + (meteor.endX - meteor.startX) * progress,
                    top: meteor.startY + (meteor.endY - meteor.startY) * progress,
                    child: Opacity(
                      opacity: (1 - progress) * 0.7,
                      child: CustomPaint(
                        size: const Size(30, 30),
                        painter: MeteorPainter(widget.meteorColor),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        );
      },
    );
  }
}
