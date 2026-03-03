import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/screens/ChatbotScreen.dart';
import 'package:login_signup/screens/NewsScreen.dart';
import 'package:login_signup/screens/dashpage.dart';
import 'package:login_signup/screens/language.dart';
import 'package:login_signup/theme/app_colors.dart';
import 'package:login_signup/contents/pt_1.dart';
import 'package:login_signup/contents/pt_3.dart';
import 'package:login_signup/contents/pt_4.dart';
import 'package:login_signup/widgets/falling_symbols.dart';
import 'package:url_launcher/url_launcher.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Gamified Homepage — Byju's / LearnHub inspired
// ─────────────────────────────────────────────────────────────────────────────

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  int _navIndex = 0;
  late AnimationController _heroCtrl;
  late AnimationController _floatCtrl;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
    _heroFade = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _getUserData() async {
    if (user == null) return {};
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    return doc.data() ?? {};
  }

  // ──────────────────────────
  // Build
  // ──────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(children: [
          // Falling legal symbols background
          const FallingSymbolsBackground(
            symbols: ['⚖️', '📜', '🏛️', '🇮🇳', '📖', '🔏'],
            count: 14,
            opacity: 0.28,
          ),
          SafeArea(
            child: Column(children: [
              _buildTopBar(),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: FadeTransition(
                        opacity: _heroFade,
                        child: SlideTransition(
                          position: _heroSlide,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            _buildHeroBanner(),
                            _buildDailyStreakBar(),
                            _buildContinueWatching(), // New Section
                            _buildSectionTitle('📚 Explore Modules', 'Start your journey'),
                            _buildModuleGrid(),
                            _buildSectionTitle('🧠 Quick Quiz', 'Test your knowledge'),
                            _buildQuickActionRow(),
                            _buildSectionTitle('📰 Today\'s Legal News', 'Stay updated'),
                            _buildNewsTeaser(),
                            const SizedBox(height: 24),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Top App Bar
  Widget _buildTopBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(children: [
        // Logo + title
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset('assets/images/roi_logo_premium.png', width: 22, height: 22),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Rules of India',
                    overflow: TextOverflow.visible,
                    softWrap: false,
                    style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 15, fontWeight: FontWeight.w900)),
                Text('AI Legal Learning',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        const Spacer(),
        // Notification
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.notifications_outlined, size: 20, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 10),
        // Avatar — transparent bg with ring
        GestureDetector(
          onTap: _showProfile,
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Center(child: Text(
              (user?.displayName ?? user?.email ?? '?')[0].toUpperCase(),
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 15),
            )),
          ),
        ),
      ]),
    );
  }

  // ── Hero Banner with cartoon illustration + gradient text
  Widget _buildHeroBanner() {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 600;
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        height: 250,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)], // Modern Violet/Indigo
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.3),
              blurRadius: 20, offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(children: [
          // Background accents
          Positioned(right: -20, top: -20, child: _circle(120, Colors.white.withValues(alpha: 0.1))),
          Positioned(left: 40, bottom: -30, child: _circle(80, Colors.white.withValues(alpha: 0.05))),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                      child: const Text('🌟 WELCOME BACK', style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Inter', fontWeight: FontWeight.w800, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 8),
              const Text('Rules of India',
                  style: TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans', fontSize: 24, fontWeight: FontWeight.w900, height: 1.1)),
              const Text('AI Legal Hub 🇮🇳',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Inter', fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashpage())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                        ),
                        child: const Text('Start Learning →',
                            style: TextStyle(color: Color(0xFF6366F1), fontFamily: 'Inter', fontWeight: FontWeight.w800, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isWide) ...[
                const SizedBox(width: 10),
                const _StudentHeroWidget(),
              ] else ...[
                const Expanded(child: Center(child: _StudentHeroWidget())),
              ],
            ]),
          ),
        ]),
      );
    });
  }

  Widget _circle(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );

  // ── Daily Streak / XP bar
  Widget _buildDailyStreakBar() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};
        final quizzes = (data['totalQuizzesCompleted'] as int?) ?? 0;
        final xp = quizzes * 10;
        final level = quizzes < 10 ? 'Beginner' : quizzes < 30 ? 'Scholar' : 'Expert';
        final progress = (quizzes % 10) / 10.0;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(children: [
            // Trophy
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
              ),
              child: const Center(child: Text('🏆', style: TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                  child: Text(level, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 14)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.accentLight.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
                  child: Text('$xp XP', style: const TextStyle(color: AppColors.accent, fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 11)),
                ),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress, minHeight: 8,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 4),
              Text('$quizzes quizzes completed · Keep it up! 🔥',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontFamily: 'Inter')),
            ])),
          ]),
        );
      },
    );
  }

  Widget _buildContinueWatching() {
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('video_progress')
          .orderBy('lastUpdated', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final doc = snapshot.data!.docs.first;
        final data = doc.data() as Map<String, dynamic>;
        final pos = data['position'] ?? 0;
        final dur = data['duration'] ?? 1;
        final progress = pos / dur;
        final title = data['title'] ?? 'Resume Learning';
        final videoId = data['videoId'];

        // Don't show if almost finished
        if (progress > 0.98) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('CONTINUE WATCHING', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                  Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'PlusJakartaSans')),
                ]),
              ),
              IconButton(
                onPressed: () {
                  // Navigation logic mapping
                  Widget target;
                  if (videoId == 'pt_1') target = const VideoPlayerScreen1();
                  else if (videoId == 'pt_3') target = const VideoPlayerScreen3();
                  else if (videoId == 'pt_4') target = const VideoPlayerScreen4();
                  else return;

                  Navigator.push(context, MaterialPageRoute(builder: (_) => target));
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
              ),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ]),
        );
      },
    );
  }

  // ── Section title
  Widget _buildSectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
        ]),
      ]),
    );
  }

  Widget _buildModuleGrid() {
    final modules = [
      _ModInfo('Fundamental\nRights', '🏛️', const Color(0xFF6C3AED), const Color(0xFFEDE9FE)),
      _ModInfo('Criminal\nLaw (IPC)', '⚖️', const Color(0xFF059669), const Color(0xFFECFDF5)),
      _ModInfo('Constitution\nArticles', '📜', const Color(0xFF3B82F6), const Color(0xFFEFF6FF)),
      _ModInfo('Civic\nDuties', '🤝', const Color(0xFFF59E0B), const Color(0xFFFFFBEB)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        final cols = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          crossAxisCount: cols,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: cols == 4 ? 1.1 : 1.1,
          children: modules.map((m) => _ModuleCard(mod: m, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashpage())))).toList(),
        );
      }),
    );
  }

  // ── Quick action row (quiz + news)
  Widget _buildQuickActionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // Daily Quiz → Dashpage
          Expanded(child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashpage())),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: const Color(0xFF059669).withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 5))],
              ),
              child: Row(children: [
                const Text('🧠', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Daily Quiz', style: TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 14)),
                  Text('Level up your XP', style: TextStyle(color: Colors.white70, fontFamily: 'Inter', fontSize: 11)),
                ])),
              ]),
            ),
          )),
          const SizedBox(width: 12),
          // Legal News → NewsScreen
          Expanded(child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen())),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFDC2626), Color(0xFFEA580C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: const Color(0xFFDC2626).withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 5))],
              ),
              child: Row(children: [
                const Text('📰', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Legal News', style: TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 14)),
                  Text('Stay informed', style: TextStyle(color: Colors.white70, fontFamily: 'Inter', fontSize: 11)),
                ])),
              ]),
            ),
          )),
        ]),
      ),
    );
  }

  // ── News teaser
  Widget _buildNewsTeaser() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen())),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.newspaper_rounded, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 14),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Parliament & Law Updates', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w700, fontSize: 14)),
              SizedBox(height: 4),
              Text('Tap to read today\'s civic news and legal updates from India', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter', height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textHint, size: 14),
          ]),
        ),
      ),
    );
  }

  // ── Bottom nav
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -3))],
      ),
      child: BottomNavigationBar(
        currentIndex: _navIndex,
        elevation: 0, backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.primary, unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_rounded), label: 'AI Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper_rounded), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashpage()));
          if (i == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
          if (i == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen()));
          if (i == 4) _showProfile();
        },
      ),
    );
  }

  void _showProfile() async {
    final data = await _getUserData();
    final q = (data['totalQuizzesCompleted'] as int?) ?? 0;
    final xp = q * 10;
    final level = q < 10 ? 'Beginner' : q < 30 ? 'Scholar' : 'Expert';
    final levelEmoji = q < 10 ? '🌱' : q < 30 ? '📚' : '🏆';
    final progress = (q % 10) / 10.0;
    final nextLevel = q < 10 ? 'Scholar' : q < 30 ? 'Expert' : 'Master';
    final createdAt = user?.metadata.creationTime;
    final joinedStr = createdAt != null
        ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
        : 'N/A';
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (__, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
          ),
          child: Column(children: [
            // Handle
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 4),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // ── Header: Avatar + Name + Email
                  Center(
                    child: Column(children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                        ),
                        child: Center(child: Text(
                          (user?.displayName ?? user?.email ?? '?')[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32),
                        )),
                      ),
                      const SizedBox(height: 12),
                      Text(data['username'] ?? user?.displayName ?? 'User',
                          style: const TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 22, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(user?.email ?? '',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter')),
                      const SizedBox(height: 6),
                      Text('Joined: $joinedStr',
                          style: const TextStyle(color: AppColors.textHint, fontSize: 12, fontFamily: 'Inter')),
                    ]),
                  ),

                  const SizedBox(height: 20),

                  // ── Level + XP card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('$levelEmoji  $level', style: const TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 18)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                          child: Text('$xp XP', style: const TextStyle(color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress, minHeight: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('${(progress * 100).toInt()}% to $nextLevel',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11, fontFamily: 'Inter')),
                    ]),
                  ),

                  const SizedBox(height: 16),

                  // ── Stats Row
                  Row(children: [
                    _statCard('🎯', '$q', 'Quizzes'),
                    const SizedBox(width: 10),
                    _statCard('⚡', '$xp', 'XP Earned'),
                    const SizedBox(width: 10),
                    _statCard('🏅', level, 'Rank'),
                  ]),

                  const SizedBox(height: 20),

                  // ── Section Label
                  const Text('Account', style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),

                  // ── Options List
                  _profileOption(Icons.emoji_events_rounded, '🏆 Achievements', 'View your badges and milestones', const Color(0xFFF59E0B), () => _showAchievementsDialog(data)),
                  _profileOption(Icons.bar_chart_rounded, '📊 My Progress', 'Quiz history and learning stats', const Color(0xFF6366F1), () => _showProgressDialog(data)),
                  _profileOption(Icons.settings_rounded, '⚙️ Settings', 'Language, notifications, theme', AppColors.textSecondary, () {}),
                  _profileOption(Icons.help_outline_rounded, '❓ Help & Support', 'Contact us for assistance', AppColors.textSecondary, _showCustomerSupport),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 8),

                  // ── Sign Out
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.pop(_);
                        await FirebaseAuth.instance.signOut();
                        if (mounted) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()));
                        }
                      },
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Sign Out', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _statCard(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary)),
          Text(label, style: const TextStyle(color: AppColors.textHint, fontSize: 10, fontFamily: 'Inter')),
        ]),
      ),
    );
  }

  Widget _profileOption(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
            Text(subtitle, style: const TextStyle(color: AppColors.textHint, fontSize: 11, fontFamily: 'Inter')),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textHint),
        ]),
      ),
    );
  }

  void _showCustomerSupport() {
    const email = 'sivasaran8667@gmail.com';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Customer Support', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans')),
        content: RichText(text: TextSpan(
          style: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'),
          children: [
            const TextSpan(text: 'Contact us at:\n'),
            TextSpan(text: email, style: const TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse('mailto:$email'))),
          ],
        )),
        actions: [TextButton(onPressed: () => Navigator.pop(_), child: const Text('Close'))],
      ),
    );
  }

  void _showAchievementsDialog(Map<String, dynamic> data) {
    final achievements = List.from(data['achievements'] ?? []);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('My Achievements 🏆', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans')),
        content: achievements.isEmpty
            ? const Text('Keep learning to earn badges!', style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'))
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final a = achievements[index];
                    return ListTile(
                      leading: Text(a['emoji'] ?? '🏅', style: const TextStyle(fontSize: 24)),
                      title: Text(a['title'] ?? 'Achievement', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'PlusJakartaSans')),
                      subtitle: Text('Earned on: ${a['date']?.split('T')[0] ?? 'N/A'}', style: const TextStyle(fontSize: 10, fontFamily: 'Inter')),
                    );
                  },
                ),
              ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  void _showProgressDialog(Map<String, dynamic> data) {
    final history = List.from(data['quizHistory'] ?? []).reversed.toList();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('My Progress 📊', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans')),
        content: history.isEmpty
            ? const Text('No quiz history yet. Start learning!', style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'))
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: history.length > 5 ? 5 : history.length,
                  itemBuilder: (context, index) {
                    final h = history[index];
                    return ListTile(
                      dense: true,
                      title: Text(h['chapter'] ?? 'Quiz', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'PlusJakartaSans')),
                      subtitle: Text('Score: ${h['score']}/${h['total']}', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      trailing: const Text('Recently', style: TextStyle(fontSize: 10)),
                    );
                  },
                ),
              ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Colorful Module Card (Byju's subject card style)
// ─────────────────────────────────────────────────────────────────────────────
class _ModInfo {
  final String title, emoji;
  final Color color, bgColor;
  const _ModInfo(this.title, this.emoji, this.color, this.bgColor);
}

class _ModuleCard extends StatefulWidget {
  final _ModInfo mod;
  final VoidCallback onTap;
  const _ModuleCard({required this.mod, required this.onTap});
  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120), lowerBound: 0.92, upperBound: 1.0)..value = 1.0;
    _scaleAnim = _pressCtrl;
  }

  @override
  void dispose() { _pressCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final m = widget.mod;
    return GestureDetector(
      onTapDown: (_) => _pressCtrl.reverse(),
      onTapUp: (_) { _pressCtrl.forward(); widget.onTap(); },
      onTapCancel: () => _pressCtrl.forward(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: m.bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: m.color.withValues(alpha: 0.2)),
            boxShadow: [BoxShadow(color: m.color.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.emoji, style: const TextStyle(fontSize: 26)),
            const Spacer(),
            Text(m.title, style: TextStyle(color: m.color, fontSize: 12, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, height: 1.2)),
            const SizedBox(height: 4),
            Row(children: [
              Icon(Icons.play_circle_filled_rounded, color: m.color, size: 13),
              const SizedBox(width: 3),
              Flexible(child: Text('Explore', style: TextStyle(color: m.color.withValues(alpha: 0.7), fontSize: 10, fontFamily: 'Inter', fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
            ]),
          ]),
        ),
      ),
    );
  }
}

// Student Hero Widget — emoji, fully transparent (no white box possible)  
class _StudentHeroWidget extends StatelessWidget {
  const _StudentHeroWidget();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          String.fromCharCode(0x1F9D1) + String.fromCharCode(0x200D) + String.fromCharCode(0x1F393),
          style: TextStyle(
            fontSize: 72,
            shadows: [
              Shadow(color: Colors.white.withValues(alpha: 0.7), blurRadius: 18),
              Shadow(color: Colors.white.withValues(alpha: 0.3), blurRadius: 36),
            ],
          ),
        ),
        Text(
          String.fromCharCode(0x1F4DA) + String.fromCharCode(0x1F4D6) + String.fromCharCode(0x1F4D5),
          style: TextStyle(
            fontSize: 30,
            shadows: [
              Shadow(color: Colors.white.withValues(alpha: 0.5), blurRadius: 12),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
