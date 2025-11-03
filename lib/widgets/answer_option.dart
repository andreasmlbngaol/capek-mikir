import 'package:capek_mikir/config/app_theme.dart';
import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  final String choice;
  final bool isSelected;
  final VoidCallback onPressed;

  const AnswerOption({
    super.key,
    required this.choice,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spacingLg,
            horizontal: AppTheme.spacingMd,
          ),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
        onPressed: onPressed,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            choice,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
