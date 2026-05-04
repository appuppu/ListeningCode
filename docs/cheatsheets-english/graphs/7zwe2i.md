# Capturing Surrounded Regions on a Board

## Problem

You are given an m×n board composed of `'X'` and `'O'`. You must flip all regions of `'O'` that are **completely surrounded** by `'X'` into `'X'`. However, any `'O'` that is on the **border** of the board, along with any `'O'` connected to it, is not surrounded and must not be flipped.

## Key Insight

Instead of searching for surrounded O's, you reverse the approach: first mark all unsurrounded O's (= O's reachable from the border), then treat every remaining O as surrounded. You run DFS from each border O to mark connected cells as safe, and then perform a single scan of the board to separate the flipping logic from the detection logic.

## Thought Process

1. **Identify the characteristics of unsurrounded O's**: An `'O'` avoids capture if it sits on the border of the board or connects to a border `'O'` through an up/down/left/right chain. Conversely, any `'O'` that DFS cannot reach from a border `'O'` is surrounded.
2. **Start the search from the border**: You scan all four edges (top, bottom, left, right) of the board and launch DFS from every `'O'` you find. Every `'O'` that DFS reaches is "safe (uncapturable)."
3. **Distinguish safe cells with a marker**: You rewrite each `'O'` visited by DFS to a temporary marker `'S'` (Safe). After DFS finishes, the only `'O'` cells left on the board are those that were never marked — meaning they are surrounded.
4. **Perform a single scan to flip and restore**: You iterate over every cell. You flip any remaining `'O'` to `'X'` because it is surrounded. You restore any `'S'` back to `'O'` because it is safe. You leave every `'X'` unchanged.
5. **Recursive structure of DFS**: Each cell explores all four directions (up, down, left, right) recursively. The bounds check and the check for non-`'O'` cells also serve as the visited check, because a cell already rewritten to `'S'` is no longer `'O'` and will not be revisited.

## Prerequisites

### DFS (Depth-First Search)

DFS is an algorithm for exploring graphs or grids. It starts from a given point, advances as deep as possible in one direction, and backtracks to try another direction when it hits a dead end. You can implement DFS naturally with recursive calls. On a grid, DFS recursively visits four directions: up, down, left, and right.

```java
// Basic DFS pattern on a grid
void dfs(char[][] grid, int r, int c) {
    if (r < 0 || r >= grid.length          // Out-of-bounds check
        || c < 0 || c >= grid[0].length
        || grid[r][c] != 'O')              // Prune on non-target cells
        return;
    grid[r][c] = 'S';                      // Mark as visited (also prevents revisits)
    dfs(grid, r + 1, c);                   // Down
    dfs(grid, r - 1, c);                   // Up
    dfs(grid, r, c + 1);                   // Right
    dfs(grid, r, c - 1);                   // Left
}
```

### How to Iterate Over Border Cells

To enumerate the cells on all four edges of an m×n board, you loop over columns for the top and bottom edges and loop over rows for the left and right edges.

```java
int m = board.length;    // Number of rows
int n = board[0].length; // Number of columns

// Scan all columns along the top edge (row 0) and bottom edge (row m-1)
for (int j = 0; j < n; j++) {
    process(board[0][j]);      // Top edge
    process(board[m - 1][j]);  // Bottom edge
}
// Scan all rows along the left edge (column 0) and right edge (column n-1)
for (int i = 0; i < m; i++) {
    process(board[i][0]);      // Left edge
    process(board[i][n - 1]);  // Right edge
}
```

### Marker Technique

The marker technique temporarily rewrites board cells to a different character (`'S'` in this case) to distinguish "visited" from "unvisited." Instead of allocating a separate `boolean[][]` visited array, you use the board itself for state management. You restore the markers to their original values at the end of the process.

## Complexity

| | Value |
|---|---|
| Time | O(m × n) — The DFS from the border visits each cell at most once, and the final scan iterates over every cell once |
| Space | O(m × n) — The DFS recursion call stack can reach a depth equal to the total number of cells in the worst case |

## Code

```java
// Input: an m×n 2D char array board composed of 'X' and 'O'
// Output: the method modifies board in-place, flipping surrounded 'O's to 'X', and returns void

// DFS that rewrites border-reachable O's to the marker S
void dfs(char[][] board, int r, int c, int m, int n) {
    // Do nothing if the cell is out of bounds or is not 'O' (cells already rewritten to 'S' are also excluded)
    // A cell rewritten to 'S' is no longer 'O', so DFS will not revisit it
    if (r < 0 || r >= m
        || c < 0 || c >= n
        || board[r][c] != 'O')
        return;

    // Rewrite the cell to the safe marker S (this also serves as the visited flag)
    // Instead of allocating a separate boolean[][], the board itself tracks state
    board[r][c] = 'S';

    // Recursively explore all four directions
    dfs(board, r + 1, c, m, n);
    dfs(board, r - 1, c, m, n);
    dfs(board, r, c + 1, m, n);
    dfs(board, r, c - 1, m, n);
}

public void solve(char[][] board) {
    // Retrieve the number of rows and columns for bounds checking and border scanning
    int m = board.length;     // Number of rows
    int n = board[0].length;  // Number of columns

    // Launch border DFS from each column on the top and bottom edges
    // The DFS only processes cells that are 'O', so it returns immediately on 'X' cells
    for (int j = 0; j < n; j++) {
        dfs(board, 0, j, m, n);       // Top edge
        dfs(board, m - 1, j, m, n);   // Bottom edge
    }

    // Launch border DFS from each row on the left and right edges
    // Together with the loop above, this covers all four edges of the board as starting points
    for (int i = 0; i < m; i++) {
        dfs(board, i, 0, m, n);       // Left edge
        dfs(board, i, n - 1, m, n);   // Right edge
    }

    // Perform a single scan to flip surrounded cells and restore safe cells
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (board[i][j] == 'O')
                board[i][j] = 'X';        // Flip surrounded O's that DFS could not reach from the border
            else if (board[i][j] == 'S')
                board[i][j] = 'O';        // Restore safe markers back to the original O
            // Leave 'X' cells unchanged
        }
    }
}
```
