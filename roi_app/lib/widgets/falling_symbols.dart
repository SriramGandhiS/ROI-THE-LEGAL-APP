import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Neon Falling Symbols Background
// Each symbol glows with customizable neon colors and a bright shadow halo.
// ─────────────────────────────────────────────────────────────────────────────

class FallingSymbolsBackground extends StatefulWidget {
  final List<String> symbols;
  final int count;
  final double opacity;
  final bool neon;
  final List<Color> neonColors;

  const FallingSymbolsBackground({
    super.key,
    required this.symbols,
    this.count = 14,
    this.opacity = 0.28,
    this.neon = true,
    this.neonColors = const [
      Color(0xFF6C3AED), // neon purple
      Color(0xFF3B82F6), // neon blue
      Color(0xFF059669), // neon green
      Color(0xFFEC4899), // neon pink
      Color(0xFFF59E0B), // neon amber
    ],
  });

  @override
  State<FallingSymbolsBackground> createState() => _FallingSymbolsBackgroundState();
}

class _FallingSymbolsBackgroundState extends State<FallingSymbolsBackground>
    with TickerProviderStateMixin {
  late List<_SymbolParticle> _particles;
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _particles = List.generate(widget.count, (i) => _SymbolParticle(
      symbol: widget.symbols[i % widget.symbols.length],
      x: rng.nextDouble(),
      startY: -rng.nextDouble() * 0.8,
      size: 16 + rng.nextDouble() * 18,
      duration: 7000 + rng.nextInt(7000),
      delay: rng.nextInt(6000),
      rotate: rng.nextDouble() * 2 * pi,
      sway: (rng.nextDouble() - 0.5) * 0.05,
      colorIdx: i % widget.neonColors.length,
    ));

    _controllers = _particles.map((p) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: p.duration),
      );
      Future.delayed(Duration(milliseconds: p.delay), () {
        if (mounted) ctrl.repeat();
      });
      return ctrl;
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(children: List.generate(_particles.length, (i) {
          final p = _particles[i];
          final ctrl = _controllers[i];
          final neonColor = widget.neonColors[p.colorIdx];
          return AnimatedBuilder(
            animation: ctrl,
            builder: (_, __) {
              final t = ctrl.value;
              final y = (p.startY + t * 1.4).clamp(-0.2, 1.3);
              final x = p.x + sin(t * pi * 3.5) * p.sway;
              // Fade in at top, full in middle, fade out at bottom
              final edgeFade = (y < 0.1 ? (y + 0.1) * 5 : y > 0.85 ? (1.1 - y) * 4 : 1.0).clamp(0.0, 1.0);
              final alpha = widget.opacity * edgeFade;

              return Positioned(
                left: x * constraints.maxWidth,
                top: y * constraints.maxHeight,
                child: Transform.rotate(
                  angle: p.rotate + t * pi * 0.8,
                  child: Opacity(
                    opacity: alpha.clamp(0.0, 1.0),
                    child: widget.neon
                      ? Text(
                          p.symbol,
                          style: TextStyle(
                            fontSize: p.size,
                            color: Colors.white,
                            shadows: [
                              // Inner bright glow
                              Shadow(color: neonColor, blurRadius: 8),
                              Shadow(color: neonColor, blurRadius: 16),
                              // Outer diffuse halo
                              Shadow(color: neonColor.withOpacity(0.5), blurRadius: 32),
                              Shadow(color: neonColor.withOpacity(0.3), blurRadius: 48),
                            ],
                          ),
                        )
                      : Text(p.symbol, style: TextStyle(fontSize: p.size)),
                  ),
                ),
              );
            },
          );
        }));
      }),
    );
  }
}

class _SymbolParticle {
  final String symbol;
  final double x, startY, size, sway, rotate;
  final int duration, delay, colorIdx;
  const _SymbolParticle({
    required this.symbol, required this.x, required this.startY,
    required this.size, required this.duration, required this.delay,
    required this.rotate, required this.sway, required this.colorIdx,
  });
}
