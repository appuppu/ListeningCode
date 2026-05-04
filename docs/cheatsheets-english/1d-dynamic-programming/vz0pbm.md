# Finding the Minimum Cost to Climb Stairs

## Problem

You are given an integer array `cost`, where `cost[i]` represents the cost of stepping on the i-th stair. You can start from either step 0 or step 1, and at each step you can climb 1 or 2 stairs. Return the minimum total cost to reach the **top** of the staircase (one position past the end of the array).

## Key Insight

The minimum cost to reach each stair is determined by the lesser of "coming from 1 stair before" and "coming from 2 stairs before." This calculation requires only the two most recent results, so you can compute the minimum cost using just two variables instead of an entire array.

## Thought Process

1. **There are two ways to reach the top**: You can reach the top (index n) either by climbing 1 stair from the previous stair (n-1) or by climbing 2 stairs from two stairs back (n-2). The lesser cost of the two is the answer.
2. **You can define the minimum cost to each stair recursively**: If you let `dp[i]` be the minimum cost to reach stair i, the recurrence `dp[i] = min(dp[i-1] + cost[i-1], dp[i-2] + cost[i-2])` holds. You choose the lesser of "the minimum cost to 1 stair before plus that stair's cost" and "the minimum cost to 2 stairs before plus that stair's cost."
3. **Determine the base cases**: Since you can start from step 0 or step 1, the cost to reach stair 0 and stair 1 is both 0. That is, `dp[0] = 0` and `dp[1] = 0`.
4. **You only need the two most recent values, not the entire array**: The recurrence `dp[i]` depends only on `dp[i-1]` and `dp[i-2]`. Therefore, you can compute the result by keeping just two variables, `prev1` (1 stair before) and `prev2` (2 stairs before), instead of an array.
5. **Advance forward while updating the variables**: Loop from stair 2 to stair n, compute `curr` each iteration, then slide the variables by setting `prev2 = prev1` and `prev1 = curr`. The value of `prev1` at the end of the loop is the minimum cost to reach the top.

## Prerequisites

### Dynamic Programming

Dynamic programming is a technique that divides a large problem into smaller subproblems and reuses the results of those subproblems to find the solution efficiently. In this problem, you treat "the minimum cost to reach stair i" as a subproblem and solve from the smallest index upward (bottom-up approach).

### Math.min

`Math.min` is a standard Java method that returns the smaller of two integers. You use it to select the lower-cost option from two choices.

```java
Math.min(5, 3);    // Returns 3 — returns the smaller of the two arguments
Math.min(10, 10);  // Returns 10 — returns that value when both arguments are equal
```

### Space Optimization

When each element of a DP array depends on only a few preceding elements, you can compute the result using just the necessary number of variables instead of maintaining the entire array. In this problem, only `dp[i-1]` and `dp[i-2]` are needed, so two variables are sufficient.

```java
int prev2 = 0;  // Variable corresponding to dp[i-2]
int prev1 = 0;  // Variable corresponding to dp[i-1]
int curr;       // Variable corresponding to dp[i] (computed and updated each iteration)
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — You only need a single pass through the array |
| Space | O(1) — You use only two variables, independent of the array size |

## Code

```java
// Input: integer array cost (the cost of stepping on each stair)
// Output: return the minimum total cost to reach the top of the staircase (index n) as an int
public int minCostClimbingStairs(int[] cost) {
    // Get the length of the array. The top is at index n (one position past the end of the array)
    int n = cost.length;

    // prev2 = minimum cost to reach 2 stairs before, prev1 = minimum cost to reach 1 stair before
    // Since you can start from step 0 or step 1, the initial cost is 0
    int prev2 = 0, prev1 = 0;

    // Compute the minimum cost from stair 2 to the top (stair n). i is the stair you are currently trying to reach
    for (int i = 2; i <= n; i++) {
        // prev1 + cost[i-1]: total cost of climbing 1 stair from the previous stair
        // prev2 + cost[i-2]: total cost of climbing 2 stairs from two stairs back
        // Choose the smaller value
        int curr = Math.min(
            prev1 + cost[i - 1],
            prev2 + cost[i - 2]);

        // Slide the variables forward by one position
        // Note: you must update prev2 first, otherwise the original value of prev1 is lost
        prev2 = prev1;
        prev1 = curr;
    }

    // prev1 holds the minimum cost to reach the top, computed in the last iteration (i = n) of the loop
    return prev1;
}
```
