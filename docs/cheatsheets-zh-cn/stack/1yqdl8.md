# Evaluating an Expression in Reverse Polish Notation — 计算逆波兰表达式的值

## 问题的本质

给定一个字符串数组 `tokens`，它表示一个逆波兰表达式（RPN）的算术式。计算该表达式的值，并以整数形式返回结果。有效的运算符有 `+`、`-`、`*`、`/` 四种，每个操作数是一个整数或另一个子表达式。除法向零方向截断。例：`["2","1","+","3","*"]` → `((2+1)*3)` → `9`。

## 核心思路

在逆波兰表达式中，不需要处理运算符的优先级和括号。只需从左到右扫描token，将数值压入栈中，遇到运算符时取出栈顶的两个元素进行计算，再将结果压回栈中，就能正确地计算整个表达式。

## 思考过程

1. **理解RPN的性质**：在逆波兰表达式中，运算符作用于其前面的两个操作数。也就是说，当运算符出现时，它所作用的两个操作数已经确定。基于这一性质，"后进先出"（LIFO）的数据结构——栈是最合适的选择
2. **根据token是数值还是运算符进行分支处理**：依次查看每个token，如果是数值则压入栈中，如果是运算符则执行计算。仅凭这两种操作就能计算整个表达式
3. **处理运算符时注意操作数的顺序**：从栈中第一次pop出的值是右操作数（`a`），第二次pop出的值是左操作数（`b`）。计算按 `b 运算符 a` 的顺序进行。如果顺序搞错，减法和除法会产生错误的结果
4. **将计算结果压回栈中**：将运算结果push回栈中，使该结果可以作为后续运算的操作数。这样，嵌套的子表达式也能自然地被处理
5. **最终结果是栈中仅剩的一个值**：如果是有效的RPN表达式，处理完所有token后，栈中只剩下一个计算结果。将该值pop出来并返回

## 前置知识

### 什么是 Stack

后进先出（LIFO）的数据结构。最后添加的元素最先被取出。元素的添加（push）和取出（pop）的时间复杂度均为O(1)。

```java
Stack<Integer> stack = new Stack<>();  // 创建一个空栈
stack.push(5);     // 将5压入栈顶 → [5]
stack.push(3);     // 将3压入栈顶 → [5, 3]
stack.pop();       // 取出并返回栈顶元素 → 3，栈变为 [5]
stack.pop();       // 取出并返回栈顶元素 → 5，栈变为 []
```

### 什么是逆波兰表达式（RPN）

将运算符放在操作数之后的表示法。通常的中缀表达式 `(2 + 1) * 3`，用RPN表示为 `2 1 + 3 *`。不需要括号，只需从左到右依次处理即可正确计算。

```
中缀表达式:  (2 + 1) * 3
RPN:         2 1 + 3 *
计算过程:    2 1 + → 3，然后 3 3 * → 9
```

### 什么是 Integer.parseInt

将字符串转换为整数的Java静态方法。表示负数的字符串（例：`"-3"`）也能正确转换。

```java
Integer.parseInt("42");    // → 42
Integer.parseInt("-3");    // → -3
```

## 复杂度

| | 值 |
|---|---|
| Time | O(n) — 只需对数组中的token进行一次扫描 |
| Space | O(n) — 栈中最多保存n个元素 |

## 代码

```java
// 输入：表示逆波兰表达式的字符串数组 tokens
// 输出：以整数形式返回表达式的计算结果
public int evalRPN(String[] tokens) {
    // 用于临时保存数值操作数和中间计算结果的栈
    Stack<Integer> stack = new Stack<>();

    // 从头到尾逐个扫描数组 tokens
    for (String token : tokens) {
        // 判断当前token是否为运算符（+、-、*、/ 中的任意一个）
        switch (token) {
            case "+": {
                int a = stack.pop();  // 第1次pop → 右操作数
                int b = stack.pop();  // 第2次pop → 左操作数
                // 将计算结果push回栈中，使其可作为后续运算的操作数
                stack.push(b + a);
                break;
            }
            case "-": {
                int a = stack.pop();
                int b = stack.pop();
                // 注意：pop的顺序是反的，因此必须按 b - a 的顺序计算。如果写成 a - b，结果会相反
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
                // Java的整数除法会自动向零方向截断，因此不需要特殊处理
                // 注意：pop的顺序是反的，因此必须按 b / a 的顺序计算。如果写成 a / b，结果会相反
                stack.push(b / a);
                break;
            }
            default: {
                // 将数值token转换为整数并压入栈中
                // 负数（例："-3"）也能被 parseInt 正确处理
                stack.push(Integer.parseInt(token));
            }
        }
    }

    // 如果是有效的RPN表达式，处理完所有token后栈中只剩下一个结果
    return stack.pop();
}
```
