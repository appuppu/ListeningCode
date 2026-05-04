# Finding the Longest Increasing Path in a Matrix — Find the length of the longest path in a matrix where values are strictly increasing

## Problem

You are given an m×n integer matrix `matrix`. You can move in four directions (up, down, left, right), and you can only move to an adjacent cell if its value is **strictly greater** than the current cell's value. Return the **length of the longest path** (number of cells) that satisfies this condition.

## Key Insight

You can view the matrix as a DAG (Directed Acyclic Graph) where edges point from smaller values to larger values. You start BFS from cells with in-degree 0 (cells that have no adjacent cell with a smaller value) and process layer by layer. The total number of layers equals the length of the longest path.

## Thought Process

1. **The movement condition defines DAG edges**: Because you can only move in the direction of strictly increasing values, no cycle can exist. This means that if you view the adjacency relationships in the matrix as a graph, it forms a DAG (Directed Acyclic Graph) with edges pointing from smaller to larger values
2. **You can find the longest path in a DAG using topological sort**: You can efficiently solve the longest path problem in a DAG by processing nodes in topological order. Using BFS (Kahn's algorithm) allows you to process nodes layer by layer, where the number of layers corresponds to the length of the longest path
3. **Define the meaning of in-degree**: The in-degree of each cell is "the number of adjacent cells (in 4 directions) that have a smaller value than the current cell." A cell with in-degree 0 is a candidate starting point for a path, meaning no adjacent cell has a smaller value
4. **Process BFS layer by layer**: You enqueue all cells with in-degree 0 and start BFS. You process all cells in one layer together, and for each cell, you decrement the in-degree of adjacent cells that have a larger value by 1. When a cell's in-degree reaches 0, you add it to the queue as part of the next layer
5. **Why the number of layers is the answer**: Each layer in BFS represents a set of cells at the same distance in the DAG. The total number of layers processed until the last layer equals the distance from the starting point to the farthest cell, which is the length of the longest path

## Prerequisites

### DAG (Directed Acyclic Graph)

A DAG is a graph consisting of vertices and directed edges that contains no cycles. When you create edges only in the direction of strictly increasing values, you cannot return to the same value, so no cycle can form, and the structure constitutes a DAG.

### In-degree

The in-degree of a vertex is **the number of edges coming into that vertex**. In this problem, the in-degree of cell `(i, j)` is "the number of adjacent cells (up, down, left, right) that have a value smaller than `matrix[i][j]`." A cell with in-degree 0 means it is a starting point of a path that no other cell can reach.

```java
// Example of calculating the in-degree of cell (i, j)
int indegree = 0;
for (int[] d : dirs) {
    int ni = i + d[0], nj = j + d[1];
    if (ni >= 0 && ni < m && nj >= 0 && nj < n
        && matrix[ni][nj] < matrix[i][j])  // If the neighbor is smaller, an edge comes in
        indegree++;
}
```

### Topological Sort (BFS / Kahn's Algorithm)

Topological sort is a method for ordering the vertices of a DAG so that all edges point from earlier to later vertices. In Kahn's algorithm, you enqueue vertices with in-degree 0, and each time you dequeue a vertex, you decrement the in-degree of its adjacent vertices by 1. When a vertex's in-degree reaches 0, you add it to the queue. Repeating this process yields the topological order.

```java
Queue<int[]> q = new LinkedList<>();   // Create a queue for BFS
q.offer(new int[]{0, 1});             // Add cell coordinates to the queue
q.isEmpty();                           // Return whether the queue is empty as boolean → false
q.size();                              // Return the number of elements in the queue → 1
int[] cell = q.poll();                 // Remove and return the front element of the queue → {0, 1}
```

### Representing 4-Directional Movement with an Array

You define the four directions (up, down, left, right) as a 2D array of `{row offset, column offset}` and iterate through each direction in a loop.

```java
int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};  // right, left, down, up
for (int[] d : dirs) {
    int ni = i + d[0];  // Destination row
    int nj = j + d[1];  // Destination column
}
```

## Complexity

| | Value |
|---|---|
| Time | O(m\*n) — Computing the in-degree of each cell takes O(m\*n), and BFS processes each cell exactly once in O(m\*n) |
| Space | O(m\*n) — The 2D array storing in-degrees and the BFS queue each hold at most m\*n cells |

## Code

```java
// Input: an m×n integer matrix called matrix
// Output: return the length of the longest strictly increasing path (number of cells) as int
int longestIncreasingPath(int[][] matrix) {
    // Get the number of rows m and columns n
    int m = matrix.length;
    int n = matrix[0].length;
    // Define movement offsets for 4 directions (right, left, down, up)
    int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};

    // Calculate the in-degree of each cell (number of adjacent cells with smaller values)
    // In-degree = number of incoming edges to the cell = number of adjacent cells with smaller values
    int[][] indeg = new int[m][n];
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            for (int[] d : dirs) {
                int ni = i + d[0];
                int nj = j + d[1];
                // If the adjacent cell is within bounds and has a smaller value, an edge comes in from it
                if (ni >= 0 && ni < m && nj >= 0 && nj < n
                    && matrix[ni][nj] < matrix[i][j])
                    indeg[i][j]++;
            }
        }
    }

    // Add all cells with in-degree 0 (path starting points) to the queue
    // In-degree 0 = no adjacent cell has a smaller value = a starting point unreachable from any other cell in the DAG
    Queue<int[]> q = new LinkedList<>();
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (indeg[i][j] == 0)
                q.offer(new int[]{i, j});

    // Process BFS layer by layer and count the number of layers
    // Each layer is a set of cells at the same distance from the starting points in the DAG
    int pathLen = 0;
    while (!q.isEmpty()) {
        // Get the number of cells in the current layer
        int size = q.size();
        // Increment path length by 1 for each new layer (total number of layers = longest path length)
        pathLen++;
        for (int k = 0; k < size; k++) {
            int[] cell = q.poll();
            // Examine adjacent cells in all 4 directions from the dequeued cell
            for (int[] d : dirs) {
                int ni = cell[0] + d[0];
                int nj = cell[1] + d[1];
                // If the adjacent cell is within bounds and has a larger value, process that edge
                if (ni >= 0 && ni < m && nj >= 0 && nj < n
                    && matrix[ni][nj] > matrix[cell[0]][cell[1]]) {
                    // Decrement in-degree by 1 (mark the incoming edge from this cell as processed)
                    indeg[ni][nj]--;
                    // If in-degree reaches 0 = all incoming edges are processed → add to queue as next layer
                    if (indeg[ni][nj] == 0)
                        q.offer(new int[]{ni, nj});
                }
            }
        }
    }
    // The number of BFS layers equals the length of the longest increasing path
    // The problem constraints guarantee the matrix is non-empty, so pathLen >= 1
    return pathLen;
}
```
