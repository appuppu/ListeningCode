# Adding One to a Number Represented as an Array

## Problem

The system receives an array `digits` that stores a non-negative integer one digit per element. The first element of the array represents the most significant digit, and the last element represents the least significant digit. The task is to add 1 to this number and return the result as an array in the same format. Each element is a single digit from 0 to 9.

## Key Insight

The algorithm adds 1 starting from the last digit and returns immediately once no carry occurs. A carry occurs only when the current digit is 9, and the array length increases by one only when all digits are 9.

## Thought Process

1. **Addition starts from the least significant digit**: Since numerical addition naturally begins at the ones place, the algorithm traverses the array in reverse order from the end to the beginning.
2. **Consider the condition that stops the carry**: If the current digit is less than 9, adding 1 does not produce a carry. At that point, the addition is complete, so the algorithm can return the array immediately.
3. **Consider the case when the digit is 9**: When the current digit is 9, adding 1 produces 10 and generates a carry. The algorithm sets this digit to 0 and propagates the carry to the next higher digit. The next iteration of the loop naturally performs the addition of 1 to the higher digit.
4. **Consider the case when all digits are 9**: When all digits are 9, such as 999, the loop runs to completion without the carry stopping. The result becomes 1000, which has one more digit. Only in this case does the algorithm create a new array and set the first element to 1. Because `new int[]` in Java initializes all elements to 0, there is no need to explicitly assign 0 to the remaining digits.
5. **There is no need to manage the carry with a variable**: The carry value is always 1, and the fact that the loop is still running guarantees that a carry exists. This structure allows the loop continuation itself to represent the existence of a carry, eliminating the need for a separate carry variable.

## Prerequisites

### Reverse Traversal of an Array

A reverse traversal loops from the end of the array to the beginning. The index starts at `i = n - 1` and decrements with `i--` while `i >= 0`.

```java
int[] digits = {1, 2, 3};
int n = digits.length;                  // Get the array length → 3
for (int i = n - 1; i >= 0; i--) {      // Loop in the order i=2, 1, 0
    System.out.println(digits[i]);      // Output in the order 3, 2, 1
}
```

### Array Initialization in Java

Creating an integer array with `new int[n]` automatically initializes all elements to 0. There is no need to explicitly assign 0.

```java
int[] result = new int[4];   // Initialized to {0, 0, 0, 0}
result[0] = 1;               // Becomes {1, 0, 0, 0}
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm traverses the array from end to beginning at most once |
| Space | O(1) — Except when all digits are 9, the algorithm modifies the input array in place and requires no additional memory |

## Code

```java
// Input: an integer array digits storing each digit of a non-negative integer
// Output: returns an int[] containing the result of adding 1 to the number represented by digits
public int[] plusOne(int[] digits) {
    // Store the array length. Used as the loop bound for reverse traversal and as the length of the new array when all digits are 9
    int n = digits.length;

    // Traverse from the end to the beginning. The loop continuing itself means "a carry exists"
    for (int i = n - 1; i >= 0; i--) {
        // If the current digit is less than 9, no carry occurs. Add 1 and return immediately
        if (digits[i] < 9) {
            digits[i]++;
            return digits;  // No carry. Return the modified array as is
        }
        // The current digit is 9, so set it to 0 and propagate the carry to the higher digit
        digits[i] = 0;
    }

    // All digits were 9 (e.g., [9,9,9] → [0,0,0]), so the number of digits increases by one
    // new int[] initializes all elements to 0, so there is no need to assign 0 to the remaining digits
    int[] result = new int[n + 1];
    result[0] = 1;  // Set the first element to 1 (e.g., 999 + 1 = 1000 → [1, 0, 0, 0])
    return result;
}
```
