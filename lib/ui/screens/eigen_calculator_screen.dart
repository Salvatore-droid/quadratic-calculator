// ui/screens/eigen_calculator_screen.dart
import 'package:flutter/material.dart';
import '../../core/calculators/algebra_calculator.dart';
import '../widgets/calculator_button.dart';
import '../themes/color_palette.dart';

class EigenCalculatorScreen extends StatefulWidget {
  const EigenCalculatorScreen({super.key});

  @override
  State<EigenCalculatorScreen> createState() => _EigenCalculatorScreenState();
}

class _EigenCalculatorScreenState extends State<EigenCalculatorScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  String _result = '';

  void _calculateEigen() {
    try {
      final matrix = [
        [double.parse(_controllers[0].text), double.parse(_controllers[1].text)],
        [double.parse(_controllers[2].text), double.parse(_controllers[3].text)]
      ];
      
      final result = AlgebraCalculator.eigen2x2(matrix);
      
      setState(() {
        _result = 'Eigenvalues:\n';
        
        if (result['eigenvalues'][0] is Map) {
          // Complex eigenvalues
          final eigen1 = result['eigenvalues'][0] as Map<String, double>;
          final eigen2 = result['eigenvalues'][1] as Map<String, double>;
          _result += 'λ₁ = ${eigen1['real']!.toStringAsFixed(4)} + ${eigen1['imaginary']!.toStringAsFixed(4)}i\n';
          _result += 'λ₂ = ${eigen2['real']!.toStringAsFixed(4)} + ${eigen2['imaginary']!.toStringAsFixed(4)}i\n';
        } else {
          // Real eigenvalues
          final eigenvalues = result['eigenvalues'] as List<double>;
          _result += 'λ₁ = ${eigenvalues[0].toStringAsFixed(4)}\n';
          _result += 'λ₂ = ${eigenvalues[1].toStringAsFixed(4)}\n\n';
          
          if (result['eigenvectors'] != null) {
            final eigenvectors = result['eigenvectors'] as List<List<double>>;
            _result += 'Eigenvectors:\n';
            _result += 'v₁ = [${eigenvectors[0][0].toStringAsFixed(4)}, ${eigenvectors[0][1].toStringAsFixed(4)}]\n';
            _result += 'v₂ = [${eigenvectors[1][0].toStringAsFixed(4)}, ${eigenvectors[1][1].toStringAsFixed(4)}]\n';
          }
        }
        
        if (result['message'] != null) {
          _result += '\n${result['message']}';
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error: Please enter valid numbers';
      });
    }
  }

  void _clearFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Eigen Calculator'),
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
              'Enter 2x2 Matrix:',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
            ),
            const SizedBox(height: 16),
            
            // Matrix input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMatrixInput(0),
                _buildMatrixInput(1),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMatrixInput(2),
                _buildMatrixInput(3),
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
                    text: 'Calculate',
                    backgroundColor: AppColors.accentPurple,
                    onPressed: _calculateEigen,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
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
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrixInput(int index) {
    return SizedBox(
      width: 80,
      child: TextField(
        controller: _controllers[index],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.tertiaryDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          hintText: '0.0',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}