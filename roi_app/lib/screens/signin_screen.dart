import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_signup/screens/forget_passsword_screen.dart';
import 'package:login_signup/screens/signup_screen.dart';
import 'package:login_signup/screens/wrapper.dart';
import 'package:login_signup/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Animated Sign-In — Premium Light Theme with floating legal symbols
// ─────────────────────────────────────────────────────────────────────────────

// ── Legal Symbol Particle
class _LegalParticle {
  final String symbol;
  final double x;        // 0..1 (relative screen width)
  final double y;        // starting y (can be above screen)
  final double size;
  final double speed;
  final double opacity;
  final double rotation;
  final double rotationSpeed;
  final Color color;

  _LegalParticle({
    required this.symbol,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
  });
}

class _ParticleSystem extends StatefulWidget {
  const _ParticleSystem();
  @override
  State<_ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<_ParticleSystem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final _rng = Random();
  late List<_LegalParticle> _particles;

  static const _symbols = ['⚖️', '📜', '🏛️', '⚔️', '🔏', '📋', '🗝️', '🪪', '⚖', '§', '¶', '🔖'];
  static const _colors = [
    Color(0xFF6C3AED),
    Color(0xFF8B5CF6),
    Color(0xFF4F46E5),
    Color(0xFFF59E0B),
    Color(0xFF059669),
    Color(0xFF7C3AED),
    Color(0xFF3B82F6),
  ];

  @override
  void initState() {
    super.initState();
    _particles = List.generate(22, (_) => _mkParticle(_rng.nextDouble()));
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(_tick)
      ..repeat();
  }

  _LegalParticle _mkParticle(double startFraction) => _LegalParticle(
        symbol: _symbols[_rng.nextInt(_symbols.length)],
        x: _rng.nextDouble(),
        y: startFraction * 1.4 - 0.2,  // spread them from -0.2 to 1.2
        size: 16 + _rng.nextDouble() * 26,
        speed: 0.00008 + _rng.nextDouble() * 0.00014,
        opacity: 0.08 + _rng.nextDouble() * 0.22,
        rotation: _rng.nextDouble() * pi * 2,
        rotationSpeed: (_rng.nextDouble() - 0.5) * 0.006,
        color: _colors[_rng.nextInt(_colors.length)],
      );

  void _tick() {
    if (!mounted) return;
    setState(() {
      for (int i = 0; i < _particles.length; i++) {
        final p = _particles[i];
        final newY = p.y + p.speed;
        if (newY > 1.15) {
          _particles[i] = _mkParticle(-0.15);
        } else {
          _particles[i] = _LegalParticle(
            symbol: p.symbol,
            x: p.x,
            y: newY,
            size: p.size,
            speed: p.speed,
            opacity: p.opacity,
            rotation: p.rotation + p.rotationSpeed,
            rotationSpeed: p.rotationSpeed,
            color: p.color,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      return Stack(
        children: _particles.map((p) {
          return Positioned(
            left: p.x * box.maxWidth,
            top: p.y * box.maxHeight,
            child: Transform.rotate(
              angle: p.rotation,
              child: Opacity(
                opacity: p.opacity,
                child: Text(
                  p.symbol,
                  style: TextStyle(
                    fontSize: p.size,
                    color: p.symbol.length == 1 ? p.color : null,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sign-In Screen
// ─────────────────────────────────────────────────────────────────────────────

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isloading = false;
  String errorMessage = '';
  final _formSignInKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // Entrance animations
  late AnimationController _entranceCtrl;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late Animation<double> _logoScale;

  // Shimmer pulse for the button
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));
    _fadeIn = CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.2, 1.0, curve: Curves.easeOut));
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic)));
    _logoScale = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)));

    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _shimmerAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    _entranceCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formSignInKey.currentState!.validate()) return;
    setState(() { isloading = true; errorMessage = ''; });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text);
    } on FirebaseAuthException catch (e) {
      String msg = 'Login failed';
      if (e.code == 'user-not-found') msg = 'Email not found. Please sign up first.';
      else if (e.code == 'wrong-password') msg = 'Wrong password. Please try again.';
      else if (e.code == 'invalid-email') msg = 'Invalid email address.';
      else if (e.code == 'user-disabled') msg = 'This account has been disabled.';
      setState(() { errorMessage = msg; });
    } catch (e) {
      setState(() { errorMessage = 'An error occurred: $e'; });
    }
    setState(() { isloading = false; });
  }

  Future<void> _googleSignIn() async {
    setState(() { isloading = true; errorMessage = ''; });
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        setState(() { isloading = false; });
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential);
      if (cred.user != null) Get.offAll(() => const Wrapper());
    } catch (e) {
      setState(() { errorMessage = 'Google Sign-In failed: $e'; });
    }
    setState(() { isloading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // ── 1. Background gradient (light lavender)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF5F0FF),
                  Color(0xFFEEE8FD),
                  Color(0xFFF8F6FF),
                  Color(0xFFFFFFFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.3, 0.65, 1.0],
              ),
            ),
          ),

          // ── 2. Soft radial glow accents
          Positioned(
            top: -size.height * 0.12,
            left: -size.width * 0.15,
            child: Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -size.height * 0.1,
            right: -size.width * 0.1,
            child: Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFF59E0B).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── 3. Floating legal symbols
          const Positioned.fill(child: _ParticleSystem()),

          // ── 4. Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Logo entrance
                      ScaleTransition(
                        scale: _logoScale,
                        child: FadeTransition(
                          opacity: _fadeIn,
                          child: _buildLogo(),
                        ),
                      ),

                      const SizedBox(height: 36),

                      // ── Card entrance
                      FadeTransition(
                        opacity: _fadeIn,
                        child: SlideTransition(
                          position: _slideUp,
                          child: _buildCard(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(children: [
      // Glowing logo container
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF6C3AED), Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.45), blurRadius: 30, offset: const Offset(0, 12)),
            BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 60, spreadRadius: 10),
          ],
        ),
        child: Image.asset('assets/images/roi_logo_premium.png', width: 64, height: 64, filterQuality: FilterQuality.high),
      ),
      const SizedBox(height: 18),
      ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (b) => const LinearGradient(
          colors: [Color(0xFF6C3AED), Color(0xFF4F46E5)],
        ).createShader(b),
        child: const Text(
          'Rules of India',
          softWrap: false,
          style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: const Text(
          '⚖️  AI-POWERED LEGAL LEARNING PLATFORM',
          style: TextStyle(color: AppColors.primary, fontSize: 10, fontFamily: 'Inter', fontWeight: FontWeight.w700, letterSpacing: 1.2),
        ),
      ),
    ]);
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        // Glassmorphic light card
        color: Colors.white.withOpacity(0.80),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 40, offset: const Offset(0, 16)),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Form(
        key: _formSignInKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text('Welcome back 👋',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800, fontFamily: 'PlusJakartaSans')),
            const SizedBox(height: 6),
            const Text('Sign in to access your constitutional journey',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter', height: 1.4)),

            const SizedBox(height: 30),

            // Email field
            _buildFieldLabel('Email'),
            const SizedBox(height: 6),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your email';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Invalid email';
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'you@example.com',
                prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
              ),
            ),

            const SizedBox(height: 18),

            // Password field
            _buildFieldLabel('Password'),
            const SizedBox(height: 6),
            TextFormField(
              controller: password,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _signIn(),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your password';
                return null;
              },
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    color: AppColors.textHint, size: 20,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.to(() => const ForgetPasswordScreen()),
                child: const Text('Forgot password?',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primary)),
              ),
            ),

            // Error
            if (errorMessage.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Text(errorMessage, textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error, fontSize: 13, fontFamily: 'Inter')),
              ),
              const SizedBox(height: 14),
            ],

            // ── Animated Sign-In Button
            if (isloading)
              const Center(child: CircularProgressIndicator(color: AppColors.primary))
            else
              AnimatedBuilder(
                animation: _shimmerAnim,
                builder: (_, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6C3AED),
                          Color.lerp(const Color(0xFF6C3AED), const Color(0xFF8B5CF6), _shimmerAnim.value)!,
                          const Color(0xFF4F46E5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3 + _shimmerAnim.value * 0.2),
                          blurRadius: 16 + _shimmerAnim.value * 8,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
                child: ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Sign In  ⚖️',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'PlusJakartaSans', color: Colors.white)),
                ),
              ),

            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 20),

            // ── Google button (transparent glass style)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: OutlinedButton.icon(
                onPressed: _googleSignIn,
                icon: const Icon(Icons.g_mobiledata_rounded, size: 26, color: Color(0xFF4285F4)),
                label: const Text('Continue with Google',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary, fontFamily: 'Inter')),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),

            const SizedBox(height: 28),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('New to ROI? ', style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontFamily: 'Inter')),
              GestureDetector(
                onTap: () => Get.to(() => const SignUpScreen()),
                child: const Text('Create Account',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14, fontFamily: 'Inter')),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) => Text(label,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter'));

  Widget _buildDivider() => Row(children: [
    const Expanded(child: Divider(color: AppColors.border)),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text('OR', style: TextStyle(color: AppColors.textHint, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
    ),
    const Expanded(child: Divider(color: AppColors.border)),
  ]);
}
