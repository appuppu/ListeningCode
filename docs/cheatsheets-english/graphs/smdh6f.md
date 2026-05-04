# Filling Distances to the Nearest Gate — Find the distance from each empty room to the nearest gate in a grid

## Problem

You are given an m×n grid. Each cell is one of "wall (-1)", "gate (0)", or "empty room (Integer.MAX_VALUE)". You must fill each empty room cell with the distance to its nearest gate. If a room cannot reach any gate, it remains Integer.MAX_VALUE.

## Key Insight

Instead of searching for the nearest gate from each empty room, you start BFS simultaneously from all gates. Each BFS step corresponds to distance 1, 2, 3…, so the shortest distance to a cell is determined at the moment BFS first reaches it.

## Thought Process

1. **Searching from each room is inefficient**: Running BFS from every empty room causes the computation to scale with the number of rooms. By reversing the approach and searching from gates toward rooms, a single BFS from all gates determines the shortest distance for every room.
2. **Start from multiple gates simultaneously (Multi-source BFS)**: You enqueue all gates before starting BFS. This ensures that all rooms at distance 1 are processed first, then all rooms at distance 2, and so on. Due to the level-order property of BFS, the distance at which each room is first reached is its shortest distance.
3. **Visited status can be determined by cell value**: Empty rooms are initialized to Integer.MAX_VALUE. BFS writes the distance into reached cells, so only cells with Integer.MAX_VALUE remain unvisited. There is no need for a separate visited array.
4. **Distance is computed as parent cell value + 1**: The distance for an adjacent cell (child) equals the value of the dequeued cell (parent) plus 1. Since gates have value 0, adjacent rooms get 1, the next ones get 2, and values propagate correctly.
5. **Walls and out-of-bounds cells are simply skipped**: Walls (-1) and gates (0) are not Integer.MAX_VALUE, so the unvisited check naturally excludes them. Out-of-bounds indices are rejected by boundary checks.

## Prerequisites

### BFS (Breadth-First Search)

BFS is an algorithm that explores a graph or grid in order of proximity. It uses a queue (first-in, first-out) and processes all nodes at distance 1 from the source before moving to nodes at distance 2. This property guarantees the shortest distance to each node.

```java
Queue<int[]> queue = new LinkedList<>();  // Create a queue for BFS
queue.offer(new int[]{0, 0});             // Add the starting coordinates to the queue
int[] cell = queue.poll();                // Remove and return the element at the front of the queue
queue.isEmpty();                          // Check whether the queue is empty → true/false
```

### Multi-source BFS

Standard BFS starts from a single source, but Multi-source BFS starts with multiple sources enqueued simultaneously. The search expands like waves radiating from all sources at once, and each cell records the distance from its nearest source.

```java
// Enqueue all gates (cells with value 0) as starting points
for (int i = 0; i < m; i++)
    for (int j = 0; j < n; j++)
        if (rooms[i][j] == 0)
            queue.offer(new int[]{i, j});
// Starting BFS from this state begins exploration from all gates simultaneously
```

### 4-Directional Adjacent Cell Exploration

When moving in four directions (up, down, left, right) on a grid, using an array of direction vectors makes the code concise. You add each direction vector to the current coordinates to compute the adjacent cell's coordinates.

```java
int[][] dirs = {{-1,0},{1,0},{0,-1},{0,1}};  // Direction vectors: up, down, left, right
for (int[] d : dirs) {
    int r = cell[0] + d[0];  // Row index of the adjacent cell
    int c = cell[1] + d[1];  // Column index of the adjacent cell
}
```

## Complexity

| | Value |
|---|---|
| Time | O(m × n) — Each cell is added to the queue at most once, so the algorithm processes all cells exactly once |
| Space | O(m × n) — The queue can contain up to m×n cells |

## Code

```java
// Input: m×n integer grid rooms (-1=wall, 0=gate, Integer.MAX_VALUE=empty room)
// Output: void. Modifies rooms in place, filling each empty room cell with the distance to its nearest gate
public void wallsAndGates(int[][] rooms) {
    // Get the number of rows in the grid
    int m = rooms.length;
    // If the grid is empty, terminate processing
    if (m == 0) return;
    // Get the number of columns in the grid
    int n = rooms[0].length;

    // Create a queue for BFS that stores cell coordinates as {row, column}
    Queue<int[]> q = new LinkedList<>();

    // Scan the entire grid and enqueue all gates (cells with value 0)
    // This registers all gates as BFS starting points simultaneously (Multi-source BFS)
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (rooms[i][j] == 0)
                q.offer(new int[]{i, j});

    // Direction vectors representing up, down, left, and right. Used to enumerate adjacent cells in a loop
    int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    // Continue BFS until the queue is empty. BFS processes cells in order of increasing distance
    while (!q.isEmpty()) {
        // Dequeue the cell at the front. cell[0] is the row index, cell[1] is the column index
        int[] cell = q.poll();

        // Examine the four adjacent cells
        for (int[] d : dirs) {
            // Add the direction vector to compute the adjacent cell's coordinates
            int r = cell[0] + d[0];
            int c = cell[1] + d[1];

            // Skip if out of bounds
            if (r < 0 || r >= m || c < 0 || c >= n) continue;

            // Skip if the value is not Integer.MAX_VALUE (wall, gate, or room with distance already set)
            // This check prevents revisiting cells without needing a separate visited array
            if (rooms[r][c] != Integer.MAX_VALUE) continue;

            // Write parent cell's distance + 1. Since gates are 0, adjacent rooms get 1, the next get 2, propagating correctly
            // Because BFS processes cells in distance order, the first distance written is the shortest distance
            rooms[r][c] = rooms[cell[0]][cell[1]] + 1;
            // Enqueue the cell with the newly written distance to explore rooms beyond it
            q.offer(new int[]{r, c});
        }
    }
}
```
