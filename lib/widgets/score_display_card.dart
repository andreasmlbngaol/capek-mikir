import 'package:capek_mikir/config/app_theme.dart';
import 'package:flutter/material.dart';

class ScoreDisplayCard extends StatelessWidget {
  final String percentage;
  final String userName;
  final bool isPerfect;
  final bool isGood;

  const ScoreDisplayCard({
    super.key,
    required this.percentage,
    required this.userName,
    required this.isPerfect,
    required this.isGood,
  });

  @override
  Widget build(BuildContext context) {
    final double percentValue = double.tryParse(percentage) ?? 0;

    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = isPerfect
        ? colorScheme.primary
        : isGood
        ? colorScheme.secondary
        : colorScheme.tertiary;

    final IconData icon = isPerfect
        ? Icons.verified_rounded
        : isGood
        ? Icons.check_circle_rounded
        : Icons.info_rounded;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
              vertical: AppTheme.spacingMd,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXs),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXl),

          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: percentValue / 100,
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    backgroundColor: accentColor.withValues(alpha: 0.1),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Score",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      percentage,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXl),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: accentColor,
                  size: 48,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  _getStatusMessage(isPerfect, isGood),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusMessage(bool isPerfect, bool isGood) {
    if (isPerfect) {
      return "Sempurna!\n$userName, kamu luar biasa!";
    } else if (isGood) {
      return "Bagus!\n$userName, hasil yang solid!";
    } else {
      return "Terus Belajar\n$userName, kamu pasti bisa lebih baik!";
    }
  }
}
