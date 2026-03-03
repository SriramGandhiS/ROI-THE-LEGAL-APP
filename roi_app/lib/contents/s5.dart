import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:login_signup/theme/app_colors.dart';

const String youtubeVideoId = '1b-b3P0E5C4';

class VideoPlayerScreenS5 extends StatefulWidget {
  const VideoPlayerScreenS5({super.key});

  @override
  _VideoPlayerScreenS5State createState() => _VideoPlayerScreenS5State();
}

class _VideoPlayerScreenS5State extends State<VideoPlayerScreenS5> with TickerProviderStateMixin {
  late YoutubePlayerController _controller;
  bool _isVideoLoaded = false;
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  void _loadVideo() {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: youtubeVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );
    setState(() {
      _isVideoLoaded = true;
    });
  }

  void _showDescriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Lesson Details', style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.bold)),
          content: const Text(
            'In this lesson, we study the 5th Schedule, which contains provisions for the administration and control of Scheduled Areas and Scheduled Tribes.',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    if (_isVideoLoaded) {
      _controller.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Custom AppBar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primary),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Take Chapter Quiz 🎯',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                      onPressed: _showDescriptionDialog,
                    ),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(children: [
                    // Floating Video Box
                    AnimatedBuilder(
                      animation: _floatAnim,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(0, _floatAnim.value),
                        child: child,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 15)),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: !_isVideoLoaded
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.network(
                                    'https://img.youtube.com/vi/$youtubeVideoId/maxresdefault.jpg',
                                    fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                                    errorBuilder: (_, __, ___) => Container(color: AppColors.primaryBg),
                                  ),
                                  Container(decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Colors.black.withOpacity(0.4), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                  )),
                                  GestureDetector(
                                    onTap: _loadVideo,
                                    child: Container(
                                      width: 75, height: 75,
                                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 20)]
                                      ),
                                      child: const Icon(Icons.play_arrow_rounded, size: 55, color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              )
                            : YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    // 50/50 Layout
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Left
                      Expanded(
                        flex: 6,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('CHAPTER OVERVIEW', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1.2)),
                          const SizedBox(height: 8),
                          const Text(
                            'The Fifth Schedule provides special administrative machinery for areas with significant Tribal populations (except for four specific States).',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary, height: 1.5, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          _buildPremiumChip(Icons.timer_rounded, '~10 Minutes'),
                        ]),
                      ),
                      const SizedBox(width: 16),
                      // Right
                      Expanded(
                        flex: 4,
                        child: Column(children: [
                          _buildStatCard('Type', 'Schedule', Icons.map_rounded),
                          const SizedBox(height: 12),
                          _buildStatCard('Level', 'Basic', Icons.auto_awesome_rounded),
                        ]),
                      ),
                    ]),

                    const SizedBox(height: 32),

                    // Key Terms section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Key Topics 💡', style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 12),
                        const Text('Scheduled Areas, Tribes, Governance', 
                          style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
                      ]),
                    ),

                    const SizedBox(height: 32),

                    // CTA
                    SizedBox(
                      width: double.infinity, height: 62,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                        ),
                        child: const Text('Take Chapter Quiz 🎯', style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
      ]),
    );
  }

  Widget _buildStatCard(String title, String val, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(children: [
        Icon(icon, size: 20, color: AppColors.primary.withOpacity(0.7)),
        const SizedBox(height: 8),
        Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'PlusJakartaSans')),
        Text(title, style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
