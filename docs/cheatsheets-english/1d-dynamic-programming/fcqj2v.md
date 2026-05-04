# Finding the Fewest Coins to Make a Target Amount

## Problem

You are given an array `coins` containing coin denominations and a target amount `amount`. You can use each coin in `coins` as many times as you want. Return the **minimum number of coins** needed to make a combination that totals `amount`. If no combination of coins can make `amount`, return `-1`.

## Key Insight

If you compute the minimum number of coins needed for every amount from 0 up to the target amount in a bottom-up fashion, then the minimum number of coins for amount `i` equals the minimum value among `dp[i - c] + 1` for each coin denomination `c`.

## Thought Process

1. **You can decompose this into subproblems**: If the last coin used to make amount `i` is coin `c`, and you already know the minimum number of coins to make the remaining amount `i - c`, then `dp[i - c] + 1` gives the minimum number of coins for amount `i`. This structure is well-suited for dynamic programming.
2. **You cannot know in advance which coin is the last one used**: Every coin denomination is a candidate for the last coin. Therefore, you calculate `dp[i - c] + 1` for every coin `c` and take the minimum value as `dp[i]`. This gives the recurrence `dp[i] = min(dp[i - c] + 1)` for each coin `c`.
3. **You define the base case**: Making amount 0 requires 0 coins, so you set `dp[0] = 0`. This serves as the starting point for the bottom-up computation.
4. **You set an initial value representing "unreachable"**: Since you cannot know in advance whether each amount is achievable, you initialize every element of the `dp` array to `amount + 1` (an impossibly large coin count). Any amount whose value remains unchanged is considered unreachable.
5. **You fill the table from amount 1 upward**: Starting from `dp[0]`, you fill the table in order for amounts 1, 2, ..., `amount`. By the time you compute amount `i`, the minimum coin counts for all amounts smaller than `i` are already finalized, so you can safely reference `dp[i - c]`.
6. **You determine the final return value**: If `dp[amount]` still equals `amount + 1`, the target amount is unreachable, so you return `-1`. Otherwise, `dp[amount]` is the minimum number of coins.

## Prerequisites

### Dynamic Programming

Dynamic programming is a technique that decomposes a large problem into smaller subproblems and builds the solution bottom-up while recording each subproblem's result in a table. This approach avoids redundantly solving the same subproblems, which makes it computationally efficient.

```java
// Basic pattern of bottom-up DP
int[] dp = new int[n + 1];     // Create a table
dp[0] = baseCase;              // Set the base case
for (int i = 1; i <= n; i++) { // Solve subproblems in order from smallest
    dp[i] = /* Compute using previous results such as dp[i-1] */;
}
return dp[n];                  // Return the final answer
```

### Arrays.fill

`Arrays.fill` is a standard Java method that fills every element of an array with a specified value. It is commonly used to initialize DP arrays.

```java
int[] dp = new int[5];       // Creates [0, 0, 0, 0, 0]
Arrays.fill(dp, 100);        // Fills all elements with 100 → [100, 100, 100, 100, 100]
```

### Math.min

`Math.min` is a standard Java method that returns the smaller of two integers. It is used to select the minimum value among multiple candidates.

```java
Math.min(3, 7);    // → 3
Math.min(dp[i], dp[i - coin] + 1);  // Choose the smaller of the current value and the new candidate
```

## Complexity

| | Value |
|---|---|
| Time | O(amount × n) — For each amount, the algorithm scans all n coin types (n is the length of the coins array) |
| Space | O(amount) — The dp array stores amount + 1 elements |

## Code

```java
// Input: an integer array coins containing coin denominations and an integer amount as the target
// Output: return the minimum number of coins that sum to amount as an int. Return -1 if it is not possible
int coinChange(int[] coins, int amount) {
    // dp[i] = the minimum number of coins needed to make amount i
    // The size is amount + 1 to cover each amount from index 0 through amount
    int[] dp = new int[amount + 1];

    // Initialize all elements with a sentinel value representing "unreachable"
    // Since the minimum coin denomination is at least 1, the count can never exceed amount, so any remaining sentinel value indicates "not achievable"
    Arrays.fill(dp, amount + 1);

    // Base case: making amount 0 requires 0 coins. This is the starting point of the bottom-up computation
    dp[0] = 0;

    // Fill the table from amount 1 through amount
    // Computing in ascending order guarantees that dp[i - coin] is already finalized
    for (int i = 1; i <= amount; i++) {
        // Try each coin as a candidate for the last coin used to make amount i, and find the optimal denomination
        for (int coin : coins) {
            // Skip this coin if coin > i, because that coin cannot contribute to making amount i
            if (coin <= i)
                // dp[i - coin] + 1 represents "the minimum coins for amount i - coin, plus one more coin"
                // Compare it with the current dp[i] and adopt the smaller value
                dp[i] = Math.min(dp[i],
                    dp[i - coin] + 1);
        }
    }

    // If the sentinel value remains, the initial value was never updated, meaning the target amount is not achievable, so return -1
    return dp[amount] > amount
        ? -1 : dp[amount];
}
```
