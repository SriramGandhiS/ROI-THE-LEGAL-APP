import 'package:flutter/material.dart';
import 'package:login_signup/theme/app_colors.dart';

class GamifiedQuizDialog extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final Color accentColor;
  final VoidCallback onNext;

  const GamifiedQuizDialog({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.accentColor,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: (isCorrect ? AppColors.success : AppColors.error).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (isCorrect ? AppColors.success : AppColors.error).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCorrect ? Icons.auto_awesome_rounded : Icons.lightbulb_outline_rounded,
                color: isCorrect ? AppColors.success : AppColors.error,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              isCorrect ? "EXCELLENT!" : "ALMOST THERE",
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isCorrect ? AppColors.success : AppColors.error,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            
            // Content
            Text(
              isCorrect 
                  ? "Your legal knowledge is impressive. Keep it up! 🚀" 
                  : "Every mistake is a lesson. The correct answer was:",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            if (!isCorrect) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withOpacity(0.1)),
                ),
                child: Text(
                  correctAnswer,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                    fontSize: 14,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 28),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCorrect ? AppColors.success : AppColors.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "CONTINUE",
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizCompletionDialog extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final Color accentColor;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const QuizCompletionDialog({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.accentColor,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions) * 100;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy Illustration (Simplified Emoji version)
            const Text("🏆", style: TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            
            const Text(
              "QUIZ COMPLETED!",
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              "You've successfully finished this expert challenge.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Score Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accentColor.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "$score / $totalQuestions",
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: accentColor,
                        ),
                      ),
                      const Text(
                        "SCORE",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Container(width: 1, height: 40, color: accentColor.withOpacity(0.2)),
                  const SizedBox(width: 32),
                  Column(
                    children: [
                      Text(
                        "${percentage.toInt()}%",
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                        ),
                      ),
                      const Text(
                        "ACCURACY",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Buttons
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onExit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  "FINISH LESSON",
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRestart,
              child: Text(
                "RETRY CHALLENGE",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: accentColor.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
