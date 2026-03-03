import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackScreen extends StatefulWidget {
  final String billId;
  final String voteChoice;

  const FeedbackScreen({super.key, required this.billId, required this.voteChoice});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
          ..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('bills').doc(widget.billId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Bill not found',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          );
        }

        final data = snapshot.data!.data()!;
        final title = data['title'] ?? 'Untitled Bill';
        final votesFor = data['votesFor'] ?? 0;
        final votesAgainst = data['votesAgainst'] ?? 0;
        final passed = votesFor > votesAgainst;
        final totalVotes = (votesFor + votesAgainst).toDouble().clamp(1, double.infinity);

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEDE9FE), Color(0xFFF5F3FF), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context, title),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeController,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 24, offset: const Offset(0, 12)),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildStatusBadge(passed),
                                const SizedBox(height: 24),
                                Text(passed ? "The House has\nPassed this Bill" : "The House has\nRejected this Bill",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'PlusJakartaSans', height: 1.1, color: Color(0xFF1F2937)),
                                ),
                                const SizedBox(height: 32),
                                _buildResultBar(votesFor, votesAgainst, totalVotes),
                                const SizedBox(height: 32),
                                _buildVoteSummary(passed),
                                const SizedBox(height: 48),
                                _buildReturnButton(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
      child: Row(
        children: [
          IconButton(
            icon: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF8B5CF6)),
            ),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(title, 
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1F2937))),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool passed) {
    final color = passed ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(passed ? Icons.verified_rounded : Icons.cancel_rounded, color: color, size: 16),
          const SizedBox(width: 8),
          Text(passed ? 'PASSED' : 'REJECTED', 
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        ],
      ),
    );
  }

  Widget _buildResultBar(int votesFor, int votesAgainst, double total) {
    final ratio = votesFor / total;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('VOTE DISTRIBUTION', style: TextStyle(color: Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w800)),
            Text('${(ratio * 100).toInt()}% Support', style: const TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 12,
            width: double.infinity,
            color: const Color(0xFFF3F4F6),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF34D399), Color(0xFF10B981)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildVotePill('$votesFor Yays', const Color(0xFF10B981)),
            const SizedBox(width: 12),
            _buildVotePill('$votesAgainst Nays', const Color(0xFFEF4444)),
          ],
        ),
      ],
    );
  }

  Widget _buildVotePill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.1))),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildVoteSummary(bool passed) {
    final aligned = (widget.voteChoice == 'for' && passed) || (widget.voteChoice == 'against' && !passed);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Text(aligned ? '🎯' : '💡', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              aligned ? 'Your vote aligned with the majority. Well done!' : 'The house decided differently this time.',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4B5563), height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        child: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
