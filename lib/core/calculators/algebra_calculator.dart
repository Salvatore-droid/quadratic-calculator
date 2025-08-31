// core/calculators/algebra_calculator.dart
import 'dart:math';

class AlgebraCalculator {
  // Solve quadratic equation: ax² + bx + c = 0
  static Map<String, dynamic> solveQuadratic(double a, double b, double c) {
    if (a == 0) {
      throw ArgumentError('Coefficient a cannot be zero in a quadratic equation');
    }

    List<String> steps = [];
    steps.add('Given equation: ${a}x² ${b >= 0 ? '+' : '-'} ${b.abs()}x ${c >= 0 ? '+' : '-'} ${c.abs()} = 0');
    steps.add('Step 1: Identify coefficients: a = $a, b = $b, c = $c');
    
    double discriminant = b * b - 4 * a * c;
    steps.add('Step 2: Calculate discriminant: D = b² - 4ac = $b² - 4×$a×$c = $discriminant');

    if (discriminant > 0) {
      steps.add('Step 3: Discriminant is positive (D > 0), so two distinct real roots');
      double sqrtDiscriminant = sqrt(discriminant);
      steps.add('Step 4: √D = √$discriminant = $sqrtDiscriminant');
      
      double x1 = (-b + sqrtDiscriminant) / (2 * a);
      double x2 = (-b - sqrtDiscriminant) / (2 * a);
      
      steps.add('Step 5: x = [-b ± √D] / 2a');
      steps.add('       = [${-b} ± $sqrtDiscriminant] / ${2 * a}');
      steps.add('       = ${x1.toStringAsFixed(4)} or ${x2.toStringAsFixed(4)}');

      return {
        'solutions': [x1, x2],
        'steps': steps,
        'type': 'two_real_roots'
      };
    } else if (discriminant == 0) {
      steps.add('Step 3: Discriminant is zero (D = 0), so one real root (repeated)');
      
      double x = -b / (2 * a);
      steps.add('Step 4: x = -b / 2a = ${-b} / ${2 * a} = ${x.toStringAsFixed(4)}');

      return {
        'solutions': [x],
        'steps': steps,
        'type': 'one_real_root'
      };
    } else {
      steps.add('Step 3: Discriminant is negative (D < 0), so two complex roots');
      
      double realPart = -b / (2 * a);
      double imaginaryPart = sqrt(-discriminant) / (2 * a);
      
      steps.add('Step 4: Real part = -b / 2a = ${-b} / ${2 * a} = $realPart');
      steps.add('Step 5: Imaginary part = √|D| / 2a = √${-discriminant} / ${2 * a} = $imaginaryPart');
      steps.add('Step 6: x = $realPart ± ${imaginaryPart}i');

      return {
        'solutions': [
          {'real': realPart, 'imaginary': imaginaryPart},
          {'real': realPart, 'imaginary': -imaginaryPart}
        ],
        'steps': steps,
        'type': 'complex_roots'
      };
    }
  }

  // Solve cubic equation: ax³ + bx² + cx + d = 0
  static Map<String, dynamic> solveCubic(double a, double b, double c, double d) {
    if (a == 0) {
      throw ArgumentError('Coefficient a cannot be zero in a cubic equation');
    }

    List<String> steps = [];
    steps.add('Given equation: ${a}x³ ${b >= 0 ? '+' : '-'} ${b.abs()}x² ${c >= 0 ? '+' : '-'} ${c.abs()}x ${d >= 0 ? '+' : '-'} ${d.abs()} = 0');
    steps.add('Step 1: Identify coefficients: a = $a, b = $b, c = $c, d = $d');

    // Normalize the equation: x³ + (b/a)x² + (c/a)x + (d/a) = 0
    double bNorm = b / a;
    double cNorm = c / a;
    double dNorm = d / a;
    steps.add('Step 2: Normalize: x³ + ${bNorm}x² + ${cNorm}x + $dNorm = 0');

    // Use depressed cubic method: x = y - b/3a
    double p = cNorm - (bNorm * bNorm) / 3;
    double q = (2 * bNorm * bNorm * bNorm) / 27 - (bNorm * cNorm) / 3 + dNorm;
    
    steps.add('Step 3: Depressed cubic substitution: x = y - ${bNorm / 3}');
    steps.add('Step 4: Calculate p = c - b²/3 = $cNorm - ${bNorm * bNorm / 3} = $p');
    steps.add('Step 5: Calculate q = 2b³/27 - bc/3 + d = ${2 * bNorm * bNorm * bNorm / 27} - ${bNorm * cNorm / 3} + $dNorm = $q');

    double discriminant = (q * q) / 4 + (p * p * p) / 27;
    steps.add('Step 6: Discriminant Δ = (q/2)² + (p/3)³ = ${(q * q) / 4} + ${(p * p * p) / 27} = $discriminant');

    if (discriminant > 0) {
      steps.add('Step 7: Δ > 0, so one real root and two complex roots');
      
      double u = pow(-q / 2 + sqrt(discriminant), 1 / 3).toDouble();
      double v = pow(-q / 2 - sqrt(discriminant), 1 / 3).toDouble();
      
      steps.add('Step 8: u = ∛[-q/2 + √Δ] = ∛[${-q / 2} + ${sqrt(discriminant)}] = $u');
      steps.add('Step 9: v = ∛[-q/2 - √Δ] = ∛[${-q / 2} - ${sqrt(discriminant)}] = $v');

      double realRoot = u + v - bNorm / 3;
      steps.add('Step 10: Real root = u + v - b/3 = $u + $v - ${bNorm / 3} = $realRoot');

      // Complex roots would be calculated here, but we'll focus on real roots for simplicity
      steps.add('Step 11: Complex roots can be found using formulas involving u, v, and complex numbers');

      return {
        'solutions': [realRoot],
        'steps': steps,
        'type': 'one_real_two_complex'
      };
    } else if (discriminant == 0) {
      steps.add('Step 7: Δ = 0, so all roots are real and at least two are equal');
      
      double u = pow(-q / 2, 1 / 3).toDouble();
      steps.add('Step 8: u = v = ∛[-q/2] = ∛[${-q / 2}] = $u');

      double root1 = 2 * u - bNorm / 3;
      double root2 = -u - bNorm / 3;
      
      steps.add('Step 9: Root 1 = 2u - b/3 = ${2 * u} - ${bNorm / 3} = $root1');
      steps.add('Step 10: Root 2 = Root 3 = -u - b/3 = ${-u} - ${bNorm / 3} = $root2');

      return {
        'solutions': [root1, root2, root2],
        'steps': steps,
        'type': 'three_real_roots'
      };
    } else {
      steps.add('Step 7: Δ < 0, so three distinct real roots (casus irreducibilis)');
      steps.add('Step 8: Use trigonometric method for three real roots');
      
      double r = sqrt(-(p * p * p) / 27);
      double theta = acos(-q / (2 * r));
      
      steps.add('Step 9: r = √(-p³/27) = √(${-(p * p * p) / 27}) = $r');
      steps.add('Step 10: θ = arccos(-q/(2r)) = arccos(${-q / (2 * r)}) = $theta');

      double root1 = 2 * pow(r, 1 / 3).toDouble() * cos(theta / 3) - bNorm / 3;
      double root2 = 2 * pow(r, 1 / 3).toDouble() * cos((theta + 2 * pi) / 3) - bNorm / 3;
      double root3 = 2 * pow(r, 1 / 3).toDouble() * cos((theta + 4 * pi) / 3) - bNorm / 3;
      
      steps.add('Step 11: Root 1 = 2∛r cos(θ/3) - b/3 = ${2 * pow(r, 1 / 3)} × cos(${theta / 3}) - ${bNorm / 3} = $root1');
      steps.add('Step 12: Root 2 = 2∛r cos((θ+2π)/3) - b/3 = ${2 * pow(r, 1 / 3)} × cos(${(theta + 2 * pi) / 3}) - ${bNorm / 3} = $root2');
      steps.add('Step 13: Root 3 = 2∛r cos((θ+4π)/3) - b/3 = ${2 * pow(r, 1 / 3)} × cos(${(theta + 4 * pi) / 3}) - ${bNorm / 3} = $root3');

      return {
        'solutions': [root1, root2, root3],
        'steps': steps,
        'type': 'three_distinct_real_roots'
      };
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

  

  static Map<String, dynamic> eigenCalculation(List<List<double>> matrix) {
    if (matrix.length != matrix[0].length) {
      throw ArgumentError('Matrix must be square');
    }

    List<String> steps = [];
    int size = matrix.length;
    
    steps.add('Given ${size}x$size matrix:');
    steps.add(_matrixToString(matrix));
    
    if (size == 2) {
      return _eigen2x2WithSteps(matrix, steps);
    } else if (size == 3) {
      return _eigen3x3WithSteps(matrix, steps);
    } else {
      throw ArgumentError('Only 2x2 and 3x3 matrices are supported');
    }
  }

  static Map<String, dynamic> _eigen2x2WithSteps(List<List<double>> matrix, List<String> steps) {
    final a = matrix[0][0];
    final b = matrix[0][1];
    final c = matrix[1][0];
    final d = matrix[1][1];

    steps.add('Step 1: For 2x2 matrix, eigenvalues satisfy: λ² - (a+d)λ + (ad - bc) = 0');
    steps.add('        Characteristic equation: λ² - (${a}+${d})λ + (${a}×${d} - ${b}×${c}) = 0');
    steps.add('        λ² - ${a + d}λ + ${a * d - b * c} = 0');

    final trace = a + d;
    final determinant = a * d - b * c;
    
    final discriminant = trace * trace - 4 * determinant;
    steps.add('Step 2: Calculate discriminant: D = trace² - 4×det = ${trace}² - 4×${determinant} = $discriminant');

    if (discriminant < 0) {
      steps.add('Step 3: D < 0, so complex eigenvalues');
      
      final realPart = trace / 2;
      final imaginaryPart = sqrt(-discriminant) / 2;
      
      steps.add('Step 4: Real part = trace/2 = $trace/2 = $realPart');
      steps.add('Step 5: Imaginary part = √|D|/2 = √${-discriminant}/2 = $imaginaryPart');

      return {
        'eigenvalues': [
          {'real': realPart, 'imaginary': imaginaryPart},
          {'real': realPart, 'imaginary': -imaginaryPart}
        ],
        'eigenvectors': null,
        'steps': steps,
        'message': 'Complex eigenvalues detected. Eigenvector calculation not implemented for complex cases.'
      };
    } else {
      steps.add('Step 3: D ≥ 0, so real eigenvalues');
      
      final eigenvalue1 = (trace + sqrt(discriminant)) / 2;
      final eigenvalue2 = (trace - sqrt(discriminant)) / 2;
      
      steps.add('Step 4: λ₁ = (trace + √D)/2 = ($trace + ${sqrt(discriminant)})/2 = $eigenvalue1');
      steps.add('Step 5: λ₂ = (trace - √D)/2 = ($trace - ${sqrt(discriminant)})/2 = $eigenvalue2');

      final eigenvector1 = _calculateEigenvector(matrix, eigenvalue1);
      final eigenvector2 = _calculateEigenvector(matrix, eigenvalue2);
      
      steps.add('Step 6: For λ₁ = $eigenvalue1, solve (A - λI)v = 0');
      steps.add('        Eigenvector v₁ = [${eigenvector1[0]}, ${eigenvector1[1]}]');
      steps.add('Step 7: For λ₂ = $eigenvalue2, solve (A - λI)v = 0');
      steps.add('        Eigenvector v₂ = [${eigenvector2[0]}, ${eigenvector2[1]}]');

      return {
        'eigenvalues': [eigenvalue1, eigenvalue2],
        'eigenvectors': [eigenvector1, eigenvector2],
        'steps': steps
      };
    }
  }

  static Map<String, dynamic> _eigen3x3WithSteps(List<List<double>> matrix, List<String> steps) {
    final a = matrix[0][0], b = matrix[0][1], c = matrix[0][2];
    final d = matrix[1][0], e = matrix[1][1], f = matrix[1][2];
    final g = matrix[2][0], h = matrix[2][1], i = matrix[2][2];

    steps.add('Step 1: For 3x3 matrix, find characteristic polynomial: det(A - λI) = 0');
    
    // Calculate characteristic polynomial coefficients
    final trace = a + e + i;
    final sum2x2 = (a * e - b * d) + (a * i - c * g) + (e * i - f * h);
    final determinant = a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g);
    
    steps.add('Step 2: Characteristic polynomial: -λ³ + ${trace}λ² - ${sum2x2}λ + ${determinant} = 0');
    steps.add('Step 3: Solve cubic equation: λ³ - ${trace}λ² + ${sum2x2}λ - ${determinant} = 0');

    // Solve the cubic equation for eigenvalues
    final cubicSolution = solveCubic(1, -trace, sum2x2, -determinant);
    final eigenvalues = cubicSolution['solutions'];
    
    steps.addAll(cubicSolution['steps'].sublist(2)); // Skip the first two steps which are about the original equation
    
    steps.add('Step ${steps.length + 1}: Eigenvalues found:');
    for (int idx = 0; idx < eigenvalues.length; idx++) {
      if (eigenvalues[idx] is Map) {
        final complex = eigenvalues[idx] as Map<String, double>;
        steps.add('        λ${idx + 1} = ${complex['real']} + ${complex['imaginary']}i');
      } else {
        steps.add('        λ${idx + 1} = ${eigenvalues[idx]}');
      }
    }

    // Calculate eigenvectors for real eigenvalues
    List<List<double>> eigenvectors = [];
    List<String> eigenvectorSteps = [];
    
    for (int idx = 0; idx < eigenvalues.length; idx++) {
      if (eigenvalues[idx] is! Map) { // Only calculate for real eigenvalues
        final eigenvalue = eigenvalues[idx] as double;
        eigenvectorSteps.add('Step ${steps.length + eigenvectorSteps.length + 1}: For λ${idx + 1} = $eigenvalue, solve (A - λI)v = 0');
        
        final eigenvector = _calculateEigenvector3x3(matrix, eigenvalue);
        eigenvectors.add(eigenvector);
        
        eigenvectorSteps.add('        Eigenvector v${idx + 1} = [${eigenvector[0]}, ${eigenvector[1]}, ${eigenvector[2]}]');
      }
    }
    
    steps.addAll(eigenvectorSteps);

    return {
      'eigenvalues': eigenvalues,
      'eigenvectors': eigenvectors.isNotEmpty ? eigenvectors : null,
      'steps': steps,
      'message': eigenvectors.isEmpty ? 'Only complex eigenvectors (not implemented)' : null
    };
  }

  static List<double> _calculateEigenvector3x3(List<List<double>> matrix, double eigenvalue) {
    // Solve (A - λI)v = 0 using Gaussian elimination
    final a = matrix[0][0] - eigenvalue;
    final b = matrix[0][1];
    final c = matrix[0][2];
    final d = matrix[1][0];
    final e = matrix[1][1] - eigenvalue;
    final f = matrix[1][2];
    final g = matrix[2][0];
    final h = matrix[2][1];
    final i = matrix[2][2] - eigenvalue;

    // Use cross product method for 3x3 case
    // v = (b×f - c×e, c×d - a×f, a×e - b×d)
    final x = b * f - c * e;
    final y = c * d - a * f;
    final z = a * e - b * d;

    // Normalize the vector
    final magnitude = sqrt(x * x + y * y + z * z);
    if (magnitude == 0) {
      return [1, 0, 0]; // Default vector if zero magnitude
    }

    return [x / magnitude, y / magnitude, z / magnitude];
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

  static String _matrixToString(List<List<double>> matrix) {
    String result = '';
    for (int i = 0; i < matrix.length; i++) {
      result += '[';
      for (int j = 0; j < matrix[i].length; j++) {
        result += '${matrix[i][j]}';
        if (j < matrix[i].length - 1) result += ', ';
      }
      result += ']';
      if (i < matrix.length - 1) result += '\n';
    }
    return result;
  }
}