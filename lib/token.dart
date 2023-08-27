import 'package:eval_arith_expr/evaluate.dart';

abstract class Token {
  @override
  String toString();

  bool operator <(Token other);
  bool operator >(Token other);
  bool operator <=(Token other);
  bool operator >=(Token other);
}

bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

(int, String) getNumberFrom(String expr) {
  expr = expr.trim();
  var left = "";
  for (int i = 0; i < expr.length; i++) {
    if (isDigit(expr, i)) {
      left += expr[i];
    } else {
      return (int.parse(left), expr.substring(left.length));
    }
  }
  return (int.parse(left), "");
}

(String, String) getOperatorSignFrom(String expr) {
  expr = expr.trim();
  if (expr.isEmpty) {
    throw Exception("Empty expression");
  }
  var operatorSign = expr[0];
  return (operatorSign, expr.substring(1));
}

class NumberToken extends Token {
  final int value;
  NumberToken(this.value);

  @override
  bool operator ==(Object other) {
    if (other is NumberToken) {
      return value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();

  @override
  bool operator <(Token other) {
    if (other is NumberToken) {
      return value < other.value;
    } else {
      throw Exception("Invalid comparison");
    }
  }

  @override
  bool operator <=(Token other) {
    if (other is NumberToken) {
      return value < other.value;
    } else {
      throw Exception("Invalid comparison");
    }
  }

  @override
  bool operator >(Token other) {
    if (other is NumberToken) {
      return value < other.value;
    } else {
      throw Exception("Invalid comparison");
    }
  }

  @override
  bool operator >=(Token other) {
    if (other is NumberToken) {
      return value < other.value;
    } else {
      throw Exception("Invalid comparison");
    }
  }
}

class OperatorToken extends Token {
  final String value;
  OperatorToken(this.value);

  int evaluate(int left, int right) {
    switch (value) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '*':
        return left * right;
      case '/':
        return left ~/ right;
      case '^':
        return power(left, right);
      default:
        throw Exception("Invalid operator");
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is OperatorToken) {
      return value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;

  @override
  bool operator <(Token other) {
    if (other is OperatorToken) {
      return comparePriority(value, other.value) < 0;
    } else {
      throw Exception("Invalid comparison");
    }
  }

  @override
  bool operator <=(Token other) {
    if (other is OperatorToken) {
      return comparePriority(value, other.value) <= 0;
    } else {
      throw Exception("Invalid comparison");
    }
  }

  @override
  bool operator >(Token other) {
    if (other is OperatorToken) {
      return comparePriority(value, other.value) > 0;
    } else {
      throw Exception("Invalid comparison");
    }
  }

  @override
  bool operator >=(Token other) {
    if (other is OperatorToken) {
      return comparePriority(value, other.value) > 0;
    } else {
      throw Exception("Invalid comparison");
    }
  }
}

// TODO : binary and unary operator
// TODO : associativity(exponentiation)

(Token, String) getTokenFrom(String expr) {
  expr = expr.trim();
  if (expr.isEmpty) {
    throw Exception("Empty expression");
  }
  if (isDigit(expr, 0)) {
    var (number, rest) = getNumberFrom(expr);
    return (NumberToken(number), rest);
  } else {
    var (operatorSign, rest) = getOperatorSignFrom(expr);
    return (OperatorToken(operatorSign), rest);
  }
}

int power(int a, int b) {
  if (b == 0) {
    return 1;
  }
  if (b == 1) {
    return a;
  }
  if (b % 2 == 0) {
    return power(a, b ~/ 2) * power(a, b ~/ 2);
  } else {
    return power(a, b ~/ 2) * power(a, b ~/ 2) * a;
  }
}
