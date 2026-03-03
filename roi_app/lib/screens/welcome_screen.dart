import 'package:flutter/material.dart';
import 'package:login_signup/screens/signin_screen.dart';
import 'package:login_signup/screens/signup_screen.dart';
import 'package:login_signup/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Welcome / Splash Screen — Byju's onboarding style
// Cartoon illustration + gradient splash + clean CTA buttons
// ─────────────────────────────────────────────────────────────────────────────
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -8.0, end: 8.0).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _fadeAnim = CurvedAnimation(parent: _floatCtrl, curve: Curves.easeIn);
  }

  @override
  void dispose() { _floatCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        // ── Top purple splash (Byju's style)
        Expanded(
          flex: 55,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B21B6), Color(0xFF7C3AED), Color(0xFF6366F1)],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(alignment: Alignment.center, children: [
              // Decorative circles (Byju's concentric rings)
              _ring(size.width * 0.9, Colors.white.withOpacity(0.04)),
              _ring(size.width * 0.65, Colors.white.withOpacity(0.05)),
              _ring(size.width * 0.4, Colors.white.withOpacity(0.06)),

              // Floating cartoon illustration
              Positioned(bottom: 0, child: AnimatedBuilder(
                animation: _floatAnim,
                builder: (_, child) => Transform.translate(offset: Offset(0, _floatAnim.value), child: child),
                child: Image.asset('assets/images/hero_student.png', height: size.height * 0.38, fit: BoxFit.contain),
              )),

              // App brand top
              Positioned(top: 60, child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
                  child: Row(children: [
                    Image.asset('assets/images/roi_logo_premium.png', width: 28, height: 28),
                    const SizedBox(width: 10),
                    const Text('Rules of India', softWrap: false, style: TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 18)),
                  ]),
                ),
              ])),
            ]),
          ),
        ),

        // ── Bottom white panel (pager dots + CTAs)
        Expanded(
          flex: 45,
          child: Container(
            width: double.infinity,
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
            child: Column(children: [
              // Dot indicators (like Byju's onboarding)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _dot(active: true),
                _dot(), _dot(),
              ]),
              const SizedBox(height: 24),

              // Headline
              const Text('Learn the Constitution.\nKnow Your Rights.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary, height: 1.25),
              ),
              const SizedBox(height: 12),
              const Text(
                'AI-powered legal education for every Indian citizen. Quiz, chat, and grow.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter', fontSize: 14, height: 1.5),
              ),
              const Spacer(),

              // Sign In button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInScreen())),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Sign In', style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),

              // Sign Up button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Create Account', style: TextStyle(color: AppColors.primary, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ),

              const SizedBox(height: 16),
              const Text('⚖️ AI-Powered · Free · Made for India',
                  style: TextStyle(color: AppColors.textHint, fontSize: 12, fontFamily: 'Inter')),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _ring(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 1.5)),
  );

  Widget _dot({bool active = false}) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: active ? 24 : 8, height: 8,
    decoration: BoxDecoration(
      color: active ? AppColors.primary : AppColors.border,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
