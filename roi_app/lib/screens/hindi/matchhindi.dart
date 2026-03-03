import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_signup/screens/hindi/dashpageHindi.dart';
import 'package:login_signup/theme/app_colors.dart';

class MatchGameScreenHindi extends StatefulWidget {
  const MatchGameScreenHindi({super.key});

  @override
  _MatchGameScreenState createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends State<MatchGameScreenHindi> {
  List<String> laws = [];
  Map<String, String> descriptions = {};
  Map<String, String?> matched = {};
  Map<String, bool> isCorrect = {};
  List<String> availableLaws = [];
  bool showResult = false;
  DocumentSnapshot? currentMatchDocument;
  int currentMatchIndex = 0;
  List<DocumentSnapshot>? matchDocuments;

  @override
  void initState() {
    super.initState();
    fetchMatchData();
  }

  Future<void> fetchMatchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('matchDataHindi')
          .orderBy(FieldPath.documentId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        matchDocuments = snapshot.docs;
        currentMatchDocument = matchDocuments![currentMatchIndex];
        setDataFromDocument(currentMatchDocument!);
      }
    } catch (e) {
      debugPrint('डेटा प्राप्त करने में त्रुटि: $e');
    }
  }

  void setDataFromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    laws = List<String>.from(data['laws']);
    descriptions = Map<String, String>.from(data['descriptions']);
    matched = {for (var law in laws) law: null};
    isCorrect = {for (var law in laws) law: false};
    availableLaws = List.from(laws);
    setState(() {});
  }

  void checkAnswers() {
    for (var law in laws) {
      isCorrect[law] = matched[law] == law;
    }
    setState(() => showResult = true);
  }

  void showCorrectAnswersDialog() {
    final incorrectAnswers = laws.where((law) => !isCorrect[law]!).toList();
    final correctAnswers = laws
        .where((law) => isCorrect[law]!)
        .map((law) => '$law: ${descriptions[law]}')
        .join('\n');
    final userAnswers = laws.map((law) => '$law: ${matched[law] ?? 'मेल नहीं'}').join('\n');
    final incorrectAnswersMessage = incorrectAnswers.isEmpty
        ? 'कोई गलत उत्तर नहीं है।'
        : incorrectAnswers.map((law) => '$law: ${descriptions[law]}').join('\n');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('परिणाम',
            style: TextStyle(color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('✅ आपके सही उत्तर:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
            const SizedBox(height: 4),
            Text(correctAnswers.isEmpty ? 'कोई सही उत्तर नहीं है।' : correctAnswers,
                style: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter', fontSize: 13)),
            const SizedBox(height: 12),
            const Text('❌ गलत उत्तर:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
            const SizedBox(height: 4),
            Text(incorrectAnswersMessage,
                style: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter', fontSize: 13)),
          ]),
        ),
        actions: [
          ElevatedButton(
            onPressed: () { Navigator.of(context).pop(); nextMatch(); },
            child: const Text('अगला मिलान'),
          ),
        ],
      ),
    );
  }

  void nextMatch() {
    if (matchDocuments == null) return;
    setState(() {
      matched = {for (var law in laws) law: null};
      isCorrect = {for (var law in laws) law: false};
      showResult = false;
    });
    if (currentMatchIndex < matchDocuments!.length - 1) {
      currentMatchIndex++;
      currentMatchDocument = matchDocuments![currentMatchIndex];
      setDataFromDocument(currentMatchDocument!);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('🎉 खेल पूरा!',
              style: TextStyle(color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.bold)),
          content: const Text('आपने सभी मिलान पूरे कर लिए हैं।',
              style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentMatchIndex = 0;
                  matched = {for (var law in laws) law: null};
                  isCorrect = {for (var law in laws) law: false};
                  showResult = false;
                });
                currentMatchDocument = matchDocuments![currentMatchIndex];
                setDataFromDocument(currentMatchDocument!);
              },
              child: const Text('फिर से'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashpagehindi()));
              },
              child: const Text('डैशबोर्ड'),
            ),
          ],
        ),
      );
    }
  }

  void previousMatch() {
    if (matchDocuments == null || currentMatchIndex == 0) return;
    setState(() {
      currentMatchIndex--;
      currentMatchDocument = matchDocuments![currentMatchIndex];
      setDataFromDocument(currentMatchDocument!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('मिलान खेल',
            style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(12)),
            child: Text(
              '${currentMatchIndex + 1} / ${matchDocuments?.length ?? 1}',
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
            ),
          ),
        ],
      ),
      body: laws.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: AppColors.primaryBg,
                  child: const Text(
                    'कानून कार्डों को खींचें और सही विवरण पर छोड़ें →',
                    style: TextStyle(color: AppColors.primary, fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: descriptions.keys.length,
                    itemBuilder: (context, index) {
                      String law = descriptions.keys.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(descriptions[law]!,
                                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(width: 10),
                              DragTarget<String>(
                                builder: (context, candidateData, _) {
                                  final highlight = candidateData.isNotEmpty;
                                  Color bgColor;
                                  if (showResult) {
                                    bgColor = isCorrect[law] == true
                                        ? AppColors.success.withOpacity(0.15)
                                        : AppColors.error.withOpacity(0.15);
                                  } else {
                                    bgColor = highlight ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceAlt;
                                  }
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 130, height: 60,
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: showResult
                                            ? (isCorrect[law] == true ? AppColors.success : AppColors.error)
                                            : (highlight ? AppColors.primary : AppColors.border),
                                        width: highlight || showResult ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        matched[law] ?? '+ यहां छोड़ें',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: matched[law] != null ? AppColors.textPrimary : AppColors.textHint,
                                          fontSize: 12, fontFamily: 'Inter',
                                          fontWeight: matched[law] != null ? FontWeight.w700 : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onWillAcceptWithDetails: (data) => true,
                                onAcceptWithDetails: (DragTargetDetails<String> details) {
                                  setState(() {
                                    matched[law] = details.data;
                                    availableLaws.remove(details.data);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8, runSpacing: 8,
                    children: availableLaws.map((law) => Draggable<String>(
                      data: law,
                      feedback: Material(
                        color: Colors.transparent,
                        child: _HindiDraggableCard(law: law, isDragging: true),
                      ),
                      childWhenDragging: Opacity(opacity: 0.3, child: _HindiDraggableCard(law: law)),
                      child: _HindiDraggableCard(law: law),
                    )).toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                  color: AppColors.surface,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: previousMatch,
                        icon: const Icon(Icons.arrow_back_rounded),
                        style: IconButton.styleFrom(backgroundColor: AppColors.surfaceAlt, foregroundColor: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 16),
                      if (showResult)
                        ElevatedButton.icon(
                          onPressed: showCorrectAnswersDialog,
                          icon: const Icon(Icons.fact_check_rounded, size: 18),
                          label: const Text('परिणाम देखें'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: checkAnswers,
                          icon: const Icon(Icons.check_rounded, size: 18),
                          label: const Text('उत्तर जांचें'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                        ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: nextMatch,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        style: IconButton.styleFrom(backgroundColor: AppColors.surfaceAlt, foregroundColor: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _HindiDraggableCard extends StatelessWidget {
  final String law;
  final bool isDragging;
  const _HindiDraggableCard({required this.law, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(10),
        boxShadow: isDragging
            ? [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]
            : [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Text(law, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
    );
  }
}
