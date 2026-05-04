# Finding Cells That Drain to Both Oceans

## Problem

You are given an m×n height matrix. The Pacific Ocean borders the top and left edges, and the Atlantic Ocean borders the bottom and right edges. Water flows from the current cell to an adjacent cell when the adjacent cell's height is less than or equal to the current cell's height. Find all cells from which water can reach **both** the Pacific and Atlantic Oceans.

## Key Insight

Checking reachability from each cell to the ocean in the forward direction causes redundant computation. Instead, if you perform BFS from the ocean boundary cells inward in the reverse direction (toward adjacent cells with equal or greater height), you can determine the set of cells reachable to each ocean in O(m*n) time. The intersection of the two sets gives the answer.

## Thought Process

1. **Forward exploration is inefficient**: Exploring a path from each cell (i,j) to the ocean requires BFS/DFS for each of the O(m*n) cells, resulting in O((m*n)²) total time. Independent exploration per cell contains massive redundancy, so you should consider reverse exploration instead.
2. **Reverse the direction of thinking**: "Water flows from a cell to the ocean" is equivalent to "A non-decreasing height path exists from the ocean to the cell." By running BFS in the reverse-flow direction from the ocean boundary, you can determine all reachable cells at once.
3. **Process the two oceans independently**: Enqueue all Pacific boundary cells (top edge + left edge) and run BFS to record reachable cells. Do the same for Atlantic boundary cells (bottom edge + right edge). The two searches are independent of each other, so you can reuse the same logic.
4. **Define the BFS transition condition**: Since the flow is reversed, you transition to an adjacent cell when its height is **greater than or equal to** the current cell's height. This is the reverse of "water flows from high to low."
5. **Take the intersection**: Cells marked as reached by both BFS runs are the cells from which water can flow to both oceans. Iterate over all cells and add those marked true in both arrays to the result list.

## Prerequisites

### Multi-source BFS

Standard BFS starts from a single source, but multi-source BFS enqueues all sources at the beginning before starting the BFS. This achieves the same effect as exploring from all sources simultaneously, and you can determine all reachable cells from every source in a single BFS pass.

```java
Queue<int[]> queue = new LinkedList<>();
// Add all sources to the queue
queue.offer(new int[]{0, 0});
queue.offer(new int[]{0, 1});
queue.offer(new int[]{0, 2});
// Explore from all sources simultaneously in a single while loop
while (!queue.isEmpty()) {
    int[] cell = queue.poll();
    // Explore adjacent cells based on the transition condition
}
```

### Visited tracking with boolean[][]

Use a 2D boolean array to record whether each cell has been reached. The initial value is false, and you set reached cells to true. This prevents processing the same cell more than once.

```java
boolean[][] reach = new boolean[m][n];  // Array initialized to false with dimensions m×n
reach[r][c] = true;   // Mark cell (r,c) as reached
if (!reach[nr][nc])   // Check whether cell (nr,nc) has not been reached yet
```

### 4-directional movement vectors

Represent up, down, left, and right movement on a grid using an array. By iterating over the four directions in a loop, you can handle all directional branches without code duplication.

```java
int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};  // right, left, down, up
for (int[] d : dirs) {
    int nr = r + d[0];  // New row index
    int nc = c + d[1];  // New column index
}
```

## Complexity

| | Value |
|---|---|
| Time | O(m×n) — Each BFS visits every cell at most once, and you run BFS twice |
| Space | O(m×n) — Two boolean arrays and the BFS queues each hold at most m×n cells |

## Code

```java
// Input: m×n integer matrix heights (height of each cell)
// Output: Coordinates of all cells from which water can reach both oceans, returned as List<List<Integer>>

// Movement vectors for 4 directions: up, down, left, right
int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};

// Run multi-source BFS and return a boolean array of reachable cells
boolean[][] bfs(int[][] h, Queue<int[]> q) {
    int m = h.length, n = h[0].length;
    // Array to record whether each cell is reachable via reverse flow from the ocean
    boolean[][] reach = new boolean[m][n];

    // Mark all sources in the queue as reached (boundary cells directly border the ocean)
    for (int[] c : q)
        reach[c[0]][c[1]] = true;

    while (!q.isEmpty()) {
        int[] cell = q.poll();
        int r = cell[0], c = cell[1];

        // Examine adjacent cells in all 4 directions
        for (int[] d : dirs) {
            int nr = r + d[0];
            int nc = c + d[1];

            // Expand exploration if the cell is in bounds, not yet reached, and has height >= current cell (reverse flow is possible)
            // The condition height >= current represents the reverse of "water flows from high to low"
            if (nr >= 0 && nr < m
                && nc >= 0 && nc < n
                && !reach[nr][nc]
                && h[nr][nc] >= h[r][c]) {
                reach[nr][nc] = true;
                q.offer(new int[]{nr, nc});
            }
        }
    }
    return reach;
}

List<List<Integer>> pacificAtlantic(int[][] heights) {
    int m = heights.length;
    int n = heights[0].length;

    // Create queues for Pacific and Atlantic (source sets for multi-source BFS)
    Queue<int[]> pQ = new LinkedList<>();
    Queue<int[]> aQ = new LinkedList<>();

    // Top edge borders the Pacific, so add as Pacific sources; bottom edge borders the Atlantic, so add as Atlantic sources
    for (int j = 0; j < n; j++) {
        pQ.offer(new int[]{0, j});
        aQ.offer(new int[]{m - 1, j});
    }

    // Left edge borders the Pacific, so add as Pacific sources; right edge borders the Atlantic, so add as Atlantic sources
    for (int i = 0; i < m; i++) {
        pQ.offer(new int[]{i, 0});
        aQ.offer(new int[]{i, n - 1});
    }

    // Run reverse-flow BFS from each ocean to obtain the sets of reachable cells
    boolean[][] pacReach = bfs(heights, pQ);
    boolean[][] atlReach = bfs(heights, aQ);

    // Add cells reachable from both oceans to the result list
    // Being true in both arrays means water from that cell can flow to both the Pacific and Atlantic
    List<List<Integer>> res = new ArrayList<>();
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (pacReach[i][j] && atlReach[i][j])
                res.add(Arrays.asList(i, j));

    return res;
}
```
