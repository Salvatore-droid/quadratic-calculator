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
  final TextEditingController _dController = TextEditingController();
  String _result = '';
  String _equation = '';
  List<String> _steps = [];
  bool _isCubic = false;

  void _solveEquation() {
    try {
      double a = double.parse(_aController.text);
      
      if (_isCubic) {
        double b = double.parse(_bController.text);
        double c = double.parse(_cController.text);
        double d = double.parse(_dController.text);

        if (a == 0) {
          setState(() {
            _result = 'Error: "a" cannot be zero in a cubic equation';
            _equation = '';
            _steps = [];
          });
          return;
        }

        Map<String, dynamic> solution = AlgebraCalculator.solveCubic(a, b, c, d);
        
        setState(() {
          _equation = '${a}x³ ${b >= 0 ? '+' : '-'} ${b.abs()}x² ${c >= 0 ? '+' : '-'} ${c.abs()}x ${d >= 0 ? '+' : '-'} ${d.abs()} = 0';
          _steps = solution['steps'];
          _formatResult(solution);
        });
      } else {
        double b = double.parse(_bController.text);
        double c = double.parse(_cController.text);

        if (a == 0) {
          setState(() {
            _result = 'Error: "a" cannot be zero in a quadratic equation';
            _equation = '';
            _steps = [];
          });
          return;
        }

        Map<String, dynamic> solution = AlgebraCalculator.solveQuadratic(a, b, c);
        
        setState(() {
          _equation = '${a}x² ${b >= 0 ? '+' : '-'} ${b.abs()}x ${c >= 0 ? '+' : '-'} ${c.abs()} = 0';
          _steps = solution['steps'];
          _formatResult(solution);
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: Please enter valid numbers';
        _equation = '';
        _steps = [];
      });
    }
  }

  void _formatResult(Map<String, dynamic> solution) {
    _result = 'Solutions:\n';
    
    if (solution['solutions'][0] is Map) {
      // Complex roots
      final eigen1 = solution['solutions'][0] as Map<String, double>;
      final eigen2 = solution['solutions'][1] as Map<String, double>;
      _result += 'x₁ = ${eigen1['real']!.toStringAsFixed(4)} + ${eigen1['imaginary']!.toStringAsFixed(4)}i\n';
      _result += 'x₂ = ${eigen2['real']!.toStringAsFixed(4)} + ${eigen2['imaginary']!.toStringAsFixed(4)}i\n';
    } else {
      // Real roots
      final solutions = solution['solutions'] as List<double>;
      for (int i = 0; i < solutions.length; i++) {
        _result += 'x${i + 1} = ${solutions[i].toStringAsFixed(4)}\n';
      }
    }
  }

  void _clearFields() {
    _aController.clear();
    _bController.clear();
    _cController.clear();
    _dController.clear();
    setState(() {
      _result = '';
      _equation = '';
      _steps = [];
    });
  }

  void _toggleEquationType() {
    setState(() {
      _isCubic = !_isCubic;
      _clearFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text(_isCubic ? 'Cubic Equation Solver' : 'Quadratic Equation Solver'),
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isCubic ? Icons.toggle_on : Icons.toggle_off),
            onPressed: _toggleEquationType,
            tooltip: _isCubic ? 'Switch to Quadratic' : 'Switch to Cubic',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isCubic ? 'Solve: ax³ + bx² + cx + d = 0' : 'Solve: ax² + bx + c = 0',
              style: const TextStyle(
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
                if (_isCubic) const SizedBox(width: 16),
                if (_isCubic)
                  Expanded(
                    child: _buildCoefficientInput('d', _dController),
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
                    onPressed: _solveEquation,
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
            
            // Tabs for Results and Steps
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
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
                    Expanded(
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
                                      'Solve an equation to see the steps',
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
    _dController.dispose();
    super.dispose();
  }
}