# Finding the Duplicate in an Array of N Plus One Integers

## Problem

You are given an integer array `nums` of length n+1. Each element is in the range from 1 to n, and exactly one duplicate number exists. You must find and return the duplicate number without modifying the array and using only constant extra space.

## Key Insight

If you treat the relationship of moving from each index `i` to `nums[i]` as a "linked list," the links converge at the point where the duplicate number exists, creating a cycle. By using Floyd's Cycle Detection (the tortoise and hare algorithm), you can identify the entrance of the cycle — which is the duplicate number — in O(1) space.

## Thought Process

1. **Treat the array as an implicit linked list**: Consider the value `nums[i]` at index `i` as a "pointer to the next node." Starting from index 0, you traverse `nums[0]` → `nums[nums[0]]` → …, which behaves identically to traversing a linked list. Because the values range from 1 to n, the traversal never returns to index 0 and always points to a valid index.
2. **Understand why a duplicate creates a cycle**: When two different indices hold the same value, two arrows point toward the index of that value. This represents a state in a linked list where two nodes point to the same node, and a cycle begins from that convergence point. The entrance of the cycle is exactly the duplicate number.
3. **Detect the existence of the cycle**: The slow pointer advances one step at a time (`slow = nums[slow]`), and the fast pointer advances two steps at a time (`fast = nums[nums[fast]]`). If a cycle exists, the slow and fast pointers will always meet somewhere inside the cycle.
4. **Identify the entrance of the cycle**: After they meet, you reset the slow pointer to the start (`nums[0]`) and keep the fast pointer at its current position. You advance both pointers one step at a time, and they will meet again at the entrance of the cycle. The value corresponding to the index of this entrance is the duplicate number.
5. **Why they meet at the entrance**: It is mathematically proven that the distance from the start to the cycle entrance equals the distance from the meeting point to the cycle entrance. Therefore, when both pointers advance at the same speed, they converge at the entrance.

## Prerequisites

### Implicit Linked List

Even without creating actual node objects, you can represent the same structure as a linked list by interpreting the values in an array as "pointers to the next index." The "next node" of the node at index `i` is the node at index `nums[i]`.

```java
// Linked list traversal for the array nums = [1, 3, 4, 2, 2]
int current = nums[0];       // Value at index 0 → 1 (next goes to index 1)
current = nums[current];     // Value at index 1 → 3 (next goes to index 3)
current = nums[current];     // Value at index 3 → 2 (next goes to index 2)
current = nums[current];     // Value at index 2 → 4 (next goes to index 4)
current = nums[current];     // Value at index 4 → 2 (returns to index 2 → cycle)
```

### Floyd's Cycle Detection

Floyd's Cycle Detection is an algorithm that detects a cycle within a linked list and identifies its entrance. It uses two pointers (slow: one step at a time, fast: two steps at a time). If a cycle exists, the two pointers will always meet, and the subsequent procedure identifies the entrance of the cycle.

```java
// Phase 1: Meeting inside the cycle
slow = nums[slow];           // slow advances one step
fast = nums[nums[fast]];     // fast advances two steps

// Phase 2: Identifying the cycle entrance
slow = nums[slow];           // Both advance one step at a time
fast = nums[fast];           // The point where they meet is the cycle entrance
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — Each pointer traverses the linked list at most twice |
| Space | O(1) — The algorithm uses only two variables: slow and fast |

## Code

```java
// Input: An integer array nums of length n+1 (each element is between 1 and n inclusive, with exactly one duplicate)
// Output: Return the duplicate number as an int
public int findDuplicate(int[] nums) {
    // Initialize both slow and fast at the head of the linked list (nums[0])
    // Index 0 itself is not in the value range (1 to n), so it is never part of the cycle and serves as a safe starting point
    int slow = nums[0];
    int fast = nums[0];

    // Phase 1: Advance slow by 1 step and fast by 2 steps until they meet inside the cycle
    // Using do-while because the initial values are the same, so we need to skip the first comparison
    do {
        slow = nums[slow];           // Advance slow by one step
        fast = nums[nums[fast]];     // Advance fast by two steps (fast will always catch up if a cycle exists)
    } while (slow != fast);

    // Phase 2: Reset slow to the start and advance both by 1 step at a time
    // This leverages the property that the distance from start to entrance equals the distance from meeting point to entrance
    slow = nums[0];
    while (slow != fast) {
        slow = nums[slow];           // Both advance one step at a time
        fast = nums[fast];           // They will always meet at the cycle entrance
    }

    // The cycle entrance = the number pointed to by two different indices = the duplicate number
    return slow;
}
```
