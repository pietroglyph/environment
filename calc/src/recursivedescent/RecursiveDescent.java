package recursivedescent;

import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.function.DoubleSupplier;
import java.time.Instant;

public class RecursiveDescent {
    private static final String kBitwiseRoundingWarning = "Warning: Bitwise operaters round to the nearest integer.";

    private static Map <String, DoubleSupplier> mVariableSources;
    private static double mLastAnswer;

    public static void main(String[] args) {
        mVariableSources = new HashMap <String, DoubleSupplier> ();

        mVariableSources.put("RANDOM", ()-> {
            return Math.random();
        });
        mVariableSources.put("ANS", ()-> {
            return mLastAnswer;
        });
        mVariableSources.put("UTIME", ()-> {
            return (double) Instant.now().getEpochSecond();
        });
        mVariableSources.put("PI", ()-> {
            return Math.PI;
        });
        mVariableSources.put("E", ()-> {
            return Math.E;
        });

        Scanner scanner = new Scanner(System.in);
        for (;;) {
            System.out.print(">>> ");

            try {
                String expression = scanner.nextLine();
                double result = eval(expression);
                System.out.println(result);
                mLastAnswer = result;
            } catch (Exception e) {
                System.out.println("Couldn't evaluate expression: "+e.getMessage());
            }
        }
    }

    private static double eval(final String str) {
        return new Object() {

            int pos = -1, ch;

            void nextChar() {
                ch = (++pos < str.length()) ? str.charAt(pos) : -1;
            }

            boolean eat(int charToEat) {
                while (ch == ' ')
                    nextChar();
                if (ch == charToEat) {
                    nextChar();
                    return true;
                }
                return false;
            }

            double parse() {
                nextChar();
                double x = parseExpression();
                if (pos < str.length())
                    throw new RuntimeException("Unexpected " + (char) ch);
                return x;
            }

            // Grammar:
            // expression = term | expression `+` term | expression `-` term
            // term = factor | term `*` factor | term `/` factor
            // factor = `+` factor | `-` factor | `(` expression `)`
            //        | number | functionName factor | factor `^` factor

            double parseExpression() {
                double x = parseTerm();
                for (;;) {
                    if (eat('+'))
                        x += parseTerm(); // addition
                    else if (eat('-'))
                        x -= parseTerm(); // subtraction
                    else
                        return x;
                }
            }

            double parseTerm() {
                double x = parseFactor();
                for (;;) {
                    if (eat('*'))
                        x *= parseFactor(); // multiplication
                    else if (eat('/')) {
                        if (eat('/'))
                            x = (int) x / (int) parseFactor(); // integer division
                        else
                            x /= parseFactor(); // division
                    } else if (eat('%')) {
                        if (eat('%'))
                            x = (int) x % (int) parseFactor(); // integer modulo
                        else
                            x = x % parseFactor(); // modulo
                    } else if (eat('&')) {
                        System.out.println(kBitwiseRoundingWarning);
                        x = Math.round(x) & Math.round(parseFactor());
                    } else if (eat('|')) {
                        System.out.println(kBitwiseRoundingWarning);
                        x = Math.round(x) | Math.round(parseFactor());
                    } else
                        return x;
                }
            }

            double parseFactor() {
                if (eat('+'))
                    return parseFactor(); // unary plus
                if (eat('-'))
                    return -parseFactor(); // unary minus
                if (eat('~')) {
                    System.out.println(kBitwiseRoundingWarning);
                    return ~Math.round(parseFactor()); // bitwise AND
                }

                double x;
                int startPos = this.pos;
                if (eat('(')) { // parentheses
                    x = parseExpression();
                    eat(')');
                    // parenthesis multiplication
                    if (ch == '(') {
                        x *= parseExpression();
                        eat(')');
                    }
                } else if ((ch >= '0' && ch <= '9') || ch == '.') { // numbers
                    while ((ch >= '0' && ch <= '9') || ch == '.')
                        nextChar();

                    x = Double.parseDouble(str.substring(startPos, this.pos));
                } else if (ch >= 'a' && ch <= 'z') { // functions
                    while (ch >= 'a' && ch <= 'z')
                        nextChar();
                        
                    String func = str.substring(startPos, this.pos);
                    x = parseFactor(); // this is here to parse the parenthesis that go after functions
                    if (func.equals("sqrt"))
                        x = Math.sqrt(x);
                    else if (func.equals("sin"))
                        x = Math.sin(Math.toRadians(x));
                    else if (func.equals("cos"))
                        x = Math.cos(Math.toRadians(x));
                    else if (func.equals("tan"))
                        x = Math.tan(Math.toRadians(x));
                    else if (func.equals("asin"))
                        x = Math.toDegrees(Math.asin(x));
                    else if (func.equals("acos"))
                        x = Math.toDegrees(Math.acos(x));
                    else if (func.equals("atan"))
                        x = Math.toDegrees(Math.atan(x));
                    else if (func.equals("log"))
                        x = Math.log(x);
                    else if (func.equals("exp"))
                        x = Math.exp(x);
                    else if (func.equals("abs"))
                        x = Math.abs(x);
                    else if (func.equals("cbrt"))
                        x = Math.cbrt(x);
                    else if (func.equals("signum"))
                        x = Math.signum(x);
                    else if (func.equals("exit"))
                        System.exit(Math.round((float) x));
                    else
                        throw new RuntimeException("Unknown function " + func);

                } else if (ch >= 'A' && ch <= 'Z') { // variables
                    while (ch >= 'A' && ch <= 'Z')
                        nextChar();

                    String varName = str.substring(startPos, this.pos);
                    DoubleSupplier method = mVariableSources.get(varName);

                    if (eat('=')) {
                        final double val = parseFactor();
                        mVariableSources.put(varName, ()-> {
                            return val;
                        });
                        return val;
                    }

                    if (method == null)
                        throw new RuntimeException("Unknown variable " + varName);

                    x = method.getAsDouble();
                } else {
                    throw new RuntimeException("Unexpected " + (char) ch + " in " + str);
                }

                if (eat('^'))
                    x = Math.pow(x, parseFactor()); // exponentiation

                return x;
            }
        }.parse();
    }
}
