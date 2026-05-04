# Counting Combinations to Make a Target Amount

## Problem

You are given an array `coins` containing coin denominations and an integer `amount`. You must return the **number of combinations** that make up exactly `amount` using coins from `coins`, where each coin can be used an unlimited number of times. Two combinations are different if they differ in the count of at least one denomination. Combinations that differ only in order are treated as the same combination.

## Key Insight

You process coins one denomination at a time, accumulating the number of combinations for "using zero or more of that coin" into the DP array. By iterating over coin denominations in the outer loop, you naturally eliminate duplicate counting of the same set of coins in different orders (permutations).

## Thought Process

1. **Distinguish between combinations and permutations**: This problem asks for the number of combinations, so you must count [1,2] and [2,1] as the same thing. If you place amounts in the outer loop and select coins in the inner loop, you end up counting permutations. Therefore, you must place coin denominations in the outer loop to fix the processing order.
2. **Define the DP state**: You define `dp[a]` as "the number of combinations that make exactly amount `a`." The final answer is `dp[amount]`.
3. **Determine the base case**: There is exactly one way to make amount 0, which is "use no coins at all," so you set `dp[0] = 1`. Without this base case, the combination count remains 0 no matter which coins you use, and the answer is always 0.
4. **Derive the transition formula**: To make amount `a` using at least one coin of denomination `coin`, you add the number of combinations for the remaining amount `a - coin`. The transition formula is `dp[a] += dp[a - coin]`. Since `dp[a - coin]` already contains the number of combinations using zero or more of the same coin, this addition automatically covers the cases of using 1, 2, 3, … of that coin.
5. **Determine the loop order**: The outer loop processes one coin denomination at a time, and the inner loop scans amounts `a` from `coin` to `amount` in ascending order. This way, each coin adds its contribution on top of "the number of combinations using only previous coin denominations," preventing duplicate counting of permutations.
6. **Determine the return value**: After processing all coins, `dp[amount]` is the total number of combinations that make the target amount.

## Prerequisites

### DP Array (1D Dynamic Programming Array)

A DP array stores the answers to subproblems in an array and reuses them to efficiently compute the answer to a larger problem. In this problem, `dp[a]` represents "the number of combinations that make amount `a`."

```java
int[] dp = new int[amount + 1];  // Create an array with indices 0 through amount (all initialized to 0)
dp[0] = 1;                       // Base case: there is 1 way to make amount 0
dp[a] += dp[a - coin];           // Transition: add the number of combinations for the remaining amount after using one coin
```

### Why Coins Must Be the Outer Loop

If you place amounts in the outer loop and coins in the inner loop, then when making amount 5, you count [1,2,2], [2,1,2], and [2,2,1] as separate entries (permutations). When you place coins in the outer loop, you finish processing coin 1 before processing coin 2, which fixes the order to "coin 1 → coin 2" and counts only combinations.

```java
// Counting combinations (correct order)
for (int coin : coins) {          // Outer: process each coin denomination
    for (int a = coin; a <= amount; a++) {  // Inner: scan amounts
        dp[a] += dp[a - coin];
    }
}

// Counting permutations (incorrect order)
for (int a = 1; a <= amount; a++) {         // Outer: process each amount
    for (int coin : coins) {                // Inner: try all coins
        if (a >= coin) dp[a] += dp[a - coin];
    }
}
```

## Complexity

| | Value |
|---|---|
| Time | O(n × amount) — You scan amounts 0 through amount for each of the n coin denominations |
| Space | O(amount) — You use only one DP array of size amount + 1 |

## Code

```java
// Input: an integer array coins containing coin denominations, and an integer amount as the target
// Output: return the number of coin combinations that sum to exactly amount as an int
public int change(int amount, int[] coins) {
    // dp[a] = the number of combinations that make exactly amount a
    // The size is amount + 1 (to cover each amount from index 0 through amount)
    int[] dp = new int[amount + 1];

    // Base case: there is exactly 1 way to make amount 0, which is "select nothing"
    // Without this base case, the source value for every transition is always 0, making all results 0
    dp[0] = 1;

    // Process each coin denomination (the outer loop fixes the order and counts only combinations)
    // Placing coin denominations in the outer loop prevents duplicate counting of the same coin set in different orders (permutations)
    for (int coin : coins) {
        // Scan amounts from coin to amount in ascending order
        // Start from coin because a - coin must be >= 0
        // Scanning in ascending order naturally reflects the cases of using the same coin multiple times
        for (int a = coin; a <= amount; a++) {
            // Use one coin and add the number of combinations for the remaining amount a - coin
            // Since dp[a - coin] already contains the number of combinations using zero or more of the same coin,
            // this single line covers all cases of using 1, 2, 3, … of that coin
            dp[a] += dp[a - coin];
        }
    }

    // Return the total number of combinations that make the target amount
    return dp[amount];
}
```
