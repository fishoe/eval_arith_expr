import 'package:eval_arith_expr/evaluate.dart';
import 'package:eval_arith_expr/token.dart';
import 'package:test/test.dart';

void main() {
  group('Convert from infix to postfix', () {
    test('Compare priority of operators', () {
      var operatorSum = OperatorToken('+');
      var operatorSub = OperatorToken('-');
      var operatorMul = OperatorToken('*');
      var operatorDiv = OperatorToken('/');
      expect(operatorSum < operatorMul, isTrue);
      expect(operatorSum > operatorMul, isFalse);
      expect(operatorDiv >= operatorSub, isTrue);
      expect(operatorSum <= operatorSub, isTrue);
      expect(operatorSub >= operatorMul, isFalse);
    });

    test('Get number from expression', () {
      expect(getNumberFrom('123'), equals((123, '')));
      expect(getNumberFrom('123+'), equals((123, '+')));
      expect(getNumberFrom('123+456'), equals((123, '+456')));
      expect(getNumberFrom('123+456*'), equals((123, '+456*')));
    });

    test('Get operator from expression', () {
      expect(getOperatorSignFrom('+432'), equals(('+', '432')));
      expect(getOperatorSignFrom('-432'), equals(('-', '432')));
    });

    test('Convert infix expression to postfix expression', () {
      var expr = '1 + 2';
      var postfixExpr = convert(expr);
      expect(postfixExpr.join(""), equals("12+"));
      expect(postfixExpr.join(""), isNot(equals("12-")));

      expr = '1 + 2 * 3';
      postfixExpr = convert(expr);
      expect(postfixExpr.join(""), equals("123*+"));
      expect(postfixExpr, isNot(equals("123+*")));

      expr = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3";
      postfixExpr = convert(expr);
      expect(postfixExpr.join(" "), equals("3 4 2 * 1 5 - 2 3 ^ ^ / +"));

      expr = "3*(2+6/2)";
      postfixExpr = convert(expr);
      expect(postfixExpr.join(" "), equals("3 2 6 2 / + *"));

      expr = "3*(2+6/2^8)";
      postfixExpr = convert(expr);
      expect(postfixExpr.join(" "), equals("3 2 6 2 8 ^ / + *"));

      expr = "5 * 2 ^ 1 ^ 3 + 6";
      postfixExpr = convert(expr);
      expect(postfixExpr.join(" "), equals("5 2 1 3 ^ ^ * 6 +"));

      expr = "3*(2+6/2^8)^7+6";
      postfixExpr = convert(expr);
      expect(postfixExpr.join(""), equals("32628^/+7^*6+"));
    });

    test('infix with parenthesis test', () {
      var expr = '( 1 + 2 ) * 3';
      var postfixExpr = convert(expr).join(" ");
      expect(postfixExpr, equals("1 2 + 3 *"));

      expr = '3 * ( 1 + 2)';
      postfixExpr = convert(expr).join(" ");
      expect(postfixExpr, equals("3 1 2 + *"));
    });

    test("evaluate expressions", () {
      var expr = "72 / ( 4 + 8 / 2 ^ 2 ) + 6";
      var postfixExpr = convert(expr);
      expect(postfixExpr.join(" "), "72 4 8 2 2 ^ / + / 6 +");
      var (answer, subList) = evaluate(postfixExpr);
      expect(answer, equals(18));
      expect(subList.isEmpty, isTrue);
    });
  });
}
