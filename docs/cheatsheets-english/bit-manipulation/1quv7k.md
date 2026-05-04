# Adding Two Numbers Without the Plus Operator

## Problem

The problem gives you two integers `a` and `b`. You must calculate and return the sum of the two integers using only bitwise operations, **without** using the `+` or `-` operators.

## Key Insight

You can decompose binary addition into two parts: the per-digit sum without carry (XOR) and the carry (AND shifted left). By repeating this decomposition until the carry becomes zero, you obtain the final sum.

## Thought Process

1. **Think about addition at the bit level**: When you add each digit of two binary numbers and ignore the carry, the result is 1 only when exactly one of the two bits is 1. This is exactly the XOR operation (`a ^ b`).
2. **Calculate the carry separately**: A carry occurs when both bits are 1. The AND operation (`a & b`) identifies these positions. Because the carry affects the next higher digit, you shift the result left by one bit (`(a & b) << 1`).
3. **You need to add the carry to the sum**: Adding the XOR result and the carry gives the final sum, but you cannot use `+`. However, this reduces to the same problem of adding two numbers, so you can apply the same process recursively.
4. **Define the base case for the recursion**: When the carry `b` becomes zero, no value remains to add, so the current `a` is the final sum. This serves as the base case.
5. **The recursion always terminates because integers have finite bit width**: Each left shift moves the carry bits to higher positions. For a 32-bit integer, the carry is guaranteed to reach zero within at most 32 recursive calls.

## Prerequisites

### XOR (Exclusive OR) Operation

XOR is a bitwise operation that returns 1 when the two bits differ and 0 when they are the same. It produces the same result as addition without carry.

```java
int result = 5 ^ 3;   // 0101 ^ 0011 = 0110 → 6
int result2 = 7 ^ 7;  // 0111 ^ 0111 = 0000 → 0 (XOR of identical values is 0)
```

### AND Operation

AND is a bitwise operation that returns 1 only when both bits are 1. You use it to identify the digit positions where a carry occurs.

```java
int result = 5 & 3;   // 0101 & 0011 = 0001 → 1
int result2 = 6 & 3;  // 0110 & 0011 = 0010 → 2
```

### Left Shift Operation

The left shift operation moves a bit sequence to the left by the specified number of positions and fills the vacated right-side bits with 0. A one-bit left shift has the effect of doubling the value. Because a carry affects the next higher digit, a one-bit left shift moves it to the correct digit position.

```java
int result = 1 << 1;  // 0001 → 0010 → 2
int result2 = 3 << 1; // 0011 → 0110 → 6
```

### How Binary Addition Works

Binary addition works the same way as long addition in decimal: you add each digit and propagate the carry to the next higher digit.
Example: `5 + 3` (`0101 + 0011`):
- XOR (sum without carry): `0101 ^ 0011 = 0110` (6)
- AND + left shift (carry): `(0101 & 0011) << 1 = 0001 << 1 = 0010` (2)
- Add 6 and 2 using the same method → `0110 ^ 0010 = 0100` (4), `(0110 & 0010) << 1 = 0100` (4)
- Add 4 and 4 → `0100 ^ 0100 = 0000` (0), `(0100 & 0100) << 1 = 1000` (8)
- Add 0 and 8 → `0000 ^ 1000 = 1000` (8), carry is 0 → done. The result is **8**

## Complexity

| | Value |
|---|---|
| Time | O(1) — For 32-bit integers, the carry shift terminates in at most 32 iterations, so the recursion completes in a constant number of calls |
| Space | O(1) — The recursion depth is also at most 32, which is constant, and the algorithm uses no additional data structures |

## Code

```java
// Input: two integers a and b
// Output: return the sum of a and b as an int
public int getSum(int a, int b) {
    // Base case: if the carry (b) is zero, no value remains to add, so a is the final sum
    if (b == 0) return a;

    // a ^ b: compute the per-digit sum ignoring carry (XOR returns 1 when the two bits differ)
    // (a & b) << 1: compute the carry (AND identifies digits where both are 1, left shift moves it to the next digit position)
    // With each recursive call, the carry bits move to higher positions, and for 32-bit integers this is guaranteed to reach zero within at most 32 calls
    return getSum(a ^ b, (a & b) << 1);
}
```
