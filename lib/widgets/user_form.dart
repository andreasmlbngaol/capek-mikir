import 'package:capek_mikir/config/router.dart';
import 'package:capek_mikir/config/app_theme.dart';
import 'package:capek_mikir/models/categories.dart';
import 'package:capek_mikir/provider/user_state_provider.dart';
import 'package:capek_mikir/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserFormWidget extends StatefulWidget {
  const UserFormWidget({super.key});

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  final TextEditingController _nameController = TextEditingController();
  Categories? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppTheme.spacingXl,
        children: [
          Text(
            'Capek Mikir',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 48
            ),
          ),
          Text(
            'Isi dulu data diri terus pilih kategori untuk mulai',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 20
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          OutlinedTextField(
            controller: _nameController,
            labelText: "Nama",
            hintText: "Siapa namanya?",
          ),
          DropdownButtonFormField<Categories>(
            decoration: AppTheme.buildInputDecoration(
              labelText: "Kategori",
              context: context,
            ),
            initialValue: _selectedCategory,
            items: Categories.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.displayName),
              );
            }).toList(),
            onChanged: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          const SizedBox(height: AppTheme.spacingMd),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: AppTheme.filledButtonStyle,
              onPressed: () {
                if (_nameController.text.isEmpty ||
                    _selectedCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Isi dulu semuanya ya 😤"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                final userProvider = context.read<UserStateProvider>();
                userProvider.setUserData(
                  _nameController.text,
                  _selectedCategory!,
                );
                context.go(AppRoutes.quiz);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppTheme.spacingSm,
                ),
                child: Text(
                  "Gaskan",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}