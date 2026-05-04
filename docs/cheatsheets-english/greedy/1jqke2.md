# Determining if You Can Reach the End of an Array

## Problem

You are given an integer array `nums`. Each element `nums[i]` represents the **maximum jump length** forward from that index. Starting from index `0`, return a `boolean` indicating whether you can reach the **last index** of the array.

## Key Insight

If you keep updating the "farthest reachable point from here" at each position, you can determine that the end is unreachable the moment that farthest point falls behind the current position. You do not need to track individual jump paths — a single value representing "the farthest index reachable so far" is sufficient.

## Thought Process

1. **Reachability is determined by the farthest point**: You can determine whether index `i` is reachable by checking if the "farthest reachable index" computed from all previous elements is greater than or equal to `i`. The details of intermediate paths are irrelevant — only the farthest point matters.
2. **A single variable can track the farthest point**: At each index `i`, the expression `i + nums[i]` gives the farthest point reachable from that position. By keeping the maximum of this value and the previous farthest point, you can track the entire reachable range with one variable.
3. **Condition for unreachability**: When scanning the array from left to right, if the current index `i` exceeds the farthest point `maxReach`, then index `i` is unreachable in the first place. In other words, `i > maxReach` is the unreachability condition.
4. **Early termination condition**: Once `maxReach` becomes greater than or equal to the last index `nums.length - 1`, you can confirm that the end is reachable and skip the remaining traversal by returning `true`.
5. **When the loop completes without termination**: If the loop finishes without returning `false` or `true` early, all indices were reachable, so you return `true`.

## Prerequisites

### What is Math.max

`Math.max` is a static method that takes two integers and returns the larger value. You use it to compare the "current farthest point" with the "newly computed reachable point" when updating the farthest point.

```java
Math.max(3, 5);    // returns 5 — the larger of the two arguments
Math.max(7, 2);    // returns 7
Math.max(4, 4);    // returns 4 — returns that value when both are equal
```

### What is maxReach (farthest reachable index)

`maxReach` is a variable representing the farthest reachable index considering all elements from the start of the array to the current position. At index `i`, the expression `i + nums[i]` gives the farthest point reachable from that position, and `maxReach = Math.max(maxReach, i + nums[i])` always retains the maximum value.
Example: Given `nums = [2, 3, 1, 1, 4]`, at `i=0` you get `maxReach = 0 + 2 = 2`, and at `i=1` you get `maxReach = max(2, 1 + 3) = 4`, which confirms that the last index `4` is reachable.

## Complexity

| | Value |
|---|---|
| Time | O(n) — You only need a single pass through the array |
| Space | O(1) — The only additional variable is `maxReach` |

## Code

```java
// Input: integer array nums (each element is the max jump length from that index)
// Output: return true if the last index is reachable, false otherwise
boolean canJump(int[] nums) {
    // Variable to track the farthest reachable index so far
    // Starting point is index 0, so the initial value is 0
    int maxReach = 0;

    // Scan the array one element at a time from start to end
    for (int i = 0; i < nums.length; i++) {
        // If the current index exceeds the farthest reachable point, this index is unreachable
        if (i > maxReach) return false;

        // i + nums[i] is the farthest index reachable from the current position
        // Keep the larger value between the current maxReach and the new reach
        maxReach = Math.max(maxReach,
            i + nums[i]);

        // If the farthest reachable point is at or beyond the last index, the end is reachable
        if (maxReach >= nums.length - 1)
            return true;
    }
    // If the loop completes, all indices were reachable, so return true
    return true;
}
```
