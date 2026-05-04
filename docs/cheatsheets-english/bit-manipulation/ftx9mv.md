# Counting the Number of Set Bits — Count the number of 1-bits in the binary representation of an integer

## Problem

You are given a non-negative integer `n`. Return the number of bits set to 1 (Hamming weight) in the binary representation of `n`.

## Key Insight

The operation `n & (n - 1)` clears exactly one bit — the lowest set bit of `n`. If you repeat this operation until `n` becomes 0, the number of iterations equals the number of set bits.

## Thought Process

1. **We want to count only the set bits efficiently**: Instead of scanning all 32 bits, we can process only the positions where a 1-bit exists, achieving a runtime proportional to the number of set bits `k`
2. **We consider how to clear the lowest set bit**: Computing `n - 1` flips the lowest set bit of `n` to 0 and sets all lower bits to 1. For example, when `n = 1100`, `n - 1 = 1011`
3. **n AND (n - 1) clears only the lowest set bit**: Taking the AND of `n` and `n - 1` zeros out all bits at and below the lowest set bit, while preserving all higher bits. `1100 & 1011 = 1000`, so exactly one set bit has been removed
4. **We repeat the clearing operation and count**: By repeatedly applying `n &= (n - 1)` and counting how many times we do so until `n` becomes 0, we obtain the number of set bits in the original `n`
5. **Loop termination condition**: Once all set bits have been cleared, `n` becomes 0. Using `n != 0` as the loop condition ensures the loop runs exactly as many times as there are set bits and then terminates naturally

## Prerequisites

### Bitwise AND Operation (&)

The bitwise AND compares each bit of two integers and produces a 1 only when both bits are 1. All other combinations produce 0.

```java
int a = 0b1100;       // 1100 in binary
int b = 0b1010;       // 1010 in binary
int result = a & b;   // Result is 0b1000 (only positions where both bits are 1 remain 1)
```

### How n & (n - 1) Works

Subtracting 1 from `n` flips the lowest set bit to 0 and sets all lower bits to 1. Taking the AND with `n` zeros out all bits at and below the lowest set bit.

```java
int n = 0b1100;       // n     = 1100 (2 set bits)
n &= (n - 1);        // n - 1 = 1011, n = 1100 & 1011 = 1000 (set bits reduced to 1)
n &= (n - 1);        // n - 1 = 0111, n = 1000 & 0111 = 0000 (set bits reduced to 0)
```

### Hamming Weight

Hamming weight is the number of 1-bits in the binary representation of an integer. For example, the binary form of `11` is `1011`, so its Hamming weight is 3.

## Complexity

| | Value |
|---|---|
| Time | O(k) — k is the number of set bits in `n`. The loop executes exactly k times |
| Space | O(1) — The algorithm uses only a single counter variable |

## Code

```java
// Input: a non-negative integer n
// Output: return the number of 1-bits in the binary representation of n as an int
public int hammingWeight(int n) {
    // Counter that records how many set bits have been cleared. The total count becomes the final answer
    int count = 0;

    // If n is 0, no set bits remain, so the loop terminates
    while (n != 0) {
        // Clear the lowest set bit (Brian Kernighan's Trick)
        // n - 1 flips all bits at and below the lowest set bit, and ANDing with n zeros out all those positions
        n &= (n - 1);
        // One set bit has been cleared, so increment the count
        count++;
    }
    // count holds the total number of cleared set bits, which equals the number of set bits in the original n
    return count;
}
```
