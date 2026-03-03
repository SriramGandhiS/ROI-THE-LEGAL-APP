import 'package:flutter/material.dart';
import 'package:login_signup/theme/app_colors.dart';

/// A card with a subtle colored border and shadow.
/// Replaces the old NeonCard with neon glow effects.
class NeonCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? accentColor;

  const NeonCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Text with a custom gradient effect (kept for branding).
class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final List<Color> gradientColors;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  const GradientText({
    super.key,
    required this.text,
    required this.fontSize,
    List<Color>? gradientColors,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.bold,
  }) : gradientColors = gradientColors ??
            const [AppColors.primary, AppColors.primaryLight];

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: 1.1,
          fontFamily: 'PlusJakartaSans',
        ),
        textAlign: textAlign,
      ),
    );
  }
}
