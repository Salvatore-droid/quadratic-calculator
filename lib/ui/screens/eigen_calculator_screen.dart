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
  final List<List<TextEditingController>> _controllers = List.generate(
    3, 
    (i) => List.generate(3, (j) => TextEditingController())
  );
  String _result = '';
  List<String> _steps = [];
  int _matrixSize = 2;
  bool _showSteps = false;

  void _calculateEigen() {
    try {
      List<List<double>> matrix = [];
      for (int i = 0; i < _matrixSize; i++) {
        List<double> row = [];
        for (int j = 0; j < _matrixSize; j++) {
          row.add(double.parse(_controllers[i][j].text));
        }
        matrix.add(row);
      }

      final result = AlgebraCalculator.eigenCalculation(matrix);
      
      setState(() {
        _result = _formatResult(result);
        _steps = result['steps'];
        _showSteps = true;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
        _steps = [];
        _showSteps = false;
      });
    }
  }

  String _formatResult(Map<String, dynamic> result) {
    String output = 'Eigenvalues:\n';
    
    if (result['eigenvalues'][0] is Map) {
      // Complex eigenvalues
      for (int i = 0; i < result['eigenvalues'].length; i++) {
        final eigen = result['eigenvalues'][i] as Map<String, double>;
        output += 'λ${i + 1} = ${eigen['real']!.toStringAsFixed(4)} + ${eigen['imaginary']!.toStringAsFixed(4)}i\n';
      }
    } else {
      // Real eigenvalues
      final eigenvalues = result['eigenvalues'] as List<double>;
      for (int i = 0; i < eigenvalues.length; i++) {
        output += 'λ${i + 1} = ${eigenvalues[i].toStringAsFixed(4)}\n';
      }
    }

    output += '\nEigenvectors:\n';
    if (result['eigenvectors'] != null) {
      final eigenvectors = result['eigenvectors'] as List<List<double>>;
      for (int i = 0; i < eigenvectors.length; i++) {
        output += 'v${i + 1} = [';
        for (int j = 0; j < eigenvectors[i].length; j++) {
          output += eigenvectors[i][j].toStringAsFixed(4);
          if (j < eigenvectors[i].length - 1) output += ', ';
        }
        output += ']\n';
      }
    } else if (result['message'] != null) {
      output += result['message'];
    } else {
      output += 'Could not calculate eigenvectors';
    }

    return output;
  }

  void _clearFields() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        _controllers[i][j].clear();
      }
    }
    setState(() {
      _result = '';
      _steps = [];
      _showSteps = false;
    });
  }

  void _setMatrixSize(int size) {
    setState(() {
      _matrixSize = size;
      _clearFields();
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Matrix size selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Matrix Size: ',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('2x2'),
                    selected: _matrixSize == 2,
                    onSelected: (selected) => _setMatrixSize(2),
                    selectedColor: AppColors.accentPurple,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('3x3'),
                    selected: _matrixSize == 3,
                    onSelected: (selected) => _setMatrixSize(3),
                    selectedColor: AppColors.accentPurple,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Enter Matrix:',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Matrix input
              _buildMatrixInput(),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: CalculatorButton(
                      text: 'Clear',
                      backgroundColor: AppColors.functionColor,
                      onPressed: _clearFields,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CalculatorButton(
                      text: 'Calculate',
                      backgroundColor: AppColors.accentPurple,
                      onPressed: _calculateEigen,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Tabs for Results and Steps
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 200),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'Results'),
                          Tab(text: 'Solution Steps'),
                        ],
                        indicatorColor: AppColors.accentPurple,
                        labelColor: AppColors.accentPurple,
                        unselectedLabelColor: AppColors.textSecondary,
                      ),
                      SizedBox(
                        height: 300, // Fixed height for tab content
                        child: TabBarView(
                          children: [
                            // Results Tab
                            Container(
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
                            
                            // Steps Tab
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryDark,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: _steps.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Calculate eigenvalues to see the steps',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _steps.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Text(
                                            _steps[index],
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatrixInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(_matrixSize, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_matrixSize, (j) {
                return Container(
                  width: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextField(
                    controller: _controllers[i][j],
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.tertiaryDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: '0',
                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        _controllers[i][j].dispose();
      }
    }
    super.dispose();
  }
}