import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup/screens/hindi/ChatbotScreenHindi.dart';
import 'package:login_signup/screens/hindi/dashpageHindi.dart';
import 'package:login_signup/screens/language.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:login_signup/theme/app_colors.dart';

class HomepageScreenHindi extends StatefulWidget {
  const HomepageScreenHindi({super.key});

  @override
  State<HomepageScreenHindi> createState() => _HomepageScreenHindiState();
}

class _HomepageScreenHindiState extends State<HomepageScreenHindi>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;

  late AnimationController _centerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();

    _centerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(parent: _centerController, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _centerController, curve: Curves.easeOutCubic));

    _centerController.forward();
  }

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      final totalQuizzesCompleted = userDoc.data()?['totalQuizzesCompleted'] ?? 0;
      return {
        'username': userDoc.data()?['username'],
        'email': user!.email,
        'totalQuizzesCompleted': totalQuizzesCompleted,
      };
    }
    return {'username': null, 'email': null, 'totalQuizzesCompleted': 0};
  }

  void _showUserInfo() async {
    Map<String, dynamic> userInfo = await _getUserInfo();
    final totalQuizzesCompleted = userInfo['totalQuizzesCompleted'] as int;

    String level;
    Color progressColor;
    if (totalQuizzesCompleted < 20) {
      level = 'शुरुआती';
      progressColor = AppColors.error;
    } else if (totalQuizzesCompleted < 50) {
      level = 'मध्यम';
      progressColor = AppColors.warning;
    } else {
      level = 'प्रो';
      progressColor = AppColors.success;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primaryBg,
                  child: Text(
                    userInfo['username']?[0].toUpperCase() ?? '?',
                    style: const TextStyle(fontSize: 28, color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Text(userInfo['username'] ?? 'नाम उपलब्ध नहीं',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(userInfo['email'] ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: progressColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: progressColor.withOpacity(0.4)),
                  ),
                  child: Text('स्तर: $level',
                      style: TextStyle(color: progressColor, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (totalQuizzesCompleted / 50).clamp(0.0, 1.0),
                    color: progressColor, backgroundColor: AppColors.border, minHeight: 8,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('बंद करें'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCustomerSupport() {
    const email = 'sivasaran8667@gmail.com';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('ग्राहक सहायता',
            style: TextStyle(color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans')),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'),
            children: [
              const TextSpan(text: 'किसी भी प्रश्न के लिए संपर्क करें:\n'),
              TextSpan(
                text: email,
                style: const TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(Uri.parse('mailto:$email')),
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('बंद करें'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          // App Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AppColors.surface,
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const LanguageSelectionScreen())),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(12)),
                    child: Image.asset('assets/images/roi_logo_premium.png', width: 28, height: 28),
                  ),
                  const SizedBox(width: 10),
                  const Text('भारत का अधिकार', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                ]),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary, size: 22),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashpagehindi())),
              ),
              GestureDetector(
                onTap: _showUserInfo,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryBg,
                  child: Text(
                    (user?.displayName ?? user?.email ?? '?')[0].toUpperCase(),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
            ]),
          ),

          // Hero
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(children: [
                    // Hero banner
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                          child: const Text('⚖️ कानूनी शिक्षा + AI सहायक',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        ),
                        const SizedBox(height: 16),
                        const Text('संविधान सीखें।',
                            style: TextStyle(fontFamily: 'PlusJakartaSans', color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, height: 1.15)),
                        const SizedBox(height: 10),
                        Text('अपने अधिकार जानें। कानून समझें।',
                            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14, fontFamily: 'Inter', height: 1.5)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashpagehindi())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('शुरू करें →', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        ),
                      ]),
                    ),

                    // Stats
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        _StatItem(value: '395', label: 'अनुच्छेद', color: AppColors.primary),
                        Container(width: 1, height: 36, color: AppColors.border),
                        _StatItem(value: '12', label: 'अनुसूचियाँ', color: AppColors.accent),
                        Container(width: 1, height: 36, color: AppColors.border),
                        _StatItem(value: '25+', label: 'भाग', color: AppColors.success),
                      ]),
                    ),
                    const SizedBox(height: 28),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          elevation: 0, backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primary, unselectedItemColor: AppColors.textHint,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'होम'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'सीखें'),
            BottomNavigationBarItem(icon: Icon(Icons.smart_toy_rounded), label: 'AI चैट'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'प्रोफ़ाइल'),
          ],
          onTap: (index) {
            setState(() => _currentNavIndex = index);
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashpagehindi()));
            } else if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreenHindi()));
            } else if (index == 3) {
              _showUserInfo();
            }
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showCustomerSupport,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.support_agent_rounded, color: Colors.white),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatItem({required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'PlusJakartaSans')),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
  ]);
}
