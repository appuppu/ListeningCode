# Calculating Network Signal Propagation Time — Finding the Shortest Time for a Signal to Reach All Nodes in a Network

## Problem

The input consists of `n` nodes (1 to n) and a list of weighted directed edges `times` (each edge is `[source, destination, travel time]`). When a signal is sent from a specified source node `k`, the function returns the shortest time for the signal to reach all nodes. If any node is unreachable, the function returns `-1`.

## Key Insight

"The shortest time to reach all nodes" equals "the maximum of the shortest distances to each node." Dijkstra's algorithm computes the shortest distance to every node, and taking the maximum of those distances gives the answer.

## Thought Process

1. **Frame the problem as a shortest path problem**: The signal propagates from the source node along each edge. The time at which the signal reaches each node equals the shortest distance from the source to that node. Therefore, solving the single-source shortest path problem is sufficient.
2. **Compute shortest distances to all nodes efficiently**: Since all edge weights are non-negative, Dijkstra's algorithm applies. Dijkstra's algorithm uses a priority queue (min-heap) and greedily finalizes nodes in order of increasing distance.
3. **Choose a graph representation**: Use an adjacency list. For each node, store a list of pairs containing the neighboring node and the edge weight. This representation allows efficient enumeration of edges originating from a given node.
4. **Initialize the distance array**: Set the distance of all nodes to infinity (`Integer.MAX_VALUE`) and set the distance of the source node `k` to 0, because the distance from the source to itself is 0.
5. **Process nodes with the smallest distance using a priority queue**: Extract the node with the smallest distance from the queue, and update (relax) the distances of its neighboring nodes. If an update occurs, add the neighbor to the queue.
6. **Skip redundant processing**: If the distance of a node extracted from the queue is greater than its current shortest distance, a better path has already been processed, so skip it. This avoids unnecessary computation.
7. **Derive the answer from the shortest distances of all nodes**: Scan the distance array of all nodes. If any node still has a distance of infinity, it is unreachable, so return `-1`. Otherwise, the maximum distance is the answer.

## Prerequisites

### Adjacency List

An adjacency list is a data structure for representing a graph. For each node, it maintains a list of edges originating from that node. For `n` nodes, it is represented as `List<List<int[]>>`, and `graph.get(u)` retrieves the edges from node `u`.

```java
List<List<int[]>> graph = new ArrayList<>();
for (int i = 0; i <= n; i++) {
    graph.add(new ArrayList<>());       // Create an empty list for each node
}
graph.get(1).add(new int[]{2, 5});      // Add an edge from node 1 to node 2 with weight 5
graph.get(1).add(new int[]{3, 2});      // Add an edge from node 1 to node 3 with weight 2
```

### PriorityQueue

A priority queue is a data structure that always keeps the smallest (or largest) element at the front, regardless of insertion order. In Dijkstra's algorithm, it is used to efficiently extract the node with the smallest distance.

```java
// A min-heap that sorts by the 0th element (distance) of int[] in ascending order
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{0, 1});   // Add {distance 0, node 1} to the queue
pq.offer(new int[]{5, 2});   // Add {distance 5, node 2} to the queue
int[] curr = pq.poll();       // Extract the element with the smallest distance: {0, 1}
pq.isEmpty();                 // Return a boolean indicating whether the queue is empty
```

### Relaxation in Dijkstra's Algorithm

When the distance to node `v` via node `u`, computed as `dist[u] + w`, is less than the current `dist[v]`, the relaxation operation updates `dist[v]` to the shorter value. By repeating this update, the algorithm eventually determines the shortest distance to every node.

```java
int newDist = dist[u] + w;      // Calculate the distance to v via u
if (newDist < dist[v]) {        // If it is shorter than the current shortest distance
    dist[v] = newDist;          // Update the shortest distance
    pq.offer(new int[]{newDist, v});  // Add the updated v to the queue
}
```

## Complexity

| | Value |
|---|---|
| Time | O((V + E) log V) — The algorithm performs a priority queue operation (log V) for each node and each edge |
| Space | O(V + E) — The adjacency list stores all edges, and the distance array and queue use space proportional to the number of nodes |

## Code

```java
// Input: directed edge list int[][] times (each element is [source, destination, weight]), number of nodes int n, source node int k
// Output: return the shortest time as int for the signal to reach all nodes from the source. Return -1 if any node is unreachable
public int networkDelayTime(int[][] times, int n, int k) {
    // Create an adjacency list (node numbers start from 1, so use size n+1 and leave index 0 unused)
    List<List<int[]>> graph = new ArrayList<>();
    for (int i = 0; i <= n; i++) {
        graph.add(new ArrayList<>());
    }
    // Register each edge [u, v, w] in the adjacency list to complete the directed graph representation
    for (int[] t : times) {
        graph.get(t[0]).add(new int[]{t[1], t[2]});
    }

    // Initialize the distance array with infinity. dist[i] represents the current shortest distance from the source to node i
    int[] dist = new int[n + 1];
    Arrays.fill(dist, Integer.MAX_VALUE);
    // The distance from the source node to itself is 0
    dist[k] = 0;

    // Create a min-heap that extracts by distance (0th element) in ascending order, and add the source node {distance 0, node k}
    PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
    pq.offer(new int[]{0, k});

    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int d = curr[0];  // Distance from the source to node u
        int u = curr[1];  // The node currently being processed

        // If d > dist[u], a shorter distance has already been processed. This occurs when an outdated (longer distance) entry remains in the queue
        if (d > dist[u]) continue;

        // Attempt relaxation for neighboring nodes
        for (int[] nei : graph.get(u)) {
            int v = nei[0];  // Neighboring node
            int w = nei[1];  // Edge weight
            // If the distance via u, d + w, is shorter than the current dist[v], update the distance and add to the queue
            if (d + w < dist[v]) {
                dist[v] = d + w;
                pq.offer(new int[]{d + w, v});
            }
        }
    }

    // Find the maximum of the shortest distances to all nodes. This maximum is the shortest time for the signal to reach all nodes
    int max = 0;
    for (int i = 1; i <= n; i++) {
        // If dist[i] remains Integer.MAX_VALUE, an unreachable node exists, so return -1
        if (dist[i] == Integer.MAX_VALUE) return -1;
        max = Math.max(max, dist[i]);
    }
    return max;
}
```
