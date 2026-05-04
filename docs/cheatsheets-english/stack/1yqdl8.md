# Evaluating an Expression in Reverse Polish Notation

## Problem

The system receives a string array `tokens` representing an arithmetic expression in Reverse Polish Notation (RPN). The algorithm evaluates this expression and returns the result as an integer. The four valid operators are `+`, `-`, `*`, and `/`, and each operand is either an integer or another sub-expression. Division truncates toward zero. Example: `["2","1","+","3","*"]` → `((2+1)*3)` → `9`.

## Key Insight

Reverse Polish Notation eliminates the need for operator precedence rules and parentheses handling. The evaluator scans tokens from left to right, pushes numeric values onto a stack, and whenever it encounters an operator, it pops the top two values, computes the result, and pushes it back. This simple process correctly evaluates the entire expression.

## Thought Process

1. **Understand the nature of RPN**: In Reverse Polish Notation, an operator acts on the two operands immediately preceding it. This means that when an operator appears, the two target operands are already determined. This property makes a stack—a LIFO (Last In, First Out) data structure—the ideal choice.
2. **Branch processing based on whether the token is a number or an operator**: The algorithm inspects each token in order, pushes it onto the stack if it is a number, and performs a calculation if it is an operator. These two operations alone suffice to evaluate the entire expression.
3. **Pay attention to operand order when processing operators**: The first value popped from the stack becomes the right operand (`a`), and the second value popped becomes the left operand (`b`). The calculation follows the order `b operator a`. Reversing this order produces incorrect results for subtraction and division.
4. **Push the calculation result back onto the stack**: Pushing the result back onto the stack allows subsequent operators to use it as an operand. This mechanism naturally handles nested sub-expressions.
5. **The final result is the single value remaining on the stack**: For a valid RPN expression, exactly one value remains on the stack after processing all tokens. The algorithm pops and returns this value.

## Prerequisites

### What is a Stack?

A stack is a Last In, First Out (LIFO) data structure. It retrieves the most recently added element first. Both adding an element (push) and removing an element (pop) run in O(1) time.

```java
Stack<Integer> stack = new Stack<>();  // Create an empty stack
stack.push(5);     // Push 5 onto the top of the stack → [5]
stack.push(3);     // Push 3 onto the top of the stack → [5, 3]
stack.pop();       // Pop and return the top element → 3, stack is [5]
stack.pop();       // Pop and return the top element → 5, stack is []
```

### What is Reverse Polish Notation (RPN)?

RPN is a notation that places operators after their operands. The standard infix expression `(2 + 1) * 3` is written as `2 1 + 3 *` in RPN. RPN requires no parentheses, and the evaluator processes tokens sequentially from left to right to produce the correct result.

```
Infix notation:       (2 + 1) * 3
RPN:                  2 1 + 3 *
Evaluation process:   2 1 + → 3, then 3 3 * → 9
```

### What is Integer.parseInt?

`Integer.parseInt` is a static method in Java that converts a string to an integer. It correctly handles strings representing negative numbers (e.g., `"-3"`).

```java
Integer.parseInt("42");    // → 42
Integer.parseInt("-3");    // → -3
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm performs a single pass through the token array |
| Space | O(n) — The stack stores at most n elements |

## Code

```java
// Input: A string array tokens representing an arithmetic expression in RPN
// Output: The integer result of evaluating the expression
public int evalRPN(String[] tokens) {
    // Stack to temporarily hold numeric operands and intermediate results
    Stack<Integer> stack = new Stack<>();

    // Scan the tokens array from beginning to end, one token at a time
    for (String token : tokens) {
        // Determine whether the current token is an operator (+, -, *, or /)
        switch (token) {
            case "+": {
                int a = stack.pop();  // First pop → right operand
                int b = stack.pop();  // Second pop → left operand
                // Push the result so subsequent operators can use it as an operand
                stack.push(b + a);
                break;
            }
            case "-": {
                int a = stack.pop();
                int b = stack.pop();
                // Note: Pop order is reversed, so the calculation must be b - a. Using a - b inverts the result
                stack.push(b - a);
                break;
            }
            case "*": {
                int a = stack.pop();
                int b = stack.pop();
                stack.push(b * a);
                break;
            }
            case "/": {
                int a = stack.pop();
                int b = stack.pop();
                // Java's integer division automatically truncates toward zero, so no special handling is needed
                // Note: Pop order is reversed, so the calculation must be b / a. Using a / b inverts the result
                stack.push(b / a);
                break;
            }
            default: {
                // Convert the numeric token to an integer and push it onto the stack
                // parseInt correctly handles negative numbers (e.g., "-3")
                stack.push(Integer.parseInt(token));
            }
        }
    }

    // For a valid RPN expression, exactly one result remains on the stack after processing all tokens
    return stack.pop();
}
```
