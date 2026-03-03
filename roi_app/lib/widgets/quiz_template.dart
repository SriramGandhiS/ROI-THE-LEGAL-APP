import 'package:flutter/material.dart';
import 'package:login_signup/theme/app_colors.dart';
import 'dart:ui';

class QuizQuestionData {
  final String article;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? audioUrl;

  QuizQuestionData({
    required this.article,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.audioUrl,
  });
}

class ThemedQuizScreen extends StatelessWidget {
  final String title;
  final List<QuizQuestionData> questions;
  final int currentIndex;
  final String? selectedOption;
  final Function(String) onOptionSelected;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onPlayAudio;
  final bool isPlaying;
  final Color accentColor;
  final Color backgroundColor;

  const ThemedQuizScreen({
    super.key,
    required this.title,
    required this.questions,
    required this.currentIndex,
    required this.selectedOption,
    required this.onOptionSelected,
    required this.onNext,
    required this.onPrevious,
    required this.onPlayAudio,
    this.isPlaying = false,
    this.accentColor = AppColors.primary,
    this.backgroundColor = AppColors.primaryBg,
  });

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final question = questions[currentIndex];
    final progress = (currentIndex + 1) / questions.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Custom AppBar ──
              _buildAppBar(context),
              
              // ── Progress Bar ──
              _buildProgressBar(progress),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Article Card
                      _buildArticleCard(question),
                      
                      const SizedBox(height: 25),

                      // Question Card
                      _buildQuestionCard(question),
                      
                      const SizedBox(height: 25),

                      // Options
                      ...question.options.map((option) => _buildOptionCard(option)),
                      
                      const SizedBox(height: 30),

                      // Navigation
                      _buildNavigationButtons(),
                      
                      const SizedBox(height: 20),
                    ],
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
    return Padding(
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
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Q ${currentIndex + 1}/${questions.length}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: (progress * (360)), // Simplified, should use LayoutBuilder for accuracy
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [accentColor, accentColor.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(QuizQuestionData question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CHAPTER ARTICLE',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
              if (question.audioUrl != null && question.audioUrl!.isNotEmpty)
                GestureDetector(
                  onTap: onPlayAudio,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.article,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuizQuestionData question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withOpacity(0.1)),
      ),
      child: Text(
        question.question,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildOptionCard(String option) {
    final isSelected = selectedOption == option;
    return GestureDetector(
      onTap: () => onOptionSelected(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? accentColor : Colors.black12,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? accentColor : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? accentColor : Colors.black26),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                  color: isSelected ? accentColor : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (currentIndex > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: onPrevious,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: accentColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Previous',
                style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.bold, color: accentColor),
              ),
            ),
          ),
        if (currentIndex > 0) const SizedBox(width: 15),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: selectedOption != null ? onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              disabledBackgroundColor: accentColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 4,
            ),
            child: const Text(
              'Submit Answer 🎯',
              style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
