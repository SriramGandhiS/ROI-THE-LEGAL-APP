import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'feedback_screen.dart';

class VoteScreen extends StatefulWidget {
  final String billId;

  const VoteScreen({super.key, required this.billId});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen>
    with SingleTickerProviderStateMixin {
  String? _voteChoice;
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

  Future<void> _submitVote(BuildContext context) async {
    if (_voteChoice == null) return;
    final field = _voteChoice == 'for' ? 'votesFor' : 'votesAgainst';

    try {
      await FirebaseFirestore.instance
          .collection('bills')
          .doc(widget.billId)
          .update({field: FieldValue.increment(1)});

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FeedbackScreen(
            billId: widget.billId,
            voteChoice: _voteChoice!,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

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
              _buildAppBar(context),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeController,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🗳️ CAST YOUR VOTE', 
                              style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                            const SizedBox(height: 16),
                            const Text("Do you support\nthis bill?",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1F2937), fontFamily: 'PlusJakartaSans', height: 1.1),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),

                            _buildVoteButton(
                              label: "Support Bill",
                              color: const Color(0xFF10B981),
                              isSelected: _voteChoice == "for",
                              onTap: () => setState(() => _voteChoice = "for"),
                              icon: Icons.check_circle_rounded,
                            ),
                            const SizedBox(height: 16),

                            _buildVoteButton(
                              label: "Oppose Bill",
                              color: const Color(0xFFEF4444),
                              isSelected: _voteChoice == "against",
                              onTap: () => setState(() => _voteChoice = "against"),
                              icon: Icons.cancel_rounded,
                            ),

                            const SizedBox(height: 48),

                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _voteChoice == null ? null : () => _submitVote(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B5CF6),
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: _voteChoice == null ? 0 : 8,
                                  shadowColor: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                                ),
                                child: const Text('Confirm Vote', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                              ),
                            ),
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
  }

  Widget _buildAppBar(BuildContext context) {
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
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: Color(0xFF8B5CF6)),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          const Text('Parliament Voting', 
            style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF1F2937))),
        ],
      ),
    );
  }

  Widget _buildVoteButton({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? color : Colors.grey.withValues(alpha: 0.1), width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 24),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isSelected ? color : const Color(0xFF4B5563))),
            const Spacer(),
            if (isSelected) Icon(Icons.radio_button_checked_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
