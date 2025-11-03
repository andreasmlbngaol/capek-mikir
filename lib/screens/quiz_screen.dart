import 'package:capek_mikir/config/router.dart';
import 'package:capek_mikir/config/app_theme.dart';
import 'package:capek_mikir/provider/app_state_provider.dart';
import 'package:capek_mikir/widgets/quiz_timer.dart';
import 'package:capek_mikir/widgets/answer_option.dart';
import 'package:capek_mikir/widgets/question_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:capek_mikir/models/question.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _QuizContent();
  }
}

class _QuizContent extends StatelessWidget {
  const _QuizContent();

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<AppStateProvider>();
    final question = quiz.currentQuestion!;

    if (quiz.isTimeUp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        quiz.calculateScore();
        context.go(AppRoutes.score);
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Soal ${quiz.currentIndex + 1} / ${quiz.questions.length}",
              style: TextStyle(fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppTheme.spacingLg),
                child: Center(
                  child: QuizTimer(quiz: quiz),
                ),
              ),
              if (!isWide)
                IconButton(
                  icon: const Icon(Icons.list_alt_rounded),
                  onPressed: () => _showQuestionList(context, quiz),
                ),
            ],
          ),
          body: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question.problem,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                    fontSize: 28
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingXl),
                                ..._buildChoices(context, quiz, question),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: FilledButton.icon(
                                        style: AppTheme.filledButtonStyle.copyWith(
                                            backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.tertiary),
                                            foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onTertiary)
                                        ),
                                        onPressed: quiz.isFirst
                                            ? null
                                            : quiz.previousQuestion,
                                        icon: const Icon(Icons.arrow_back),
                                        label: const Text(
                                            "Kembali",
                                          style: TextStyle(
                                            fontSize: 18
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacingMd),
                                    Expanded(
                                      child: FilledButton.icon(
                                        style: AppTheme.filledButtonStyle,
                                        onPressed: quiz.isLast
                                            ? () {
                                          quiz.calculateScore();
                                          context.go(AppRoutes.score);
                                        }
                                            : quiz.nextQuestion,
                                        label: Text(
                                            quiz.isLast ? "Selesai" : "Lanjut",
                                          style: TextStyle(
                                            fontSize: 18
                                          ),
                                        ),
                                        icon: const Icon(Icons.arrow_forward),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (isWide)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    child: QuestionSidebar(quiz: quiz),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildChoices(
      BuildContext context, AppStateProvider quiz, Question question) {
    return question.choices.map((choice) {
      final selected = quiz.selectedAnswer == choice;
      return AnswerOption(
        choice: choice,
        isSelected: selected,
        onPressed: () => quiz.selectAnswer(choice),
      );
    }).toList();
  }

  void _showQuestionList(BuildContext context, AppStateProvider quiz) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Wrap(
            children: [
              GridView.builder(
                shrinkWrap: true,
                itemCount: quiz.questions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                  mainAxisSpacing: AppTheme.spacingSm,
                  crossAxisSpacing: AppTheme.spacingSm,
                ),
                itemBuilder: (_, i) {
                  final isCurrent = i == quiz.currentIndex;
                  final isAnswered = quiz.getAnswerFor(i) != null;

                  final bgColor = isCurrent
                      ? theme.colorScheme.primary
                      : (isAnswered
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.surfaceContainerHighest);

                  final textColor = isCurrent || isAnswered
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface;

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor,
                      foregroundColor: textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      elevation: isCurrent ? AppTheme.elevationMd : 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      quiz.jumpToQuestion(i);
                    },
                    child: Text(
                      "${i + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
