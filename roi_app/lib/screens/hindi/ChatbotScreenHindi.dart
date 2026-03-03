import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_signup/theme/app_colors.dart';

class ChatScreenHindi extends StatefulWidget {
  const ChatScreenHindi({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenHindi> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  @override
  void initState() {
    super.initState();
    _sendIntroMessage();
  }

  void _sendIntroMessage() {
    _messagesCollection.add({
      'text': 'चैटबॉट में आपका स्वागत है! यह बॉट संविधान के बारे में आपके सवालों का जवाब देने और तकनीकी सहायता प्रदान करने के लिए यहां है।',
      'createdAt': FieldValue.serverTimestamp(),
      'isUser': false,
    });
  }

  void _sendMessage() {
    String userMessage = _controller.text.trim();
    if (userMessage.isNotEmpty) {
      _messagesCollection.add({
        'text': userMessage,
        'createdAt': FieldValue.serverTimestamp(),
        'isUser': true,
      });

      String replyMessage = _getReplyMessage(userMessage);
      if (replyMessage.isNotEmpty) {
        _messagesCollection.add({
          'text': replyMessage,
          'createdAt': FieldValue.serverTimestamp(),
          'isUser': false,
        });
      }

      _controller.clear();
    }
  }

  String _getReplyMessage(String userMessage) {
    switch (userMessage.toLowerCase()) {
      case 'hello': return 'नमस्ते! आज मैं आपकी किस प्रकार मदद कर सकता हूँ?';
      case 'what is your name?': return 'मैं आपका वर्चुअल सहायक हूँ!';
      case 'how are you?': return 'मैं एक प्रोग्राम हूँ, और मैं अच्छा हूँ!';
      case 'what is the constitution of india?':
        return 'भारत का संविधान भारत का सर्वोच्च कानून है, जो सरकारी संस्थानों की राजनीतिक सिद्धांतों, प्रक्रियाओं और शक्तियों के ढांचे को निर्धारित करता है।';
      default: return 'मुझे खेद है, मैंने इसे समझा नहीं।';
    }
  }

  void _clearMessages() async {
    final snapshot = await _messagesCollection.get();
    for (var doc in snapshot.docs) {
      await _messagesCollection.doc(doc.id).delete();
    }
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('प्रतिक्रिया', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans')),
          content: TextField(
            controller: feedbackController,
            decoration: const InputDecoration(hintText: 'अपनी प्रतिक्रिया यहाँ दर्ज करें...'),
            maxLines: 3,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('रद्द करें')),
            ElevatedButton(
              onPressed: () {
                _sendFeedback(feedbackController.text);
                Navigator.of(context).pop();
              },
              child: const Text('जमा करें'),
            ),
          ],
        );
      },
    );
  }

  void _sendFeedback(String feedback) {
    if (feedback.isNotEmpty) {
      _feedbackCollection.add({'feedback': feedback, 'timestamp': FieldValue.serverTimestamp()});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('प्रतिक्रिया जमा की गई!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.smart_toy_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('हिंदी चैटबॉट', style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
            Text('ऑनलाइन', style: TextStyle(color: AppColors.success, fontSize: 11, fontFamily: 'Inter')),
          ]),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.feedback_outlined), onPressed: _showFeedbackDialog),
          IconButton(icon: const Icon(Icons.delete_outline_rounded), onPressed: _clearMessages),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.border)),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }
                return ListView(
                  padding: const EdgeInsets.all(12),
                  children: snapshot.data!.docs.map((doc) {
                    final bool isUserMessage = doc['isUser'] ?? false;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Align(
                        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: isUserMessage ? AppColors.chatUser : AppColors.chatBot,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isUserMessage ? 16 : 4),
                              bottomRight: Radius.circular(isUserMessage ? 4 : 16),
                            ),
                          ),
                          child: Text(
                            doc['text'],
                            style: TextStyle(
                              color: isUserMessage ? Colors.white : AppColors.textPrimary,
                              fontFamily: 'Inter', fontSize: 14, height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'संदेश टाइप करें...'),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 44, height: 44,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  onPressed: _sendMessage,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
