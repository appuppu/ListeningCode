# Multiplying Two Numbers Represented as Strings

## Problem

You are given two strings `num1` and `num2` that represent non-negative integers. Return the **product** of the two numbers as a string. You must not use any built-in big integer library or convert the inputs directly to integers.

## Key Insight

You simulate the long multiplication algorithm taught in elementary school. The key relationship is that the product of the i-th digit of `num1` and the j-th digit of `num2` is added to the `i + j` and `i + j + 1` positions of the result.

## Thought Process

1. **Reproduce long multiplication**: Since you cannot convert the inputs to integers, you implement the long multiplication algorithm that multiplies one digit at a time and accumulates the results.
2. **Estimate the maximum number of digits in the product**: The product of an n-digit number and an m-digit number has at most `n + m` digits (e.g., 99 × 99 = 9801; 2 digits × 2 digits = 4 digits). You prepare an array `pos` of size `n + m` to store the value at each digit position.
3. **Determine which positions in the result each digit product maps to**: The product of the i-th digit from the right of `num1` and the j-th digit from the right of `num2` affects the `i + j` and `i + j + 1` positions from the right of the result. In terms of string indices, the product `num1[i] * num2[j]` is added to `pos[i + j + 1]` (the lower digit) and `pos[i + j]` (the upper digit).
4. **Process carries in place**: After computing the product of each digit pair, you add it to the value already accumulated in `pos[p2]`, keep the remainder when divided by 10 at that position, and add the quotient when divided by 10 to the upper position `pos[p1]`. This handles carries immediately.
5. **Skip leading zeros and build the string**: The beginning of the array `pos` may contain zeros (e.g., when the product of a 3-digit number and a 2-digit number is 4 digits, the first element of the 5-element array is 0). You build the string with `StringBuilder` while skipping leading zeros.
6. **Handle the special case of zero**: If either input is `"0"`, the product is always `"0"`, so you return `"0"` early.

## Prerequisites

### charAt and Character-to-Digit Conversion

`String.charAt(i)` returns the i-th character of the string as a `char` type. To convert a `char` from `'0'`–`'9'` to an integer 0–9, you subtract the character code of `'0'`.

```java
String s = "123";
char c = s.charAt(0);       // '1' (char type)
int digit = c - '0';        // 1 (int type). Subtracts code 48 of '0' from code 49 of '1'
```

### Positional Relationship in Long Multiplication

In n-digit × m-digit long multiplication, the product of `num1[i]` and `num2[j]` (at most 81) can be up to two digits. These two digits correspond to `pos[i + j]` (the upper digit) and `pos[i + j + 1]` (the lower digit) in the result.

```
Example: "12" × "34"
  num1[0]=1, num2[0]=3 → product 3  → added to pos[0], pos[1]
  num1[0]=1, num2[1]=4 → product 4  → added to pos[1], pos[2]
  num1[1]=2, num2[0]=3 → product 6  → added to pos[1], pos[2]
  num1[1]=2, num2[1]=4 → product 8  → added to pos[2], pos[3]
```

### StringBuilder

StringBuilder is a class that efficiently builds mutable strings. You append characters to the end with `append` and convert the result to a `String` with `toString`.

```java
StringBuilder sb = new StringBuilder();  // Create an empty StringBuilder
sb.append(4);                            // Appends "4" to the end
sb.append(0);                            // Becomes "40"
sb.append(8);                            // Becomes "408"
sb.toString();                           // Returns String "408"
sb.length();                             // Returns the current character count → 3
```

## Complexity

| | Value |
|---|---|
| Time | O(n × m) — You multiply each digit of num1 with each digit of num2 exactly once |
| Space | O(n + m) — The array that stores each digit of the product has size n + m |

## Code

```java
// Input: strings num1 and num2 representing non-negative integers
// Output: a string representing the product of the two numbers
String multiply(String num1, String num2) {
    // If either number is "0", the product is always 0, so return "0" early
    if (num1.equals("0") || num2.equals("0"))
        return "0";

    int n = num1.length();
    int m = num2.length();
    // Array to store each digit of the product. The product of an n-digit and m-digit number has at most n+m digits, so this size is sufficient
    int[] pos = new int[n + m];

    // Multiply from the lowest digit (end) toward the highest digit, just like long multiplication
    for (int i = n - 1; i >= 0; i--) {
        for (int j = m - 1; j >= 0; j--) {
            // Convert the character obtained by charAt to its corresponding integer by subtracting '0', then multiply
            int mul = (num1.charAt(i) - '0')
                * (num2.charAt(j) - '0');
            // Positions where the product is added: p1 is the upper digit, p2 is the lower digit. This positional relationship is based on digit alignment in long multiplication
            int p1 = i + j;
            int p2 = i + j + 1;
            // Account for values previously added to the same position by adding to the already accumulated value
            int sum = mul + pos[p2];
            // Keep only one digit at the lower position (remainder when divided by 10) and add the carry to the upper position (quotient when divided by 10)
            pos[p2] = sum % 10;
            pos[p1] += sum / 10;
        }
    }

    // Build the string while skipping leading zeros (e.g., when the first element of a 5-element array is 0)
    StringBuilder sb = new StringBuilder();
    for (int p : pos) {
        // If the StringBuilder is still empty and the current value is 0, this is a leading zero, so skip it
        if (sb.length() == 0 && p == 0)
            continue;
        sb.append(p);
    }
    // Convert the StringBuilder to a String and return it
    return sb.toString();
}
```
