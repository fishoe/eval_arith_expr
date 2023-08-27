import 'package:eval_arith_expr/token.dart';

const operatorPrecedence = {
  '+': 1,
  '-': 1,
  '*': 2,
  '/': 2,
  '^': 3,
  '(': 0,
  ')': 0,
};

int comparePriority(String left, String right) {
  var leftPriority = operatorPrecedence[left];
  var rightPriority = operatorPrecedence[right];
  if (leftPriority == null || rightPriority == null) {
    throw ArgumentError('Invalid operator');
  } else {
    return leftPriority - rightPriority;
  }
}

List<Token> convert(String infixExpr) {
  var postfixExpr = <Token>[];
  var operatorStack = <OperatorToken>[];

  var expr = infixExpr;
  while (expr.isNotEmpty) {
    expr = expr.trim();
    var (token, rest) = getTokenFrom(expr);
    expr = rest;

    if (token is NumberToken) {
      postfixExpr.add(token);
    } else if (token is OperatorToken) {
      if (operatorStack.isEmpty && token.value != ')') {
        operatorStack.add(token);
      } else {
        if (token.value == ')') {
          while (operatorStack.last.value != '(') {
            if (operatorStack.isEmpty) {
              throw Exception('Invalid expression');
            }
            postfixExpr.add(operatorStack.removeLast());
          }
          operatorStack.removeLast();
        } else if (token.value == '(') {
          operatorStack.add(token);
        } else {
          var topOperator = operatorStack.last;
          if (token > topOperator) {
            operatorStack.add(token);
          } else {
            if (token.value == '^' && topOperator.value == '^') {
              operatorStack.add(token);
              continue;
            }
            while (token <= topOperator) {
              postfixExpr.add(operatorStack.removeLast());
              if (operatorStack.isEmpty) {
                break;
              }
              topOperator = operatorStack.last;
            }
            operatorStack.add(token);
          }
        }
      }
    }
  }
  while (operatorStack.isNotEmpty) {
    postfixExpr.add(operatorStack.removeLast());
  }
  return postfixExpr;
}

(int, List<Token>) evaluate(List<Token> postfixExpr) {
  var lastToken = postfixExpr.last;
  var subExpr = postfixExpr.sublist(0, postfixExpr.length - 1);
  if (lastToken is NumberToken) {
    return (lastToken.value, subExpr);
  } else if (lastToken is OperatorToken) {
    var (rightValue, rightExpr) = evaluate(subExpr);
    var (leftValue, leftExpr) = evaluate(rightExpr);
    return (lastToken.evaluate(leftValue, rightValue), leftExpr);
  } else {
    throw Exception('Invalid expression');
  }
}
