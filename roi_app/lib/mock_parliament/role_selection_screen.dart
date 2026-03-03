import 'package:flutter/material.dart';
import 'package:login_signup/theme/app_colors.dart';
import 'create_bill_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mock Parliament — Role Selection (Light Theme)
// ─────────────────────────────────────────────────────────────────────────────

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  final _roles = [
    const _RoleInfo(
      title: 'Member of Parliament (MP)',
      description: 'Propose new laws & debate in the House!',
      emoji: '🗳️',
      icon: Icons.how_to_vote_rounded,
      color: AppColors.primary,
      bgColor: AppColors.primaryBg,
    ),
    const _RoleInfo(
      title: 'Minister',
      description: 'Defend policies & convince the Parliament!',
      emoji: '🏛️',
      icon: Icons.account_balance_rounded,
      color: Color(0xFFEA580C),
      bgColor: Color(0xFFFFF7ED),
    ),
    const _RoleInfo(
      title: 'Speaker',
      description: 'Moderate debates & maintain order!',
      emoji: '🎙️',
      icon: Icons.record_voice_over_rounded,
      color: Color(0xFF8B5CF6),
      bgColor: Color(0xFFF5F3FF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const kBg1 = Color(0xFFF5F3FF); // light violet
    const kBg2 = Color(0xFFEDE9FE);
    const kViolet = Color(0xFF8B5CF6);
    const kViolet2 = Color(0xFF7C3AED);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kBg1, kBg2, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            // ── Premium App Bar
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 0),
              child: Row(children: [
                IconButton(
                  icon: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: kViolet),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 4),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (b) => const LinearGradient(colors: [kViolet, kViolet2]).createShader(b),
                  child: const Text('Mock Parliament', style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w900, fontSize: 20)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: kViolet.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                  child: const Text('🌟 Civic Sim', style: TextStyle(color: kViolet, fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 11)),
                ),
              ]),
            ),

            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(children: [
                      // ── Premium Hero Banner
                      AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (_, child) => Transform.scale(scale: _pulseAnim.value, child: child),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kViolet, kViolet2, Color(0xFF6366F1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: kViolet.withValues(alpha: 0.3),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(children: [
                            const Text('🏛️', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            const Text('Choose Your Role',
                                style: TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans',
                                    fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -0.5)),
                            const SizedBox(height: 8),
                            Text('Step into India\'s Parliament and shape the nation\'s future',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontFamily: 'Inter', fontSize: 13, height: 1.4, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Role cards
                      ..._roles.asMap().entries.map((entry) {
                        final i = entry.key;
                        final role = entry.value;
                        final delay = i * 0.15;
                        return AnimatedBuilder(
                          animation: _entranceCtrl,
                          builder: (_, child) {
                            final t = (((_entranceCtrl.value - delay) / (1 - delay)).clamp(0.0, 1.0));
                            return Transform.translate(
                              offset: Offset(0, 30 * (1 - t)),
                              child: Opacity(opacity: t, child: child),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _RoleCard(role: role, onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => CreateBillScreen(role: role.title)));
                            }),
                          ),
                        );
                      }),

                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(children: [
                          Text('💡', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 12),
                          Expanded(child: Text(
                            'Each role comes with unique powers to shape laws, debate policies, and serve the nation!',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter', height: 1.4),
                          )),
                        ]),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ── Role Info Model
class _RoleInfo {
  final String title, description, emoji;
  final IconData icon;
  final Color color, bgColor;
  const _RoleInfo({
    required this.title, required this.description, required this.emoji,
    required this.icon, required this.color, required this.bgColor,
  });
}

// ── Role Card Widget
class _RoleCard extends StatefulWidget {
  final _RoleInfo role;
  final VoidCallback onTap;
  const _RoleCard({required this.role, required this.onTap});
  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _elevation;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _elevation = Tween<double>(begin: 0.0, end: 1.0).animate(_hoverCtrl);
  }

  @override
  void dispose() { _hoverCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final r = widget.role;
    return MouseRegion(
      onEnter: (_) => _hoverCtrl.forward(),
      onExit: (_) => _hoverCtrl.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _hoverCtrl.forward(),
        onTapCancel: () => _hoverCtrl.reverse(),
        child: AnimatedBuilder(
          animation: _elevation,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, -3 * _elevation.value),
            child: child,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: r.color.withValues(alpha: 0.2), width: 1.5),
              boxShadow: [
                BoxShadow(color: r.color.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 6)),
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(children: [
              // Left icon container
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: r.bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: r.color.withValues(alpha: 0.2)),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(r.emoji, style: const TextStyle(fontSize: 24)),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                    color: r.color, fontFamily: 'PlusJakartaSans')),
                const SizedBox(height: 4),
                Text(r.description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary,
                    fontFamily: 'Inter', height: 1.4)),
              ])),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: r.bgColor, borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.arrow_forward_ios_rounded, color: r.color, size: 14),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
