// ui/screens/main_calculator_screen.dart
import 'package:flutter/material.dart';
import '../../core/calculators/base_calculator.dart';
import '../widgets/calculator_button.dart';
import '../widgets/display_panel.dart';
import '../widgets/mode_selector.dart';
import '../themes/color_palette.dart';
import 'quadratic_solver_screen.dart';
import 'eigen_calculator_screen.dart';

class MainCalculatorScreen extends StatefulWidget {
  const MainCalculatorScreen({super.key});

  @override
  State<MainCalculatorScreen> createState() => _MainCalculatorScreenState();
}

class _MainCalculatorScreenState extends State<MainCalculatorScreen> {
  final BaseCalculator _calculator = BaseCalculator();
  String _display = '0';
  String _history = '';
  int _selectedMode = 0;

  final List<String> modes = ['Basic', 'Algebra', 'Eigen'];

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _display = '0';
        _history = '';
        _calculator.clear();
      } else if (buttonText == '=') {
        try {
          _history = _display;
          _display = _calculator.calculate(_display);
        } catch (e) {
          _display = 'Error';
        }
      } else if (buttonText == '⌫') {
        if (_display.isNotEmpty && _display != '0') {
          _display = _display.substring(0, _display.length - 1);
          if (_display.isEmpty) _display = '0';
        }
      } else {
        if (_display == '0' && buttonText != '.') {
          _display = buttonText;
        } else {
          _display += buttonText;
        }
      }
    });
  }

  void _navigateToSpecialMode() {
    if (_selectedMode == 1) {
      // Navigate to Quadratic Solver
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QuadraticSolverScreen()),
      );
    } else if (_selectedMode == 2) {
      // Navigate to Eigen Calculator
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EigenCalculatorScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If a special mode is selected, show the navigation button
    bool showSpecialModeButton = _selectedMode == 1 || _selectedMode == 2;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // Mode selector
            ModeSelector(
              modes: modes,
              selectedIndex: _selectedMode,
              onModeChanged: (index) {
                setState(() {
                  _selectedMode = index;
                });
              },
            ),
            
            // Special mode navigation button
            if (showSpecialModeButton)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: _navigateToSpecialMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _selectedMode == 1 ? 'Open Quadratic Solver' : 'Open Eigen Calculator',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            
            // Display area (only show in basic mode)
            if (_selectedMode == 0)
              Expanded(
                flex: 1,
                child: DisplayPanel(
                  current: _display,
                  history: _history,
                ),
              ),
            
            // Button grid (only show in basic mode)
            if (_selectedMode == 0)
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 1.2,
                    children: _buildButtonGrid(),
                  ),
                ),
              ),
            
            // Info message for special modes
            if (_selectedMode != 0)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedMode == 1 ? Icons.functions : Icons.grid_on,
                        size: 64,
                        color: AppColors.accentPurple,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedMode == 1 
                          ? 'Quadratic Equation Solver' 
                          : 'Eigenvalue & Eigenvector Calculator',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedMode == 1
                          ? 'Solve equations of the form ax² + bx + c = 0'
                          : 'Calculate eigenvalues and eigenvectors for 2x2 matrices',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _navigateToSpecialMode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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

  List<Widget> _buildButtonGrid() {
    List<String> buttonLabels = [
      'C', '⌫', '%', '/',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '.', '0', '00', '=',
    ];

    return buttonLabels.map((label) {
      Color bgColor = AppColors.secondaryDark;
      Color textColor = AppColors.textPrimary;
      
      if (['/', '×', '-', '+', '='].contains(label)) {
        bgColor = AppColors.operatorColor;
      } else if (['C', '⌫', '%'].contains(label)) {
        bgColor = AppColors.functionColor;
      }
      
      return CalculatorButton(
        text: label,
        backgroundColor: bgColor,
        textColor: textColor,
        onPressed: () => _onButtonPressed(label),
      );
    }).toList();
  }
}