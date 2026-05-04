# Counting the Number of Islands in a Grid

## Problem

You are given a 2D grid consisting of `'1'` (land) and `'0'` (water). A group of horizontally or vertically adjacent land cells forms one "island." You must return the **total number** of islands in the grid.

## Key Insight

If you treat each land cell as a node and merge adjacent land cells together using Union-Find, the number of independent groups (roots) remaining at the end directly equals the number of islands.

## Thought Process

1. **An island is a connected component**: A group of adjacent land cells forms one island, so this problem reduces to counting the number of connected components in a grid.
2. **Union-Find is well-suited for managing connected components**: Union-Find can perform "merge two elements into the same group" and "determine whether two elements belong to the same group" in nearly O(1) time. By treating each land cell in the grid as an element, you can determine all connected components simply by merging adjacent cells one by one.
3. **Convert 2D grid cells to 1D indices**: Since the Union-Find array is one-dimensional, you convert cell `(i, j)` to a single integer using `i * n + j` (where n is the number of columns). This allows you to treat 2D grid cells as Union-Find elements.
4. **Count land cells during initialization**: You set each land cell's `parent` to itself and initialize `count` (the number of islands) to the total number of land cells. At this point, each land cell represents an independent island.
5. **Reduce the island count by merging adjacent cells**: You scan the grid, and for each land cell, you execute `union` if the right or bottom neighbor is also land. Each time `union` merges two distinct groups, you decrement `count` by 1. Checking only right and bottom is sufficient because left and top neighbors were already processed when scanning previous cells, so all adjacency relationships are covered.
6. **The final count is the answer**: After all merges are complete, the remaining `count` equals the number of independent connected components, which is the number of islands.

## Prerequisites

### What is Union-Find (Disjoint Set Data Structure)?

Union-Find is a data structure that manages multiple elements divided into groups. It provides two operations: "merge two elements into the same group (union)" and "determine which group a given element belongs to (find)." A `parent` array tracks each element's parent, and the data structure represents groups as tree structures.

```java
int[] parent = new int[n];   // parent[i] = parent of element i
int[] rank = new int[n];     // rank[i] = upper bound on the height of the tree rooted at element i

// Initialization: set each element's parent to itself (each element is an independent group)
for (int i = 0; i < n; i++)
    parent[i] = i;
```

### What is Path Compression?

Path compression is an optimization technique that re-attaches all nodes along the search path directly to the root during a `find` operation. After recursively finding the root, the statement `parent[x] = find(parent[x])` updates the parent to point to the root. This causes subsequent `find` calls to approach O(1).

```java
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);  // Re-attach the parent to the root
    return parent[x];
}
```

### What is Union by Rank?

Union by rank is a technique that attaches the tree with the lower rank (height) under the tree with the higher rank during a `union` operation. This suppresses the increase in tree height and maintains the search efficiency of `find`. The algorithm increments the rank by 1 only when both ranks are equal.

```java
void union(int x, int y) {
    int rx = find(x), ry = find(y);  // Find the root of each element
    if (rx == ry) return;            // Do nothing if they already belong to the same group
    if (rank[rx] < rank[ry])         // Attach the lower-rank tree under the higher-rank tree
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;                  // Increment the rank only when both ranks are equal
    }
}
```

### Converting 2D Indices to 1D Indices

This formula converts a 2D grid cell `(i, j)` into a 1D array index. Given that the number of columns is `n`, you can convert the cell to a unique integer using `id = i * n + j`.

```java
int m = 3, n = 4;          // A grid with 3 rows and 4 columns
int id = i * n + j;        // Cell (1, 2) → 1 * 4 + 2 = 6
```

## Complexity

| | Value |
|---|---|
| Time | O(m × n × α(m × n)) — The algorithm scans all cells and performs at most 2 union/find operations per cell. α is the inverse Ackermann function, which is effectively constant in practice. |
| Space | O(m × n) — The parent array and rank array each store m × n elements. |

## Code

```java
// Input: char[][] grid consisting of '1' (land) and '0' (water)
// Output: return the number of islands in the grid as an int

int[] parent;
int[] rank;
int count;

// Find with path compression: return the root of element x and re-attach all nodes along the path to the root
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);
    return parent[x];
}

// Union by rank: merge two elements into the same group and decrement count by 1 on success
void union(int x, int y) {
    int rx = find(x), ry = find(y);
    if (rx == ry) return;       // Do nothing if they already belong to the same group
    if (rank[rx] < rank[ry])
        parent[rx] = ry;       // Attach the lower-rank tree under the higher-rank tree
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;             // Increment the rank only when both ranks are equal
    }
    count--;                    // Decrement the island count by 1 because two groups have merged into one
}

public int numIslandsUF(char[][] grid) {
    // Get the number of rows m and columns n from the grid
    int m = grid.length;
    int n = grid[0].length;
    // Create the parent array and rank array with size m * n
    parent = new int[m * n];
    rank = new int[m * n];
    // Initialize the island count to 0 (the following scan will count the land cells)
    count = 0;

    // Initialization: set each land cell's parent to itself (i * n + j) and set count to the total number of land cells
    // At this point, each land cell represents an independent island
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            parent[i * n + j] = i * n + j;  // Convert the 2D index to 1D and set the parent to itself
            count++;                          // Increment count by 1 for each land cell
        }

    // For each land cell, merge it with its right and bottom neighbors if they are also land
    // The algorithm only checks right and bottom because left and top were already processed when scanning previous cells
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            int id = i * n + j;              // Compute the 1D index of the current cell
            if (j + 1 < n && grid[i][j + 1] == '1')
                union(id, id + 1);           // Merge with the right neighbor land cell (id + 1 is the right neighbor's 1D index)
            if (i + 1 < m && grid[i + 1][j] == '1')
                union(id, id + n);           // Merge with the bottom neighbor land cell (id + n is the bottom neighbor's 1D index)
        }

    // count started at the total number of land cells and was decremented by 1 each time a union succeeded, so the final value is the number of islands
    return count;
}
```
