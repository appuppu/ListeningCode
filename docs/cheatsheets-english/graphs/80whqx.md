# Finding the Largest Island by Area — Find the Island with the Maximum Area in a 2D Grid

## Problem

You are given a 2D binary grid consisting of `1`s (land) and `0`s (water). An island is a group of `1` cells connected horizontally or vertically (up, down, left, right). You need to find and return the **maximum area** (number of cells) among all islands in the grid. If no island exists, you return `0`.

## Key Insight

You can determine the area of each island by counting connected land cells from each land cell using DFS. Instead of managing visited cells with a separate array, you overwrite each visited cell's value with `0`, which prevents duplicate visits without requiring additional memory.

## Thought Process

1. **The area of an island equals the size of a connected component**: A group of `1`s connected horizontally and vertically on the grid forms a single island. The area of an island is the number of cells contained in that group. Therefore, you need to compute the size of each connected component and return the maximum value.
2. **DFS is well-suited for exploring connected components**: If a cell `(r, c)` contains `1`, you start a DFS from that cell and recursively explore adjacent cells in all four directions (up, down, left, right), counting all connected `1`s to determine the island's area.
3. **You need a mechanism to avoid counting the same cell multiple times**: If DFS revisits a previously visited cell, it will double-count the area. Normally, you would prepare a `boolean[][] visited` array to record visited cells, but this requires O(m × n) additional memory.
4. **Overwriting visited cells with `0` eliminates the need for additional memory**: If you change a visited cell's value from `1` to `0` during DFS, the cell is treated as water and will not be revisited in subsequent exploration. This achieves duplicate prevention without a `visited` array, reducing auxiliary memory to O(1).
5. **DFS aggregates the area through its return value**: DFS returns the count of `1` for the current cell plus the sum of return values from recursive calls in all four directions. As a base case, a cell that is out of bounds or has a value of `0` returns `0`. This allows a single DFS call to recursively aggregate the entire island's area.
6. **You scan the entire grid to find the maximum value**: A nested for-loop iterates over every cell in the grid and calls DFS for each cell. You compare the return value of DFS (the island's area) with the current maximum and keep the larger value. For cells with a value of `0`, the DFS base case immediately returns `0`, so no special branching is needed.

## Prerequisites

### DFS (Depth-First Search)

DFS is an exploration algorithm for graphs and grids. It starts from one node and goes as deep as possible before backtracking. In a 2D grid, DFS recursively moves from a cell to its adjacent cells (up, down, left, right), which allows it to visit all connected cells.

```java
// Basic DFS structure for a 2D grid
void dfs(int[][] grid, int r, int c) {
    if (r < 0 || r >= grid.length || c < 0 || c >= grid[0].length)
        return;                    // Return if the cell is out of bounds
    dfs(grid, r - 1, c);          // Recurse upward
    dfs(grid, r + 1, c);          // Recurse downward
    dfs(grid, r, c - 1);          // Recurse leftward
    dfs(grid, r, c + 1);          // Recurse rightward
}
```

### In-place Modification

In-place modification is a technique that modifies the input data itself to record state without using additional data structures (such as arrays or sets). In this problem, you overwrite visited land cells with `0` as a substitute for a `visited` array.

```java
grid[r][c] = 0;  // Overwrite visited land (1) with water (0)
```

### Math.max

Math.max is a standard Java method that compares two values and returns the larger one. It is used in situations where you need to continuously update a maximum value within a loop.

```java
Math.max(3, 7);   // → 7 (returns the larger value)
Math.max(10, 2);  // → 10
```

## Complexity

| | Value |
|---|---|
| Time | O(m × n) — The algorithm visits each cell in the grid at most twice (once in the loop and once in DFS) |
| Space | O(1) auxiliary memory — The algorithm modifies the grid directly instead of using a visited array. However, the recursion stack uses up to O(m × n) in the worst case |

## Code

```java
// Input: a 2D integer array grid consisting of 1 (land) and 0 (water)
// Output: return the maximum island area in the grid as an int. Return 0 if no island exists

// DFS: count connected land cells and overwrite visited cells with 0
int dfs(int[][] grid, int r, int c) {
    // Base case: do not count if out of bounds or water (0) / already visited
    if (r < 0 || r >= grid.length
        || c < 0 || c >= grid[0].length
        || grid[r][c] == 0)
        return 0;

    // Mark as visited by overwriting land (1) with water (0) (in-place modification eliminates the need for a visited array)
    grid[r][c] = 0;

    // Return the sum of 1 (this cell) + the number of connected cells in all four directions
    // Adding the return values from the four recursive calls aggregates the entire island's area
    return 1 + dfs(grid, r - 1, c)   // up
             + dfs(grid, r + 1, c)   // down
             + dfs(grid, r, c - 1)   // left
             + dfs(grid, r, c + 1);  // right
}

int maxAreaOfIsland(int[][] grid) {
    // Get the number of rows and columns in the grid
    int m = grid.length;
    int n = grid[0].length;
    // Initialize the variable to track the maximum area to 0 (this value is returned as-is if no island exists)
    int maxArea = 0;

    // Scan all cells with a nested for-loop and find the maximum area among all islands
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            // For cells with value 0, the DFS base case immediately returns 0, so no special branching is needed
            maxArea = Math.max(maxArea,
                dfs(grid, i, j));

    return maxArea;
}
```
