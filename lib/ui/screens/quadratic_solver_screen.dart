// ui/screens/quadratic_solver_screen.dart
import 'package:flutter/material.dart';
import '../../core/calculators/algebra_calculator.dart';
import '../widgets/calculator_button.dart';
import '../themes/color_palette.dart';

class QuadraticSolverScreen extends StatefulWidget {
  const QuadraticSolverScreen({super.key});

  @override
  State<QuadraticSolverScreen> createState() => _QuadraticSolverScreenState();
}

class _QuadraticSolverScreenState extends State<QuadraticSolverScreen> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  String _result = '';
  String _equation = '';

  void _solveQuadratic() {
    try {
      double a = double.parse(_aController.text);
      double b = double.parse(_bController.text);
      double c = double.parse(_cController.text);

      if (a == 0) {
        setState(() {
          _result = 'Error: "a" cannot be zero in a quadratic equation';
          _equation = '';
        });
        return;
      }

      List<dynamic> solutions = AlgebraCalculator.solveQuadratic(a, b, c);
      
      setState(() {
        _equation = '${a}x² ${b >= 0 ? '+' : '-'} ${b.abs()}x ${c >= 0 ? '+' : '-'} ${c.abs()} = 0';
        
        if (solutions.isEmpty) {
          _result = 'No real solutions';
        } else if (solutions.length == 1) {
          _result = 'One real solution:\nx = ${solutions[0].toStringAsFixed(4)}';
        } else {
          _result = 'Two solutions:\nx₁ = ${solutions[0].toStringAsFixed(4)}\nx₂ = ${solutions[1].toStringAsFixed(4)}';
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error: Please enter valid numbers';
        _equation = '';
      });
    }
  }

  void _clearFields() {
    _aController.clear();
    _bController.clear();
    _cController.clear();
    setState(() {
      _result = '';
      _equation = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Quadratic Equation Solver'),
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Solve: ax² + bx + c = 0',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            
            // Coefficient inputs
            Row(
              children: [
                Expanded(
                  child: _buildCoefficientInput('a', _aController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCoefficientInput('b', _bController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCoefficientInput('c', _cController),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    text: 'Clear',
                    backgroundColor: AppColors.functionColor,
                    onPressed: _clearFields,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CalculatorButton(
                    text: 'Solve',
                    backgroundColor: AppColors.accentPurple,
                    onPressed: _solveQuadratic,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Equation display
            if (_equation.isNotEmpty)
              Text(
                _equation,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Results
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoefficientInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Coefficient $label',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.tertiaryDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter $label',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }
}