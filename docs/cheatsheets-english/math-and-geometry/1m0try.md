# Setting Entire Rows and Columns to Zero

## Problem

You are given an m×n matrix. When you find an element that is zero, you must set its **entire row** and **entire column** to zero. You must perform this transformation in-place, without using an additional matrix.

## Key Insight

You can reuse the first row and first column of the matrix as flag regions to record which rows and columns should be zeroed out. This approach allows you to manage the zeroing targets with only O(1) additional space.

## Thought Process

1. **You need to record which rows and columns should be zeroed out**: If you overwrite a row or column the moment you find a zero during traversal, subsequent scans cannot distinguish whether a zero was original or introduced by the overwrite. Therefore, you need a two-pass approach that first records which rows and columns to zero out, then performs the zeroing in bulk.
2. **Using separate arrays for recording costs O(m+n) space**: You could use an array of size m for rows and an array of size n for columns to record the flags, but the goal is to achieve O(1) space.
3. **You can use the matrix's own first row and first column as flags**: Setting `matrix[i][0]` to zero means "zero out row i," and setting `matrix[0][j]` to zero means "zero out column j." This approach eliminates the need for additional arrays.
4. **The first column's flag requires a separate variable**: The cell `matrix[i][0]` carries two meanings: "flag for row i" and "original value of column 0." You must use a separate variable `firstCol` to track whether column 0 itself should be zeroed out.
5. **Marking the flags**: You traverse the matrix, and when you find `matrix[i][j] == 0`, you set `matrix[i][0] = 0` and `matrix[0][j] = 0` to mark the flags.
6. **Zeroing in reverse order**: When writing zeros based on the flags, overwriting the first row or first column early would destroy the flags. Therefore, you process the matrix in reverse order from the bottom-right, handling the first row and first column last.

## Prerequisites

### What In-Place Operation Means

An in-place operation modifies the input data directly to produce the result, without using additional data structures such as a separate matrix or large array. You are only allowed to use a constant number of extra variables.

```java
// Example of an in-place operation: modifying array elements directly
matrix[i][j] = 0;  // Modify the original matrix directly without copying to a separate array
```

### What a Boolean Flag Is

A boolean flag is a variable that records whether a certain condition has occurred, using the two values true and false. You set the flag to true when the condition is met at least once during a loop, and you reference it in subsequent processing.

```java
boolean firstCol = false;       // Initial value is false (condition not yet met)
if (matrix[i][0] == 0)
    firstCol = true;            // Record that the condition has been met
// Reference the flag later
if (firstCol)
    matrix[i][0] = 0;          // Execute the operation if the flag is true
```

### What a Reverse Loop Is

A reverse loop traverses an array or matrix from the end toward the beginning. When elements at the front serve as flags for subsequent processing, you use a reverse loop to process the front elements last.

```java
for (int i = m - 1; i >= 0; i--)    // Decrement i from the end (m-1) down to 0
    for (int j = n - 1; j >= 1; j--)  // Decrement j from the end (n-1) down to 1
```

## Complexity

| | Value |
|---|---|
| Time | O(m × n) — The algorithm traverses the entire matrix twice (once for flag setting, once for zeroing). |
| Space | O(1) — The only additional variable is `firstCol`. The algorithm reuses the matrix itself as the flag region. |

## Code

```java
// Input: an m×n integer matrix (2D array)
// Output: none (the method modifies matrix in-place and returns void)
public void setZeroes(int[][] matrix) {
    // Get the number of rows m and columns n
    int m = matrix.length;
    int n = matrix[0].length;
    // Flag to record whether column 0 should be zeroed out
    // Since matrix[i][0] doubles as the row flag, column 0's flag requires a separate variable
    boolean firstCol = false;

    // First pass: mark the flags
    for (int i = 0; i < m; i++) {
        // Check whether column 0 originally contains a zero, and set firstCol to true if so
        if (matrix[i][0] == 0)
            firstCol = true;
        // Start scanning from j=1 (j=0 doubles as the row flag, so only examine columns 1 onward)
        for (int j = 1; j < n; j++)
            if (matrix[i][j] == 0) {
                matrix[i][0] = 0;  // Flag to zero out row i
                matrix[0][j] = 0;  // Flag to zero out column j
            }
    }

    // Second pass: write zeros in reverse order
    // Reason for reverse order: the first row's flags (matrix[0][j]) are used to process other rows, so the first row must be processed last
    for (int i = m - 1; i >= 0; i--) {
        // Scan from j=n-1 down to j=1 in reverse, and set the cell to zero if its row flag or column flag is set
        for (int j = n - 1; j >= 1; j--)
            if (matrix[i][0] == 0 || matrix[0][j] == 0)
                matrix[i][j] = 0;
        // Zero out column 0 after the inner loop
        // Note: overwriting matrix[i][0] before the inner loop would corrupt the row flag check above
        if (firstCol)
            matrix[i][0] = 0;
    }
}
```
