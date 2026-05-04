# Determining if a Number is a Happy Number — Determine whether repeatedly summing the squares of each digit reaches 1

## Problem

You are given a positive integer `n`. You repeatedly square each digit of `n` and sum the results. If the result eventually reaches **1**, the number is a "happy number" and you return `true`. If the process enters an infinite loop without ever reaching 1, you return `false`.

## Key Insight

The operation of repeatedly summing the squares of each digit always cycles through a finite set of values. This structure is identical to cycle detection in a linked list, so you can use Floyd's slow and fast pointer technique to determine whether a cycle exists and what value it converges to, without any additional memory.

## Thought Process

1. **Repeated operations always produce a loop**: When you repeatedly compute the sum of squared digits, the values stay within a finite range, so the sequence must eventually revisit a previous value. This means the sequence always enters either a "loop that stays at 1" or a "loop that does not contain 1"
2. **Loop detection reduces to cycle detection**: If you treat each value-to-next-value transition as a "link from one node to another," this problem has the same structure as detecting a cycle in a linked list
3. **Floyd's two-pointer method detects cycles in O(1) space**: The slow pointer advances one step at a time, and the fast pointer advances two steps at a time. If a cycle exists, the two pointers will always meet somewhere within the cycle
4. **The meeting point determines the result**: When the two pointers meet, if the value is 1, the number is a happy number (because the sum of squared digits of 1 is 1, so 1 forms a cycle with itself). If the pointers meet at any value other than 1, the sequence has entered a cycle that does not contain 1, so the number is not a happy number
5. **Setting the initial values**: You set the slow pointer to `n` and the fast pointer to `getNext(n)`. This setup allows the `while (slow != fast)` loop to execute naturally from the start

## Prerequisites

### Computing the Sum of Squared Digits

To extract each digit of an integer `n`, you use `n % 10` to obtain the least significant digit, then `n /= 10` to remove the least significant digit. You repeat this operation until `n` becomes 0.

```java
int n = 19;
int digit = n % 10;   // Get the least significant digit → 9
n /= 10;              // Remove the least significant digit → n becomes 1
digit = n % 10;       // Get the next digit → 1
// 19 → 1² + 9² = 1 + 81 = 82
```

### Floyd's Cycle Detection (Two-Pointer Method)

Floyd's cycle detection is an algorithm that detects whether a linked list or sequence contains a cycle (loop). The slow pointer advances one step at a time, and the fast pointer advances two steps at a time. If a cycle exists, the fast pointer catches up to the slow pointer, and the two always meet. Because this method uses no additional data structures, the space complexity is O(1).

```java
int slow = start;                // The slow pointer advances one step at a time
int fast = getNext(start);       // The fast pointer starts one position ahead
while (slow != fast) {
    slow = getNext(slow);        // Advance one step
    fast = getNext(getNext(fast)); // Advance two steps
}
// When the loop ends, slow == fast is the value at the meeting point
```

## Complexity

| | Value |
|---|---|
| Time | O(log n) — Computing the sum of squared digits takes O(log n), and the number of iterations to reach the cycle is bounded by a constant |
| Space | O(1) — The algorithm uses only two variables: the slow pointer and the fast pointer |

## Code

```java
// Input: a positive integer n
// Output: return true if n is a happy number, false otherwise

// Helper function that computes and returns the sum of squared digits of integer n
// It extracts the least significant digit with n % 10, accumulates its square, and removes the digit with n /= 10
private int getNext(int n) {
    int sum = 0;
    while (n > 0) {
        int digit = n % 10;   // Extract the least significant digit
        sum += digit * digit;  // Add the square of the digit to sum
        n /= 10;               // Remove the least significant digit
    }
    return sum;
}

public boolean isHappy(int n) {
    // The slow pointer starts at n, and the fast pointer starts one step ahead at getNext(n)
    // Starting fast one step ahead allows the while (slow != fast) loop to execute naturally
    int slow = n;
    int fast = getNext(n);

    // Loop until the two pointers meet
    // The speed difference between slow and fast guarantees they will meet if a cycle exists
    while (slow != fast) {
        slow = getNext(slow);           // The slow pointer advances one step
        fast = getNext(getNext(fast));   // The fast pointer advances two steps
    }

    // If the meeting point is 1, the number is happy (the sum of squared digits of 1 is 1, so 1 forms a cycle with itself)
    // If the pointers meet at any other value, the sequence has entered a cycle that does not contain 1, so the number is not happy
    return fast == 1;
}
```
