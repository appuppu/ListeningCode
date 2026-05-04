# Maximizing Coins From Bursting Balloons — Optimize the Order of Bursting Balloons to Maximize Coins

## Problem

You are given an integer array `nums` where each element represents the value of a balloon. When you burst balloon `i`, you earn `nums[left] * nums[i] * nums[right]` coins, where `left` and `right` are the adjacent remaining balloons. You must return the maximum number of coins you can earn by bursting all the balloons. Values outside the array boundaries are treated as `1`.

## Key Insight

Instead of thinking about "which order to burst balloons in," you reverse the perspective and ask "which balloon to burst **last**" within the interval `[left, right]`. Once you fix the last-burst balloon `k`, the left and right subintervals become independent of each other, and you can combine optimal solutions using interval DP.

## Thought Process

1. **You need to eliminate the dependency on burst order**: Bursting a balloon changes the adjacency relationships, so the coins you earn depend on the burst order. Exhaustively searching all orderings yields `n!` possibilities, which is impractical. You need a perspective that breaks this dependency.
2. **Thinking about "bursting last" makes the intervals independent**: If you decide to burst balloon `k` last within interval `[left, right]`, then at the moment you burst `k`, all balloons in `[left, k-1]` and `[k+1, right]` have already been removed. This means the neighbors of `k` are fixed to `arr[left-1]` and `arr[right+1]`, which lie outside the interval. The left and right subproblems become independent, so you can combine them with DP.
3. **You simplify boundary handling**: You create a new array `arr` by adding virtual balloons with value `1` at both ends of the original array. By setting `arr[0] = 1` and `arr[n+1] = 1`, you can uniformly use the formula `arr[left-1] * arr[k] * arr[right+1]` without special-casing the boundary conditions.
4. **You define the DP table**: You define `dp[left][right]` as "the maximum coins you can earn by bursting all balloons in the interval `[left, right]`." The final answer is `dp[1][n]`, which corresponds to the entire original array.
5. **You fill the table from shorter intervals to longer ones**: You start with intervals of length 1 (a single balloon) and build up to intervals of length `n`. Since longer intervals depend on shorter intervals, computing from shortest to longest guarantees that all referenced values are already computed.
6. **You try every balloon as the last one to burst in each interval**: For interval `[left, right]`, you try each balloon `k` from `left` to `right` as the last one to burst. The coins earned when `k` is burst last are `arr[left-1] * arr[k] * arr[right+1] + dp[left][k-1] + dp[k+1][right]`, and you record the maximum of these values in `dp[left][right]`.

## Prerequisites

### Interval DP

Interval DP is a technique that builds a DP table using intervals `[left, right]` as the unit. You split intervals into subintervals, combine the optimal solutions of the subintervals to find the overall optimal solution, and compute bottom-up from shorter intervals to longer ones.

```java
// Basic structure of interval DP: compute from shorter intervals to longer ones
for (int len = 1; len <= n; len++) {        // interval length
    for (int left = 1; left <= n - len + 1; left++) {  // left endpoint of the interval
        int right = left + len - 1;          // right endpoint of the interval
        // compute dp[left][right]
    }
}
```

### Sentinel

A sentinel is a technique where you add virtual elements at both ends of an array to eliminate the need for special boundary handling. In this problem, you place balloons with value `1` at both ends.

```java
int[] arr = new int[n + 2];   // create an array 2 larger than the original
arr[0] = 1;                   // left sentinel (value 1)
arr[n + 1] = 1;               // right sentinel (value 1)
for (int i = 0; i < n; i++)
    arr[i + 1] = nums[i];     // copy original elements to indices 1 through n
```

### 2D Array DP Table

You use `dp[i][j]` to store the optimal solution for interval `[i, j]`. In Java, creating the array with `new int[n+2][n+2]` initializes all elements to `0`. Empty intervals (where `left > right`) can remain `0`, so no additional initialization is needed.

```java
int[][] dp = new int[n + 2][n + 2];  // all elements are initialized to 0
dp[left][right];                      // stores the maximum coins for interval [left, right]
```

## Complexity

| | Value |
|---|---|
| Time | O(n³) — three nested loops for the left endpoint, right endpoint, and last-burst position |
| Space | O(n²) — the DP table `dp[n+2][n+2]` |

## Code

```java
// Input: integer array nums (value of each balloon)
// Output: return the maximum coins earned by bursting all balloons as an int
public int maxCoins(int[] nums) {
    int n = nums.length;

    // Create an array with sentinels (value 1) added at both ends
    // These sentinels eliminate the need for special boundary handling when referencing outside the interval
    int[] arr = new int[n + 2];
    arr[0] = arr[n + 1] = 1;
    for (int i = 0; i < n; i++)
        arr[i + 1] = nums[i];

    // dp[left][right] = maximum coins earned by bursting all balloons in interval [left, right]
    // The size is n+2 to include the sentinel indices (0 and n+1)
    // Empty intervals (left > right) can remain 0
    int[][] dp = new int[n + 2][n + 2];

    // Compute from shorter intervals to longer ones
    // Computing shorter intervals first guarantees that all subinterval values are already computed when processing longer intervals
    for (int len = 1; len <= n; len++) {
        // Iterate over all intervals of length len
        for (int left = 1; left <= n - len + 1; left++) {
            int right = left + len - 1;

            // Try every balloon k as the last one to burst in interval [left, right]
            for (int k = left; k <= right; k++) {
                // When k is chosen as the last balloon to burst, its neighbors are fixed to arr[left-1] and arr[right+1] outside the interval
                int coins = arr[left - 1] * arr[k] * arr[right + 1];
                // Add the coins from the left and right subintervals to compute the total
                int total = coins + dp[left][k - 1] + dp[k + 1][right];
                // Update dp[left][right] with the maximum value
                dp[left][right] = Math.max(dp[left][right], total);
            }
        }
    }

    // Return the maximum coins for the entire original array (indices 1 through n)
    return dp[1][n];
}
```
