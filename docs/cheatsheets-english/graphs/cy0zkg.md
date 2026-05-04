# Simulating Rotting Oranges Spreading — Find the Minimum Time Until All Oranges Rot

## Problem

You are given an m×n grid where each cell contains one of three values: 0 (empty), 1 (fresh orange), or 2 (rotten orange). Every minute, a rotten orange causes all fresh oranges that are 4-directionally adjacent to it to become rotten. Return the **minimum number of minutes** until no fresh orange remains. If it is impossible to rot all fresh oranges, return -1.

## Key Insight

Rotten oranges spread to adjacent cells "simultaneously." This is exactly a "Multi-Source BFS" where BFS starts from multiple sources at the same time, and each level (layer) of the BFS corresponds to one minute.

## Thought Process

1. **Spreading happens simultaneously**: When there are multiple rotten oranges, each one rots its adjacent cells at the same time. Instead of searching from a single starting point, you need to treat all rotten oranges as starting points simultaneously.
2. **Use Multi-Source BFS for simultaneous starts**: If you enqueue all rotten oranges at the beginning, one level of BFS (one round that processes the current size of the queue) corresponds to one minute of spreading. DFS cannot guarantee the "shortest time," so BFS is the appropriate choice.
3. **Track the count of fresh oranges**: If fresh oranges remain after spreading finishes, the case is impossible. Therefore, you count the number of fresh oranges in the initial state and decrement the count each time you rot one.
4. **How to measure elapsed time**: You process all elements in the queue for each BFS level and add one minute each time a level completes. The number of levels at the point when the fresh orange count reaches 0 is the answer.
5. **Termination condition and impossibility check**: If `fresh > 0` after BFS finishes, unreachable fresh oranges exist, so you return -1. If `fresh == 0`, you return the elapsed time.

## Prerequisites

### BFS (Breadth-First Search)

BFS is an algorithm that explores a graph or grid in order of increasing distance from the starting point. It uses a queue (FIFO) and processes all nodes at the current level before moving to the next level. BFS is suitable for problems that require finding the shortest distance or the shortest time.

### Multi-Source BFS

Standard BFS starts from a single source, but Multi-Source BFS begins with multiple sources enqueued at the start. You use Multi-Source BFS to simulate spreading from all sources simultaneously. It works identically to standard BFS except that the queue initially contains multiple elements.

### Queue

A queue is a first-in, first-out (FIFO) data structure. In BFS, you use a queue to process nodes in the order they are discovered.

```java
Queue<int[]> queue = new LinkedList<>();  // Create a queue that holds int arrays
queue.offer(new int[]{0, 1});  // Add an element to the tail of the queue
int[] pos = queue.poll();       // Remove and return the element at the head of the queue → {0, 1}
queue.size();                   // Return the number of elements in the queue
queue.isEmpty();                // Return whether the queue is empty as a boolean
```

### Direction Array

A direction array is a technique for enumerating 4-directionally adjacent cells in grid traversal. You define row and column offsets in an array and iterate over them in a loop.

```java
int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};  // 4 directions: right, left, down, up
for (int[] d : dirs) {
    int nr = row + d[0];  // Row index of the adjacent cell
    int nc = col + d[1];  // Column index of the adjacent cell
}
```

## Complexity

| | Value |
|---|---|
| Time | O(m × n) — The algorithm scans all cells once during initialization and processes each cell at most once during BFS |
| Space | O(m × n) — The queue can hold up to m×n cells |

## Code

```java
// Input: an m×n integer grid (each cell is 0=empty, 1=fresh orange, 2=rotten orange)
// Output: return the minimum number of minutes until all fresh oranges rot as an int. Return -1 if impossible
public int orangesRotting(int[][] grid) {
    int rows = grid.length;
    int cols = grid[0].length;
    // Queue for BFS. It holds the coordinates of cells to be explored
    Queue<int[]> queue = new LinkedList<>();
    // Variable that tracks the number of remaining fresh oranges
    int fresh = 0;

    // Scan the entire grid to set up multiple BFS starting points and count the remaining fresh oranges
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] == 2) {
                // Add the rotten orange to the queue (starting point for Multi-Source BFS)
                queue.offer(new int[]{i, j});
            } else if (grid[i][j] == 1) {
                // Count the fresh orange
                fresh++;
            }
        }
    }

    // Direction array representing 4 directions (up, down, left, right). Used to enumerate adjacent cells
    int[][] dirs = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
    int minutes = 0;

    // Include "fresh oranges remain" as a condition along with "queue is not empty" to avoid unnecessary loops after all oranges have rotted
    while (!queue.isEmpty() && fresh > 0) {
        // Save the number of cells to process at this level (one minute) beforehand to distinguish them from next-level elements added during the loop
        int size = queue.size();
        // Add one minute to the elapsed time because processing of one level begins
        minutes++;

        // Poll elements from the queue exactly size times to process all cells at this level
        for (int k = 0; k < size; k++) {
            int[] pos = queue.poll();

            // Use the direction array to check the 4 adjacent cells (up, down, left, right)
            for (int[] d : dirs) {
                int nr = pos[0] + d[0];
                int nc = pos[1] + d[1];

                // If the cell is within bounds and contains a fresh orange, rot it
                if (nr >= 0 && nr < rows
                    && nc >= 0 && nc < cols
                    && grid[nr][nc] == 1) {
                    // Update the cell to 2 to mark it as visited (this replaces a visited array and prevents duplicate processing of the same cell)
                    grid[nr][nc] = 2;
                    fresh--;
                    queue.offer(new int[]{nr, nc});
                }
            }
        }
    }

    // If fresh oranges remain, they are unreachable, so return -1. Otherwise, return the elapsed time
    return fresh > 0 ? -1 : minutes;
}
```
