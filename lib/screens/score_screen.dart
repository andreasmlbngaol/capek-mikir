import 'package:capek_mikir/config/router.dart';
import 'package:capek_mikir/config/app_theme.dart';
import 'package:capek_mikir/provider/app_state_provider.dart';
import 'package:capek_mikir/provider/user_state_provider.dart';
import 'package:capek_mikir/widgets/score_display_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<AppStateProvider>();
    final user = context.watch<UserStateProvider>();

    final percentage =
    (quiz.score / quiz.questions.length * 100).toStringAsFixed(0);
    final isPerfect = quiz.score == quiz.questions.length;
    final isGood = quiz.score >= quiz.questions.length * 0.7;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Hasil Quiz"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScoreDisplayCard(
                    percentage: percentage,
                    userName: user.name!,
                    isPerfect: isPerfect,
                    isGood: isGood,
                  ),
                  const SizedBox(height: AppTheme.spacingXl),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      ),
                    ),
                    icon: const Icon(Icons.visibility_rounded),
                    onPressed: () => context.push(AppRoutes.solution),
                    label: const Text(
                      "Review Jawaban",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      ),
                    ),
                    icon: const Icon(Icons.home_rounded),
                    onPressed: () {
                      quiz.stopTimer();
                      context.read<UserStateProvider>().clearUser();
                      context.go(AppRoutes.home);
                    },
                    label: const Text(
                      "Kembali ke Beranda",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
