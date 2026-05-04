# Merging Triplets to Form a Target Triplet — Determine whether the element-wise maximum of triplets can form the target

## Problem

You are given a 2D array `triplets` where each element is a triplet of three integers, and a target triplet `target`. You must select any subset from `triplets`, take the element-wise maximum of the selected triplets, and determine whether the result exactly matches `target`. Return the answer as a **boolean**.

## Key Insight

A triplet that exceeds the target in any position cannot be used in the merge, because including it would cause that position to exceed the target. Conversely, if you merge only triplets whose elements are all less than or equal to the target, the result can never exceed the target. You simply need to check whether the accumulated maximum equals the target.

## Thought Process

1. **Identify unusable triplets**: If any element of a triplet `t` exceeds the corresponding element of `target`, including `t` in the merge would cause the maximum to exceed the target. Since the maximum can never decrease once it increases, such a triplet can never be selected.
2. **All usable triplets can be freely included**: A triplet whose elements are all less than or equal to `target` will never cause the merge result to exceed the target. Including it causes no harm, so you can greedily include all such triplets.
3. **Accumulate the merge result**: Initialize a result array `result` to `[0, 0, 0]`, then update each element of `result` by taking the maximum of itself and the corresponding element of each usable triplet. Using `Math.max` element-wise yields the element-wise maximum of all selected triplets.
4. **Final check**: After processing all triplets, return `true` if `result` exactly matches `target`, and `false` otherwise. Use `Arrays.equals` to compare all elements of the two arrays.

## Prerequisites

### What is element-wise maximum?

Element-wise maximum is the operation of comparing elements at the same position across two or more arrays and taking the largest value at each position. For example, the element-wise maximum of `[2, 5, 3]` and `[5, 1, 6]` is `[5, 5, 6]`.

```java
int[] a = {2, 5, 3};
int[] b = {5, 1, 6};
int[] merged = new int[3];
merged[0] = Math.max(a[0], b[0]);  // max(2, 5) → 5
merged[1] = Math.max(a[1], b[1]);  // max(5, 1) → 5
merged[2] = Math.max(a[2], b[2]);  // max(3, 6) → 6
// merged = [5, 5, 6]
```

### What is Math.max?

`Math.max` is a method that returns the larger of two values. You use it to accumulate the merge result.

```java
Math.max(3, 7);   // → 7
Math.max(5, 5);   // → 5
Math.max(0, 4);   // → 4 (used to update from the initial value 0)
```

### What is Arrays.equals?

`Arrays.equals` is a method that checks whether two arrays have the same length and identical elements at every position, returning a boolean. The `==` operator compares references, so you must use this method to compare array contents.

```java
int[] a = {2, 5, 3};
int[] b = {2, 5, 3};
a == b;              // → false (different references)
Arrays.equals(a, b); // → true (all elements match)
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — You only need a single pass through the triplets array (processing each triplet takes O(1)) |
| Space | O(1) — You only use the fixed-size array `result` of length 3 |

## Code

```java
// Input: a 2D integer array triplets (each element is a triplet of length 3) and an integer array target of length 3
// Output: true if the element-wise maximum of some subset of triplets can form target, false otherwise
public boolean mergeTriplets(int[][] triplets, int[] target) {
    // Initialize the array to accumulate the element-wise maximum of usable triplets to [0, 0, 0]
    int[] result = new int[3];

    // Iterate through each triplet t in triplets from beginning to end
    for (int[] t : triplets) {
        // Skip any triplet where any element exceeds the target, because including it would cause the maximum to exceed the target irreversibly
        if (t[0] > target[0] ||
            t[1] > target[1] ||
            t[2] > target[2])
            continue;

        // All elements are at most the target, so this update cannot cause result to exceed the target
        // Update the result with the maximum at each position
        result[0] = Math.max(result[0], t[0]);
        result[1] = Math.max(result[1], t[1]);
        result[2] = Math.max(result[2], t[2]);
    }

    // Check whether the accumulated result exactly matches the target and return the answer
    return Arrays.equals(result, target);
}
```
