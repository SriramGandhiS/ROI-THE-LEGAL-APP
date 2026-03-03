import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:login_signup/screens/hindi/contents/contentsHindi.dart';
import 'package:login_signup/screens/hindi/matchhindi.dart';
import 'package:login_signup/screens/hindi/quizeasyhindi/contentsquizehindi.dart';
import 'package:login_signup/screens/hindi/quizhardhindi/contentshardhindi.dart';
import 'package:login_signup/theme/app_colors.dart';

class Dashpagehindi extends StatelessWidget {
  const Dashpagehindi({super.key});

  static const _modules = [
    _Mod('सामग्री',       'अनुच्छेद और अध्याय',    Icons.menu_book_rounded,             Color(0xFF3B82F6)),
    _Mod('आसान मोड',     'बुनियादी प्रश्नोत्तरी',   Icons.lightbulb_outline_rounded,     Color(0xFF059669)),
    _Mod('कठिन मोड',     'उन्नत चुनौतियाँ',         Icons.local_fire_department_rounded, Color(0xFFDC2626)),
    _Mod('मैच गेम',      'खींचें और मिलाएँ',        Icons.extension_rounded,             Color(0xFF7C3AED)),
  ];

  static const _slides = [
    '"कर लगाने की शक्ति नष्ट करने की शक्ति है।" - जॉन मार्शल',
    '"कहीं भी अन्याय हर जगह न्याय के लिए खतरा है।" - मार्टिन लूथर किंग',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('सीखने का केंद्र',
            style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: const Text('एप के बारे में', style: TextStyle(fontFamily: 'PlusJakartaSans', color: AppColors.textPrimary)),
                content: const Text('यह ऐप आपको भारतीय संविधान को मज़ेदार क्विज़ और मॉड्यूल के माध्यम से सीखने में मदद करता है।',
                    style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter')),
                actions: [TextButton(onPressed: () => Navigator.pop(_), child: const Text('ठीक है'))],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Quote swiper
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 120,
              decoration: BoxDecoration(gradient: AppColors.heroGradient),
              child: Swiper(
                autoplay: true,
                itemCount: _slides.length,
                itemBuilder: (context, index) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(_slides[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontStyle: FontStyle.italic, fontFamily: 'Inter', height: 1.4)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section title
          Row(children: [
            Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 10),
            const Text('सीखने के मॉड्यूल',
                style: TextStyle(fontFamily: 'PlusJakartaSans', color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text('एक मॉड्यूल चुनें और शुरू करें',
                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13)),
          ),
          const SizedBox(height: 16),

          // Module cards
          ..._modules.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ModuleCard(mod: e.value, onTap: () => _destinations(context)[e.key]()),
          )),
        ]),
      ),
    );
  }

  List<VoidCallback> _destinations(BuildContext context) => [
    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Contentshindi())),
    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Contents1hindi())),
    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Contents2hindi())),
    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchGameScreenHindi())),
  ];
}

class _Mod {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  const _Mod(this.title, this.subtitle, this.icon, this.color);
}

class _ModuleCard extends StatefulWidget {
  final _Mod mod;
  final VoidCallback onTap;
  const _ModuleCard({required this.mod, required this.onTap});
  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _hovered = false, _pressed = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.mod;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _hovered ? m.color.withOpacity(0.4) : AppColors.border, width: _hovered ? 1.5 : 1),
              boxShadow: [BoxShadow(color: _hovered ? m.color.withOpacity(0.12) : Colors.black.withOpacity(0.03), blurRadius: _hovered ? 16 : 6, offset: const Offset(0, 3))],
            ),
            child: Row(children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: m.color.withOpacity(_hovered ? 0.15 : 0.08), borderRadius: BorderRadius.circular(14)),
                child: Icon(m.icon, color: m.color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(m.subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
              ])),
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: m.color.withOpacity(_hovered ? 0.15 : 0.06), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.arrow_forward_ios_rounded, color: m.color, size: 14),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
