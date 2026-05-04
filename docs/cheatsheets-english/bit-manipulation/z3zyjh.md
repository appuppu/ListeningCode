# Finding the Number That Appears Only Once

## Problem

The system receives an integer array `nums`. Every element in the array appears exactly twice, except for one element that appears only once. The function returns **the element that appears only once**.

## Key Insight

The XOR operation has the property that XORing the same value twice produces 0. When the system XORs all elements in the array together, every element that appears twice cancels out to 0, and only the element that appears once remains.

## Thought Process

1. **Eliminating duplicate pairs leaves the answer**: If the system removes all elements that appear twice from the array, the element that appears only once remains. The goal is to find an operation that efficiently performs this "pair elimination."
2. **Leveraging the self-inverse property of XOR**: The XOR operation has the property `a ^ a = 0`. XORing the same value twice produces 0. This means elements that appear twice are automatically eliminated.
3. **Leveraging the identity element and associativity of XOR**: `a ^ 0 = a` (XORing with 0 does not change the value), and XOR satisfies both the associative and commutative laws. Therefore, regardless of the order in which elements appear, XORing all elements together eliminates pairs and leaves only the unique element.
4. **Computing a cumulative XOR with a single variable**: The system initializes a variable `result` to 0 and XORs each element while iterating through the array. The value remaining in `result` after the iteration completes is the answer.
5. **No additional data structures are needed**: The algorithm requires only a single integer variable without using a HashSet or HashMap, so the space complexity is O(1).

## Prerequisites

### XOR (Exclusive OR)

XOR is a bitwise operation that returns 1 when two bits differ and 0 when they are the same. Java represents XOR with the `^` operator. When applied to integers, the operation performs XOR at each bit position.

```java
int a = 5;          // binary: 101
int b = 3;          // binary: 011
int c = a ^ b;      // binary: 110 → 6
```

### Important Properties of XOR

The XOR operation has the following three properties, and solving this problem requires all of them.

```java
// 1. Self-inverse: XORing the same value twice produces 0
a ^ a;    // → 0

// 2. Identity element: XORing with 0 does not change the original value
a ^ 0;    // → a

// 3. Commutative and associative laws: Reordering operands does not change the result
a ^ b ^ a;    // → (a ^ a) ^ b → 0 ^ b → b
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm requires only a single pass through the array |
| Space | O(1) — The algorithm uses only a single integer variable without any additional data structures |

## Code

```java
// Input: integer array nums (every element appears twice, except one element that appears once)
// Output: returns the element that appears only once as an int
public int singleNumber(int[] nums) {
    // Initial value for cumulative XOR. 0 is the identity element of XOR, so XORing any value with 0 does not change that value
    int result = 0;

    // The for-each loop iterates through each element of the array from the first to the last
    for (int num : nums) {
        // The system computes the XOR of the current result and num, then assigns the result back to result
        // Elements that appear twice cancel out via a ^ a = 0, and only the element that appears once accumulates
        result ^= num;
    }

    // After the loop completes, all pairs have canceled out, and only the value of the element that appears once remains
    return result;
}
```
