// core/calculators/base_calculator.dart
class BaseCalculator {
  String _currentExpression = '';

  void clear() {
    _currentExpression = '';
  }

  String calculate(String expression) {
    _currentExpression = expression;
    
    // Replace visual operators with calculation operators
    String calcExpression = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/');
    
    try {
      // Simple calculation logic - in a real app you'd use a proper expression parser
      if (calcExpression.contains('%')) {
        // Handle percentage calculations
        return _calculatePercentage(calcExpression).toString();
      } else {
        // Use Dart's built-in expression evaluation (limited)
        // Note: For production, use a proper math expression parser
        return _evaluateExpression(calcExpression).toString();
      }
    } catch (e) {
      return 'Error';
    }
  }

  double _evaluateExpression(String expression) {
    // Simple expression evaluation
    // This is a basic implementation - consider using a proper math parser library
    if (expression == '') return 0;
    
    // Handle basic arithmetic
    if (expression.contains('+')) {
      List<String> parts = expression.split('+');
      return _evaluateExpression(parts[0]) + _evaluateExpression(parts[1]);
    } else if (expression.contains('-')) {
      List<String> parts = expression.split('-');
      return _evaluateExpression(parts[0]) - _evaluateExpression(parts[1]);
    } else if (expression.contains('*')) {
      List<String> parts = expression.split('*');
      return _evaluateExpression(parts[0]) * _evaluateExpression(parts[1]);
    } else if (expression.contains('/')) {
      List<String> parts = expression.split('/');
      double denominator = _evaluateExpression(parts[1]);
      if (denominator == 0) {
        throw Exception('Division by zero');
      }
      return _evaluateExpression(parts[0]) / denominator;
    } else {
      return double.tryParse(expression) ?? 0;
    }
  }

  double _calculatePercentage(String expression) {
    // Simple percentage calculation
    if (expression.endsWith('%')) {
      String numberPart = expression.substring(0, expression.length - 1);
      double value = double.tryParse(numberPart) ?? 0;
      return value / 100;
    }
    
    // Handle cases like "100 + 10%"
    if (expression.contains('+%')) {
      List<String> parts = expression.split('+%');
      double base = double.tryParse(parts[0]) ?? 0;
      return base * 1.1; // 10% increase
    }
    
    // Handle cases like "100 - 10%"
    if (expression.contains('-%')) {
      List<String> parts = expression.split('-%');
      double base = double.tryParse(parts[0]) ?? 0;
      return base * 0.9; // 10% decrease
    }
    
    // Add more percentage handling as needed
    return double.tryParse(expression) ?? 0;
  }

  String getCurrentExpression() {
    return _currentExpression;
  }
}