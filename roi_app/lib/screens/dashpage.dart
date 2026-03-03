import 'package:flutter/material.dart';
import 'package:login_signup/contents/contents.dart';
import 'package:login_signup/quizeasy/contentsquize.dart';
import 'package:login_signup/quizhard/contentsquizh.dart';
import 'package:login_signup/screens/match.dart';
import 'package:login_signup/mock_parliament/role_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup/screens/ChatbotScreen.dart';
import 'package:login_signup/screens/NewsScreen.dart';
import 'package:login_signup/screens/language.dart';
import 'package:login_signup/theme/app_colors.dart';
import 'package:login_signup/widgets/falling_symbols.dart';
import 'package:login_signup/screens/legal_survival_runner.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Gamified Dashboard — Byju's style with XP, emojis, gradient cards
// ─────────────────────────────────────────────────────────────────────────────
class Dashpage extends StatefulWidget {
  const Dashpage({super.key});

  @override
  State<Dashpage> createState() => _DashpageState();
}

class _DashpageState extends State<Dashpage> with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  static const _modules = [
    _Mod(
      'Contents',
      'Articles & Chapters',
      '📜',
      Color(0xFF3B82F6), Color(0xFFEFF6FF),
      'Start reading the Constitution',
      '12 chapters',
    ),
    _Mod(
      'Easy Mode',
      'Foundation Quizzes',
      '🌟',
      Color(0xFF059669), Color(0xFFECFDF5),
      'Test basic knowledge',
      '50+ questions',
    ),
    _Mod(
      'Hard Mode',
      'Advanced Challenges',
      '🔥',
      Color(0xFFDC2626), Color(0xFFFEF2F2),
      'Challenge yourself',
      '30+ hard MCQs',
    ),
    _Mod(
      'Match Game',
      'Drag & Match Laws',
      '🎮',
      Color(0xFF7C3AED), Color(0xFFEDE9FE),
      'Interactive matching game',
      'Multiple rounds',
    ),
    _Mod(
      'Mock Parliament',
      'Debate & Roleplay',
      '🏛️',
      Color(0xFF0891B2), Color(0xFFECFEFF),
      'Simulate parliament sessions',
      'Role-based scenarios',
    ),
    _Mod(
      'Survival Runner',
      'Legal Driving Sim',
      '🚗',
      Color(0xFFF59E0B), Color(0xFFFFFBEB),
      'Dodge obstacles & learn traffic laws',
      'NEW',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Stack(children: [
            // Falling learning symbols — unique to Learning Hub
            const FallingSymbolsBackground(
              symbols: ['📚', '🎓', '🌟', '✏️', '📝', '🏆'],
              count: 14,
              opacity: 0.28,
            ),
            Column(children: [
            // Custom App Bar
            Container(
              color: Colors.white.withValues(alpha: 0.85),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Rules of India',
                            overflow: TextOverflow.visible,
                            softWrap: false,
                            style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w900, fontSize: 15)),
                        Text('AI Legal Learning',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 9)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _IconBtn(icon: Icons.smart_toy_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()))),
                const SizedBox(width: 4),
                _IconBtn(icon: Icons.newspaper_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen()))),
                const SizedBox(width: 4),
                _IconBtn(icon: Icons.logout_rounded, onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()));
                }),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Hero banner with building illustration
                  _buildHero(),

                  // Section header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: Row(children: [
                      Container(width: 4, height: 22, decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 10),
                      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Choose a Module', style: TextStyle(fontFamily: 'PlusJakartaSans', color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                        Text('Tap any card to begin learning', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
                      ]),
                    ]),
                  ),

                  // Module cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _modules.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GamifiedModuleCard(mod: e.value, index: e.key, onTap: () => _navigate(context, e.key)),
                      )).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ]),
          ]),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: child,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        height: 180,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(children: [
          // Background abstract shape
          Positioned(
            right: -30, top: -20,
            child: Container(
              width: 150, height: 150,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                child: const Text('🎓 MISSION', style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Inter', fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
              const SizedBox(height: 12),
              const Text('Your Legal Journey\nStarts Here!',
                  style: TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans', fontSize: 24, fontWeight: FontWeight.w900, height: 1.1)),
              const SizedBox(height: 14),
              Row(children: [
                _StatPill('395', 'Articles'),
                const SizedBox(width: 8),
                _StatPill('12', 'Parts'),
              ]),
            ]),
          ),
          // Clean ROI Indicator
          Positioned(
            right: 24, bottom: 24,
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text('ROI', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, fontFamily: 'PlusJakartaSans')),
              Container(width: 40, height: 3, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(2))),
            ]),
          ),
        ]),
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    final routes = [
      () => const ContentsScreen(),
      () => const Contents1(),
      () => const Contents2(),
      () => const MatchGameScreen(),
      () => const RoleSelectionScreen(),
      () => const LegalSurvivalRunnerScreen(),
    ];
    Navigator.push(context, MaterialPageRoute(builder: (_) => routes[index]()));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────────────────────────────────────
class _Mod {
  final String title, subtitle, emoji, description, badge;
  final Color color, bgColor;
  const _Mod(this.title, this.subtitle, this.emoji, this.color, this.bgColor, this.description, this.badge);
}

// ─────────────────────────────────────────────────────────────────────────────
// Gamified Module Card
// ─────────────────────────────────────────────────────────────────────────────
class _GamifiedModuleCard extends StatefulWidget {
  final _Mod mod;
  final int index;
  final VoidCallback onTap;
  const _GamifiedModuleCard({required this.mod, required this.index, required this.onTap});
  @override
  State<_GamifiedModuleCard> createState() => _GamifiedModuleCardState();
}

class _GamifiedModuleCardState extends State<_GamifiedModuleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 130), lowerBound: 0.95, upperBound: 1.0)..value = 1.0;
    _scale = _ctrl;
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final m = widget.mod;
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) { _ctrl.forward(); widget.onTap(); },
      onTapCancel: () => _ctrl.forward(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: m.color.withValues(alpha: 0.15)),
            boxShadow: [BoxShadow(color: m.color.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))],
          ),
          child: Row(children: [
            // Color accent strip + emoji
            Container(
              width: 78,
              height: 80,
              decoration: BoxDecoration(
                color: m.bgColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(m.emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: m.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text('LV ${widget.index + 1}',
                      style: TextStyle(color: m.color, fontSize: 9, fontFamily: 'Inter', fontWeight: FontWeight.w800)),
                ),
              ]),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text(m.title, 
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(m.subtitle, style: TextStyle(color: m.color, fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(m.description, style: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter', fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),

            // Right badge + arrow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: m.bgColor, borderRadius: BorderRadius.circular(10)),
                  child: Text(m.badge, style: TextStyle(color: m.color, fontSize: 9, fontFamily: 'Inter', fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(color: m.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.arrow_forward_ios_rounded, color: m.color, size: 13),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 38, height: 38,
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 18, color: AppColors.textSecondary),
    ),
  );
}

class _StatPill extends StatelessWidget {
  final String value, label;
  const _StatPill(this.value, this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
    child: Text('$value $label', style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Inter', fontWeight: FontWeight.w700)),
  );
}
