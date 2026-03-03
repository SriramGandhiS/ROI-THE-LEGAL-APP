import 'package:flutter/material.dart';

/// Centralized color tokens for the professional light theme.
/// Inspired by Byju's / LearnHub — purple-dominant, clean whites.
class AppColors {
  AppColors._();

  // ─── Primary palette ───
  static const primary       = Color(0xFF6C3AED);  // Vivid purple
  static const primaryLight  = Color(0xFF8B5CF6);  // Lighter shade
  static const primaryDark   = Color(0xFF5B21B6);  // Darker shade
  static const primaryBg     = Color(0xFFEDE9FE);  // Very light purple bg

  // ─── Accent ───
  static const accent        = Color(0xFFF59E0B);  // Amber
  static const accentLight   = Color(0xFFFCD34D);

  // ─── Backgrounds ───
  static const background    = Color(0xFFF8FAFC);  // Page bg
  static const surface       = Color(0xFFFFFFFF);  // Cards
  static const surfaceAlt    = Color(0xFFF1F5F9);  // Slightly gray surface

  // ─── Text ───
  static const textPrimary   = Color(0xFF1E293B);  // Dark headings
  static const textSecondary = Color(0xFF64748B);  // Body / subtitles
  static const textHint      = Color(0xFF94A3B8);  // Placeholders

  // ─── Borders ───
  static const border        = Color(0xFFE2E8F0);
  static const borderLight   = Color(0xFFF1F5F9);

  // ─── Semantic ───
  static const success       = Color(0xFF059669);  // Green
  static const successBg     = Color(0xFFECFDF5);
  static const error         = Color(0xFFDC2626);
  static const errorBg       = Color(0xFFFEF2F2);
  static const warning       = Color(0xFFF59E0B);
  static const warningBg     = Color(0xFFFFFBEB);
  static const info          = Color(0xFF3B82F6);
  static const infoBg        = Color(0xFFEFF6FF);

  // ─── Chat-specific ───
  static const chatUser      = Color(0xFF6C3AED);  // Purple bubble
  static const chatBot       = Color(0xFFF1F5F9);  // Light gray bubble
  static const chatVoice     = Color(0xFF059669);  // Green for voice mode

  // ─── Gradients ───
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6C3AED), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const heroGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardGradient = LinearGradient(
    colors: [Color(0xFFEDE9FE), Color(0xFFF0F9FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Page background — light purple lavender fading to white (Byju's style)
  static const backgroundGradient = LinearGradient(
    colors: [Color(0xFFEDE9FE), Color(0xFFF3F0FF), Color(0xFFFBFAFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.3, 1.0],
  );

  // ─── Module card accents (for dashpage cards) ───
  static const List<Color> moduleAccents = [
    Color(0xFF6C3AED),  // Purple
    Color(0xFF3B82F6),  // Blue
    Color(0xFFF59E0B),  // Amber
    Color(0xFF059669),  // Green
    Color(0xFFEC4899),  // Pink
    Color(0xFFEF4444),  // Red
    Color(0xFF8B5CF6),  // Violet
    Color(0xFF14B8A6),  // Teal
  ];
}
