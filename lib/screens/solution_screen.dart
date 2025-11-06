import 'package:capek_mikir/config/app_theme.dart';
import 'package:capek_mikir/provider/app_state_provider.dart';
import 'package:capek_mikir/widgets/solution_option.dart';
import 'package:capek_mikir/widgets/explanation_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SolutionScreen extends StatefulWidget {
  const SolutionScreen({super.key});

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<AppStateProvider>();
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Jawaban"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isWide
            ? _buildWideLayout(context, quiz)
            : _buildNarrowLayout(context, quiz),
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context, AppStateProvider quiz) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      itemCount: quiz.questions.length,
      itemBuilder: (context, index) =>
          _buildQuestionCard(context, quiz, index),
    );
  }

  Widget _buildWideLayout(BuildContext context, AppStateProvider quiz) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 300,
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              itemCount: quiz.questions.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                final question = quiz.questions[index];
                final userAnswer = quiz.getAnswerFor(index);
                final correctAnswer = question.solution;
                final isCorrect = userAnswer == correctAnswer;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius:
                      BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCorrect
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacingSm),
                        Expanded(
                          child: Text(
                            "Soal ${index + 1}",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: _buildQuestionDetail(
              context,
              quiz,
              _selectedIndex,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionDetail(
      BuildContext context, AppStateProvider quiz, int index) {
    final question = quiz.questions[index];
    final userAnswer = quiz.getAnswerFor(index);
    final correctAnswer = question.solution;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Soal ${index + 1}",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          question.problem,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        ...List.generate(question.choices.length, (optIndex) {
          final option = question.choices[optIndex];
          final isUserAnswer = option == userAnswer;
          final isCorrect = option == correctAnswer;

          return SolutionOption(
            option: option,
            isCorrect: isCorrect,
            isUserAnswer: isUserAnswer,
          );
        }),
        ExplanationBox(explanation: question.explanation),
      ],
    );
  }

  Widget _buildQuestionCard(
      BuildContext context, AppStateProvider quiz, int index) {
    final question = quiz.questions[index];
    final userAnswer = quiz.getAnswerFor(index);
    final correctAnswer = question.solution;

    return Card(
      elevation: AppTheme.elevationMd,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Padding(
        padding: AppTheme.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Soal ${index + 1}",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              question.problem,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ...List.generate(question.choices.length, (optIndex) {
              final option = question.choices[optIndex];
              final isUserAnswer = option == userAnswer;
              final isCorrect = option == correctAnswer;

              return SolutionOption(
                option: option,
                isCorrect: isCorrect,
                isUserAnswer: isUserAnswer,
              );
            }),
            ExplanationBox(explanation: question.explanation),
          ],
        ),
      ),
    );
  }
}
