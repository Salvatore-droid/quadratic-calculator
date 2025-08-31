// main.dart
import 'package:flutter/material.dart';
import 'ui/screens/main_calculator_screen.dart';
import 'ui/themes/app_theme.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathPro Calculator',
      theme: AppTheme.darkTheme,
      home: const MainCalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}