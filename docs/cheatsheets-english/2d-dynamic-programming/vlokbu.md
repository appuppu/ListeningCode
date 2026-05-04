# Counting Ways to Assign Signs to Reach a Target Sum

## Problem

The problem gives you an integer array `nums` and an integer `target`. You assign either a `+` or `-` sign to each element in `nums` and return the number of combinations where the total sum of all elements equals `target`.

## Key Insight

Assigning `+` or `-` to each element is equivalent to partitioning the array into a "positive sign group (P)" and a "negative sign group (N)." Since P - N = target and P + N = totalSum, you can derive P = (target + totalSum) / 2. This transforms the problem into a subset sum problem: "count the number of subsets whose sum equals P."

## Thought Process

1. **Reframe sign assignment as set partitioning**: Let P be the sum of elements assigned `+` and N be the sum of elements assigned `-`. Then P - N = target holds. At the same time, P + N = totalSum (the sum of all elements) also holds. Solving these two equations simultaneously yields P = (target + totalSum) / 2.
2. **Eliminate impossible cases first**: If P = (target + totalSum) / 2 is not an integer (i.e., `(target + totalSum)` is odd), no valid partition exists. If `|target|` exceeds `totalSum`, no solution exists either. The algorithm checks these conditions first and returns 0.
3. **Solve as a subset sum problem using DP**: "Count the number of ways to select elements from `nums` so that their sum equals `subsetSum` (= P)" is a classic subset sum counting problem. Define a DP array `dp[j]` as "the number of subsets whose sum equals j" and update it for each element.
4. **Optimize space with a 1D DP array**: Instead of using a 2D table, prepare a 1D array `dp[0..subsetSum]`. For each element `num`, iterate `j` from `subsetSum` down to `num` in reverse order and update `dp[j] += dp[j - num]`. The reverse iteration prevents using the same element multiple times.
5. **Set the initial condition**: Set `dp[0] = 1`. This means there is exactly one way to make a sum of 0 by selecting no elements.
6. **Return the final answer**: After processing all elements, `dp[subsetSum]` gives the number of subsets whose sum equals `subsetSum`, which is the answer to the original problem.

## Prerequisites

### Subset Sum Problem

The subset sum problem asks you to select elements from a given set so that their sum equals a specific value. It is a variant of the knapsack problem, and DP solves it efficiently.

### 1D DP Array for Subset Sum Counting

`dp[j]` represents the number of subsets whose sum equals j. For each element `num`, the recurrence updates as `dp[j] += dp[j - num]`.

```java
int[] dp = new int[targetSum + 1]; // dp[j] = number of combinations that sum to j
dp[0] = 1;                         // there is 1 way to make sum 0 (select nothing)
dp[j] += dp[j - num];              // using num to make j = add the number of ways to make j - num without using num
```

### Reason for Reverse Iteration

The inner loop iterates from `subsetSum` down to `num`. If you iterate forward, the same element `num` would be added multiple times within the same iteration. Reverse iteration ensures the 0-1 knapsack constraint where each element is either selected or not.

```java
// Reverse loop: use each element at most once (0-1 knapsack)
for (int j = subsetSum; j >= num; j--) {
    dp[j] += dp[j - num];
}
```

## Complexity

| | Value |
|---|---|
| Time | O(n × subsetSum) — the algorithm scans the DP array once for each element |
| Space | O(subsetSum) — the algorithm uses only a 1D DP array |

## Code

```java
// Input: an integer array nums and an integer target
// Output: return the number of combinations as an int where assigning +/- to each element yields a sum equal to target
public int findTargetSumWays(int[] nums, int target) {
    // Calculate the sum of all elements in nums and store it in totalSum
    int totalSum = 0;
    for (int num : nums) {
        totalSum += num;
    }

    // Check conditions where no solution exists
    // If (target + totalSum) is odd, P = (target + totalSum) / 2 is not an integer,
    // so no subset of integer elements can achieve it — return 0
    // If |target| exceeds totalSum, no sign assignment can reach target — return 0
    if ((target + totalSum) % 2 != 0
        || Math.abs(target) > totalSum)
        return 0;

    // Calculate the target sum for the positive sign group — this becomes the target for the rest of the algorithm
    int subsetSum = (target + totalSum) / 2;

    // dp[j] = number of ways to select elements from nums so that their sum equals j
    int[] dp = new int[subsetSum + 1];
    // Base case: there is exactly 1 way to make sum 0 — select no elements
    dp[0] = 1;

    // Outer loop: iterate through each element in nums from first to last
    for (int num : nums) {
        // Inner loop: iterate from subsetSum down to num in reverse order
        // Reason for reverse: prevent using the same num multiple times within a single iteration (0-1 knapsack constraint)
        for (int j = subsetSum; j >= num; j--) {
            // Add the number of ways to make sum j - num without using num to the number of ways to make sum j using num
            dp[j] += dp[j - num];
        }
    }

    // dp[subsetSum] is the number of subsets that sum to subsetSum, which equals the total number of valid sign assignments in the original problem
    return dp[subsetSum];
}
```
