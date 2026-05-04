# Counting Bits for Every Number Up to N — Return an array containing the number of 1-bits in each integer from 0 to N

## Problem

The function receives a non-negative integer `n`. It returns an array of length `n + 1`. The element at index `i` of the array stores **the number of 1-bits** in the binary representation of `i`. Example: when n=5, 0→0, 1→1, 2→1, 3→2, 4→1, 5→2, so the function returns `[0,1,1,2,1,2]`.

## Key Insight

The number of 1-bits in any integer `i` equals the number of 1-bits in the value `i >> 1` (obtained by right-shifting `i` by one bit) plus the least significant bit of `i` (`i & 1`). This recursive relationship allows the algorithm to reuse results from smaller values and compute each value in O(1) time.

## Thought Process

1. **Focus on the structure of binary representation**: Right-shifting the binary representation of integer `i` by one bit removes the least significant bit, and the remaining bit string becomes identical to `i / 2` (rounded down). This means the bit string of `i` has the structure of "the bit string of `i >> 1`" + "the least significant bit"
2. **Decompose the count of 1-bits**: From the structure above, the number of 1s in `i` decomposes into "the number of 1s in `i >> 1`" + "whether the least significant bit is 1 (0 or 1)". The formula is `countBits(i) = countBits(i >> 1) + (i & 1)`
3. **Computing from small values enables reuse**: Since `i >> 1` is always smaller than `i`, computing sequentially from `i = 0` guarantees that `result[i >> 1]` is already computed. This property allows a forward loop instead of recursion
4. **The result array itself serves as the DP table**: The algorithm uses the return array `result` directly as the DP table. It sets `result[0] = 0` as the base case and fills from `i = 1` to `n` using `result[i] = result[i >> 1] + (i & 1)`. No additional data structures are needed

## Prerequisites

### Right Shift Operation (`>>`)

The right shift operation shifts the binary representation of an integer to the right by a specified number of bits. Right-shifting by one bit removes the least significant bit, and the resulting value becomes the quotient of division by 2 (rounded down).

```java
int a = 6;      // binary: 110
int b = a >> 1;  // binary: 011 → value is 3 (6 ÷ 2 = 3)

int c = 7;      // binary: 111
int d = c >> 1;  // binary: 011 → value is 3 (7 ÷ 2 = 3, rounded down)
```

### Bitwise AND Operation (`&`)

The bitwise AND operation compares each bit of two integers and sets only the bits where both are 1. The expression `i & 1` extracts only the least significant bit of `i`, returning 1 if `i` is odd and 0 if `i` is even.

```java
int a = 5;       // binary: 101
int b = a & 1;   // binary: 001 → value is 1 (odd, so the least significant bit is 1)

int c = 4;       // binary: 100
int d = c & 1;   // binary: 000 → value is 0 (even, so the least significant bit is 0)
```

### Dynamic Programming (DP)

Dynamic programming is a technique that divides a large problem into smaller subproblems and records the results of those subproblems in an array for reuse. In this problem, the algorithm uses `result[i >> 1]` (the already-computed result for a smaller value) to compute `result[i]` in O(1) time.

```java
int[] result = new int[n + 1];  // Create a DP table that also serves as the result array
result[0] = 0;                  // Base case: the number of 1-bits in 0 is 0
result[i] = result[i >> 1] + (i & 1);  // Transition: reuse the already-known result
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm performs only one bit shift and one AND operation for each value from 1 to n |
| Space | O(n) — The algorithm uses an array of length n+1 to store the results (since this array is the output itself, the additional space can also be interpreted as O(1)) |

## Code

```java
// Input: non-negative integer n
// Output: int[] of length n+1. Each result[i] stores the number of 1-bits in the binary representation of i
public int[] countBits(int n) {
    // Create a DP table that also serves as the result array. new int[n+1] initializes all elements to 0,
    // so result[0] = 0 (the number of 1-bits in 0 is 0) is automatically satisfied
    int[] result = new int[n + 1];

    // Since i=0 is already correct at 0, the loop starts from i=1
    for (int i = 1; i <= n; i++) {
        // result[i >> 1]: the number of 1-bits in the value obtained by right-shifting i by 1 bit (already computed since i >> 1 is always less than i)
        // i & 1: the least significant bit of i (1 if odd, 0 if even)
        // Adding these two values yields the total number of 1s in the binary representation of i
        result[i] = result[i >> 1] + (i & 1);
    }
    // Return the array where each element result[i] stores the number of 1-bits for index i
    return result;
}
```
