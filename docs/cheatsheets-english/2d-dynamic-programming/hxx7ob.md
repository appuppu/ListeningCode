# Counting Unique Paths in a Grid — Count the number of unique paths from the top-left to the bottom-right of a grid

## Problem

You are given an `m × n` grid. You start at the top-left cell `(0, 0)` and want to reach the bottom-right cell `(m-1, n-1)`. At each step, you can only move **right or down**. Return the total number of unique paths.

## Key Insight

The number of paths to a given cell equals the sum of the number of paths to the cell above it and the number of paths to the cell to its left. You can compute the answer by filling in this recurrence relation bottom-up. Since computing each row depends only on the previous row and the current row, you can save space by using a single one-dimensional array of one row.

## Thought Process

1. **You can decompose the number of paths to each cell into subproblems**: To reach cell `(i, j)`, you must come from either the cell above `(i-1, j)` or the cell to the left `(i, j-1)`. Therefore, the recurrence relation `dp[i][j] = dp[i-1][j] + dp[i][j-1]` holds.
2. **Define the base cases**: You can only reach cells in the top row from the left, and you can only reach cells in the leftmost column from above. Both have exactly one path, so you initialize `dp[0][j] = 1` and `dp[i][0] = 1`.
3. **Fill in each row from left to right**: The recurrence depends on the cell directly above and the cell directly to the left, so if you scan rows from top to bottom and cells within each row from left to right, the required values are always already computed.
4. **You can compress the space to a single row**: `dp[i][j]` depends only on the left neighbor in the same row `dp[i][j-1]` and the same column in the previous row `dp[i-1][j]`. If you use a one-dimensional array `dp[j]`, the pre-update value of `dp[j]` represents the value from the cell above, and the already-updated value of `dp[j-1]` represents the value from the cell to the left. Therefore, you can express the recurrence as `dp[j] += dp[j-1]`.
5. **Initialize all elements to 1**: Initializing the one-dimensional array entirely with 1s represents the state of the top row, where every cell has exactly one path. The element `dp[0]`, which corresponds to the leftmost column, is never updated in the inner loop, so it always remains 1. This naturally preserves the base case for the leftmost column.
6. **What to return**: After processing all rows, `dp[n-1]` holds the number of unique paths to the bottom-right cell, so you return this value.

## Prerequisites

### What Arrays.fill Is

`Arrays.fill` is a utility method that initializes all elements of an array to a specified value at once. It allows you to fill an array with a uniform value without writing a loop.

```java
int[] dp = new int[5];       // Create an array of length 5 (all elements default to 0)
Arrays.fill(dp, 1);          // Set all elements to 1 → [1, 1, 1, 1, 1]
```

### What 1D DP Space Optimization Is

When each cell's computation in a 2D DP table depends only on the current row and the previous row, you can replace the 2D array with a 1D array. By overwriting the array row by row, you reduce the space from O(m × n) to O(n).

```java
// 2D case: dp[i][j] = dp[i-1][j] + dp[i][j-1]
// Compressed to 1D: dp[j] += dp[j-1]
//   dp[j] (before update) = value at the same column in the previous row (equivalent to dp[i-1][j])
//   dp[j-1] (already updated) = value of the left neighbor in the current row (equivalent to dp[i][j-1])
```

## Complexity

| | Value |
|---|---|
| Time | O(m × n) — The algorithm scans every cell of the grid exactly once |
| Space | O(n) — The algorithm maintains only a single row array |

## Code

```java
// Input: integer m (number of rows) and integer n (number of columns)
// Output: return the number of unique paths from the top-left to the bottom-right as an integer
public int uniquePaths(int m, int n) {
    // Create a 1D DP array of length n and initialize all elements to 1
    // Setting all elements to 1 establishes the base case for the top row (each cell has exactly one path)
    int[] dp = new int[n];
    Arrays.fill(dp, 1);

    // The top row (i=0) is already set by initialization, so start from i=1
    for (int i = 1; i < m; i++) {
        // The leftmost column (j=0) should always remain 1, so start from j=1
        for (int j = 1; j < n; j++) {
            // dp[j] (before update) = value at the same column in the previous row (number of paths from above)
            // dp[j-1] (already updated) = value of the left neighbor in the current row (number of paths from the left)
            // This addition implements the recurrence dp[i][j] = dp[i-1][j] + dp[i][j-1] on a 1D array
            dp[j] += dp[j - 1];
        }
    }

    // dp[n-1] holds the number of unique paths to the bottom-right cell (m-1, n-1) of the grid
    return dp[n - 1];
}
```
