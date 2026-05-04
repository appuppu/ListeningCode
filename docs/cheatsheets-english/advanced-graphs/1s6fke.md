# Finding the Minimum Cost to Connect All Points

## Problem

You are given an array `points` of points on a 2D plane. The cost between any two points is defined as the Manhattan distance `|xi - xj| + |yi - yj|`. Return the **minimum total cost** to connect all points. This problem requires finding the Minimum Spanning Tree (MST).

## Key Insight

To connect all points at minimum cost, Prim's algorithm greedily selects "the closest unvisited point to the current MST" repeatedly. Using a priority queue allows the algorithm to efficiently extract the minimum-cost edge.

## Thought Process

1. **This is an MST problem**: The goal is to connect all points while minimizing the total cost. This is exactly the definition of a Minimum Spanning Tree. The edge weights in the graph can be computed as Manhattan distances.
2. **Prim's algorithm is well-suited for complete graphs**: With n points, the number of edges is n(n-1)/2. Kruskal's algorithm requires generating and sorting all edges in advance, but Prim's algorithm can process only the edges adjacent to the current MST incrementally.
3. **The algorithm needs to extract the minimum-cost edge quickly**: Prim's algorithm must select the "minimum-cost edge to an unvisited point" at each step. A priority queue (min-heap) performs this extraction in O(log n).
4. **The algorithm can start from any point**: The total MST cost is the same regardless of the starting point, so the algorithm starts from point 0. The initial state places cost 0 to point 0 in the queue.
5. **A visited flag prevents duplicate processing**: If a point extracted from the queue is already in the MST, the algorithm skips it. This prevents processing the same point twice.
6. **Adding a new point to the MST triggers adding adjacent edges**: When the algorithm adds point u to the MST, it computes the Manhattan distance from u to every unvisited point v and adds these edges to the queue. The queue automatically manages the minimum-cost edge as the next candidate.

## Prerequisites

### Minimum Spanning Tree (MST)

A Minimum Spanning Tree is the subgraph that connects all vertices in a graph with the minimum total edge weight. It contains exactly n-1 edges for n vertices and contains no cycles.

### Prim's Algorithm

Prim's algorithm is a greedy algorithm that constructs an MST. It starts from any vertex and repeatedly selects the minimum-weight edge connecting the current MST to an unvisited vertex, expanding the MST. The algorithm terminates when all vertices are included in the MST.

### Manhattan Distance

Manhattan distance is the sum of the absolute differences of each coordinate between two points. The distance between points `(x1, y1)` and `(x2, y2)` on a 2D plane is computed as `|x1 - x2| + |y1 - y2|`. It corresponds to the shortest distance when walking along grid-aligned paths.

```java
int dist = Math.abs(pts[u][0] - pts[v][0]) + Math.abs(pts[u][1] - pts[v][1]);
```

### PriorityQueue

A priority queue is a data structure that extracts elements in order of priority. By default, it extracts the minimum value first (min-heap). The `offer` method adds an element and the `poll` method extracts the minimum element, both operating in O(log n).

```java
// Create a priority queue that orders int[] in ascending order by the 0th element
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{5, 0});   // Add [cost=5, point index=0]
pq.offer(new int[]{2, 1});   // Add [cost=2, point index=1]
int[] min = pq.poll();       // Extract the element with minimum cost [2, 1]
```

## Complexity

| | Value |
|---|---|
| Time | O(n² log n) — Each time a point is added to the MST, up to n edges are added to the queue, and each queue operation costs log n |
| Space | O(n²) — The queue stores up to n² edges. The inMST array uses O(n) |

## Code

```java
// Input: array of 2D coordinates pts (each element is [x, y])
// Output: return the minimum cost to connect all points as int
int minCostConnectPoints(int[][] pts) {
    // Get the number of points
    int n = pts.length;
    // Flag array to track whether each point is in the MST (initialized to all false)
    boolean[] inMST = new boolean[n];
    // Priority queue storing {cost, point index}, extracting in ascending order of cost
    PriorityQueue<int[]> pq =
        new PriorityQueue<>((a, b) -> a[0] - b[0]);
    // Add the starting point (index 0) to the queue with cost 0
    // Cost 0 means the cost of adding the first point to the MST is 0
    // The total MST cost is the same regardless of starting point, so point 0 is chosen arbitrarily
    pq.offer(new int[]{0, 0});
    // cost: total MST cost, visited: number of points added to the MST
    int cost = 0, visited = 0;

    // Repeat until all points are included in the MST
    while (visited < n) {
        // Extract the edge with minimum cost (d: connection cost, u: point index)
        int[] curr = pq.poll();
        int d = curr[0], u = curr[1];

        // Skip the point if it is already in the MST
        // This check is necessary because the same point may be added to the queue multiple times with different costs
        if (inMST[u]) continue;

        // Add point u to the MST and accumulate the cost
        inMST[u] = true;
        cost += d;
        visited++;

        // Add edges from point u to all unvisited points to the queue
        // Candidate edges are registered in the queue, which automatically manages the minimum-cost edge
        for (int v = 0; v < n; v++) {
            if (!inMST[v]) {
                // Compute Manhattan distance: |xu - xv| + |yu - yv|
                int nd =
                    Math.abs(pts[u][0] - pts[v][0])
                    + Math.abs(pts[u][1] - pts[v][1]);
                pq.offer(new int[]{nd, v});
            }
        }
    }
    // After the while loop ends, cost contains the total MST cost
    return cost;
}
```
