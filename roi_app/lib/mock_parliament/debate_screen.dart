import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'vote_screen.dart';

class DebateScreen extends StatefulWidget {
  final String billId;

  const DebateScreen({super.key, required this.billId});

  @override
  State<DebateScreen> createState() => _DebateScreenState();
}

class _DebateScreenState extends State<DebateScreen>
    with SingleTickerProviderStateMixin {
  final _argumentController = TextEditingController();
  late AnimationController _fadeController;

  Stream<QuerySnapshot> get _debatesStream => FirebaseFirestore.instance
      .collection('bills')
      .doc(widget.billId)
      .collection('debates')
      .orderBy('timestamp')
      .snapshots();

  Future<DocumentSnapshot> get _billFuture => FirebaseFirestore.instance
      .collection('bills')
      .doc(widget.billId)
      .get();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _argumentController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final msg = _argumentController.text.trim();
    if (msg.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('bills')
        .doc(widget.billId)
        .collection('debates')
        .add({
      'message': msg,
      'sender': FirebaseAuth.instance.currentUser?.email ?? 'Anonymous',
      'timestamp': Timestamp.now(),
    });

    _argumentController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: _billFuture,
      builder: (context, billSnap) {
        if (billSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!billSnap.hasData || !billSnap.data!.exists) {
          return const Scaffold(body: Center(child: Text('Bill not found')));
        }

        final billData = billSnap.data!.data()! as Map<String, dynamic>;
        final billTitle = billData['title'] ?? 'Untitled Bill';

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
                  _buildAppBar(context, billTitle),
                  _buildBillSummary(billData),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeController,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _debatesStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                          final debates = snapshot.data!.docs;
                          if (debates.isEmpty) return _buildEmptyState();

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemCount: debates.length,
                            itemBuilder: (context, index) {
                              final data = debates[index].data()! as Map<String, dynamic>;
                              return _buildMessageBubble(data);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  _buildInputArea(),
                  _buildProceedButton(),
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
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: Color(0xFF8B5CF6)),
            ),
            onPressed: () => Navigator.of(context).pop(),
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

  Widget _buildBillSummary(Map<String, dynamic> bill) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.gavel_rounded, color: Color(0xFF8B5CF6), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ACTIVE DISCUSSION', style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(bill['category'] ?? 'General Legislation', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF374151))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('💬', style: TextStyle(fontSize: 48, color: Colors.grey.withValues(alpha: 0.5))),
          const SizedBox(height: 16),
          const Text('No arguments yet.', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
          const Text('Be the first to speak!', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF9CA3AF))),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> data) {
    final sender = data['sender'] ?? "Anonymous";
    final message = data['message'] ?? "";
    final isMe = sender == FirebaseAuth.instance.currentUser?.email;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF8B5CF6) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isMe ? "You" : sender, 
              style: TextStyle(color: isMe ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF8B5CF6), fontSize: 10, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(message, style: TextStyle(color: isMe ? Colors.white : const Color(0xFF374151), fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    const Color purple = Color(0xFF8B5CF6);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _argumentController,
              maxLines: null,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Share your perspective...',
                hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5), fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: purple, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VoteScreen(billId: widget.billId)));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: const Text('Proceed to Vote', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Inter')),
        ),
      ),
    );
  }
}
