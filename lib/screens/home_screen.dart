import 'package:capek_mikir/config/app_theme.dart';
import 'package:capek_mikir/widgets/user_form.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingXxl,
            vertical: AppTheme.spacingXl,
          ),
          child: Center(
            child: const UserFormWidget(),
          ),
        ),
      ),
    );
  }
}
