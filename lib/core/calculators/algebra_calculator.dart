// core/calculators/algebra_calculator.dart
import 'dart:math';

class AlgebraCalculator {
  // Solve quadratic equation: ax² + bx + c = 0
  static List<double> solveQuadratic(double a, double b, double c) {
    if (a == 0) {
      throw ArgumentError('Coefficient a cannot be zero in a quadratic equation');
    }

    double discriminant = b * b - 4 * a * c;

    if (discriminant > 0) {
      double sqrtDiscriminant = sqrt(discriminant);
      return [
        (-b + sqrtDiscriminant) / (2 * a),
        (-b - sqrtDiscriminant) / (2 * a)
      ];
    } else if (discriminant == 0) {
      return [-b / (2 * a)];
    } else {
      // For complex roots, return empty list or handle differently
      return [];
    }
  }

  // Calculate eigenvalues and eigenvectors for a 2x2 matrix
  static Map<String, dynamic> eigen2x2(List<List<double>> matrix) {
    if (matrix.length != 2 || matrix[0].length != 2 || matrix[1].length != 2) {
      throw ArgumentError('Matrix must be 2x2');
    }

    final a = matrix[0][0];
    final b = matrix[0][1];
    final c = matrix[1][0];
    final d = matrix[1][1];

    // Calculate eigenvalues
    final trace = a + d;
    final determinant = a * d - b * c;
    
    final discriminant = trace * trace - 4 * determinant;
    
    if (discriminant < 0) {
      // Complex eigenvalues
      final realPart = trace / 2;
      final imaginaryPart = sqrt(-discriminant) / 2;
      
      return {
        'eigenvalues': [
          {'real': realPart, 'imaginary': imaginaryPart},
          {'real': realPart, 'imaginary': -imaginaryPart}
        ],
        'eigenvectors': null,
        'message': 'Complex eigenvalues detected. Eigenvector calculation not implemented for complex cases.'
      };
    } else {
      // Real eigenvalues
      final eigenvalue1 = (trace + sqrt(discriminant)) / 2;
      final eigenvalue2 = (trace - sqrt(discriminant)) / 2;
      
      // Calculate eigenvectors
      final eigenvector1 = _calculateEigenvector(matrix, eigenvalue1);
      final eigenvector2 = _calculateEigenvector(matrix, eigenvalue2);
      
      return {
        'eigenvalues': [eigenvalue1, eigenvalue2],
        'eigenvectors': [eigenvector1, eigenvector2]
      };
    }
  }

  static List<double> _calculateEigenvector(List<List<double>> matrix, double eigenvalue) {
    final a = matrix[0][0] - eigenvalue;
    final b = matrix[0][1];
    final c = matrix[1][0];
    final d = matrix[1][1] - eigenvalue;
    
    // Solve (A - λI)v = 0
    if (a != 0 || b != 0) {
      if (b != 0) {
        return [d, -c]; // Using the relation from the second equation
      } else {
        return [-b, a];
      }
    } else if (c != 0 || d != 0) {
      if (d != 0) {
        return [-b, a];
      } else {
        return [d, -c];
      }
    }
    
    // If both rows are zero, return a default vector
    return [1, 0];
  }
}