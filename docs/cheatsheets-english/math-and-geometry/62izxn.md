# Computing Power of a Number Efficiently

## Problem

The function receives a floating-point number `x` and an integer `n`. It computes and returns `x` raised to the power of `n`. Because `n` can be negative, the function must handle negative exponents, and it must compute the result efficiently even when the absolute value of `n` is very large.

## Key Insight

When you represent the exponent `n` in binary, the exponentiation decomposes into "repeatedly squaring x and multiplying the result only when the corresponding bit of n is 1." This decomposition reduces n multiplications to log(n) multiplications.

## Thought Process

1. **Convert a negative exponent to a positive exponent**: Since `x^(-n)` equals `(1/x)^n`, you can replace `x` with `1/x` and negate `n` when `n` is negative, which unifies the problem into positive-exponent cases only
2. **Multiplying n times is too slow**: Naively multiplying `x` by itself `n` times costs O(n). When `n` is in the billions, this approach cannot finish in time. You need a method that halves the exponent at each step
3. **Any power decomposes into a product of powers of two**: For example, `x^10 = x^8 × x^2`. This decomposition corresponds to the binary representation of the exponent `n`. Since `10` is `1010` in binary, you only need to multiply together `x^8` and `x^2`, which correspond to the bits that are 1
4. **Use bitwise operations to check each digit**: The expression `(n & 1) == 1` checks whether the least significant bit of `n` is 1. If it is, you multiply the result by the current value of `x` (which represents x raised to the power of two corresponding to the current digit)
5. **Square x repeatedly to advance through digits**: Updating `x` to `x * x` in each iteration makes `x` become the original value squared, to the 4th power, to the 8th power, and so on. Simultaneously, you right-shift `n` by one bit to move to the next digit
6. **Loop termination condition**: Right-shifting `n` repeatedly eventually makes it 0. The loop runs while `n > 0`, which ensures that the algorithm processes all bits

## Prerequisites

### Bitwise Operations (& and >>)

Bitwise operations treat integers as binary numbers and manipulate them bit by bit. The `&` (AND) operator returns 1 only when both bits are 1. The `>>` (right shift) operator shifts the bit sequence to the right and discards the least significant bit (equivalent to dividing by 2).

```java
int n = 10;           // Binary: 1010
n & 1;                // Get the least significant bit → 0 (even)
n >>= 1;              // Right shift by 1 bit → n becomes 5 (binary: 101)
n & 1;                // Get the least significant bit → 1 (odd)
```

### Fast Exponentiation (Repeated Squaring)

Fast exponentiation is a technique that uses the binary representation of the exponent to compute a power in O(log n) multiplications. Taking `x^13` as an example, since `13` is `1101` in binary, the algorithm decomposes it as `x^13 = x^8 × x^4 × x^1`. The loop repeatedly squares `x` (`x → x^2 → x^4 → x^8`) and multiplies the result only when the corresponding bit is 1.

```java
// Computation of x^13 (13 = 1101 in binary)
// Bit 0: 1 → result *= x    (result = x^1),   x = x^2
// Bit 1: 0 → skip,                             x = x^4
// Bit 2: 1 → result *= x^4  (result = x^5),   x = x^8
// Bit 3: 1 → result *= x^8  (result = x^13),  x = x^16
```

### Why Casting to long Is Necessary

Java's `int` type ranges from `-2^31` to `2^31 - 1`. When `n = -2^31`, negating it produces `2^31`, which exceeds the `int` range and causes overflow. Casting `n` to `long` before negating avoids this problem.

```java
int n = Integer.MIN_VALUE;   // -2147483648
long power = (long) n;       // -2147483648L (converted to long)
power = -power;              // 2147483648L (not representable as int, but safe as long)
```

## Complexity

| | Value |
|---|---|
| Time | O(log n) — The loop iterates once for each bit in the exponent n |
| Space | O(1) — The algorithm uses only three variables (result, x, power) and requires no recursion stack |

## Code

```java
// Input: a floating-point number x and an integer n
// Output: the value of x raised to the power of n as a double
double myPow(double x, int n) {
    // Cast to long to prevent overflow when negating n = -2^31
    long power = (long) n;

    // Convert a negative exponent to positive: x^(-n) = (1/x)^n
    // This conversion allows all subsequent processing to handle positive exponents only
    if (power < 0) {
        x = 1 / x;
        power = -power;
    }

    // Initialize the result accumulator to 1.0
    // The algorithm multiplies in the contribution of x's power for each bit that is 1
    double result = 1.0;

    // Process all bits of power from the least significant to the most significant
    // Right-shifting power repeatedly eventually makes it 0, completing all digit processing
    while (power > 0) {
        // Check whether the least significant bit (the current digit being processed) is 1
        if ((power & 1) == 1) {
            // If the bit is 1: x at this point equals the original x squared k times (original x to the 2^k)
            // Multiply this digit's contribution into the result
            result *= x;
        }
        // Square x to update it to the power value corresponding to the next digit (double the exponent)
        x *= x;
        // Right-shift power by 1 bit to advance to the next digit (the least significant bit is discarded)
        power >>= 1;
    }
    // Return the final result, which is the product of all bit contributions
    return result;
}
```
