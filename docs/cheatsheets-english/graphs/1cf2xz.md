# Finding the Redundant Edge in a Graph — Find the extra edge added to a tree

## Problem

The input is a graph formed by adding one edge to a tree that consists of n nodes and n-1 edges, creating exactly one cycle. The task is to find and return the extra edge that was added. Removing that edge restores the graph to a valid tree.

## Key Insight

When processing edges one by one, if an edge connects two nodes that already belong to the same connected component, that edge is the redundant edge creating the cycle. Union-Find is the optimal data structure for this check.

## Thought Process

1. **Leverage the properties of a tree**: A tree connects n nodes with n-1 edges and contains no cycles. Adding one edge creates exactly one cycle. Therefore, processing edges in order and detecting the edge that creates a cycle is sufficient.
2. **Determine the cycle detection condition**: When adding edge (u, v), if u and v already belong to the same connected component, that edge forms a cycle. Conversely, if u and v belong to different connected components, that edge simply merges two components and does not create a cycle.
3. **Union-Find is suitable for managing connected components**: Union-Find is a data structure that efficiently performs two operations: checking whether two nodes belong to the same connected component and merging two connected components. The find operation compares roots to determine membership, and the union operation merges components.
4. **Optimize Union-Find**: Path compression reconnects each node directly to the root during every find operation. Union by rank keeps the tree height small by attaching the shorter tree under the taller one. These two optimizations reduce each operation to α(n) (inverse Ackermann function, effectively constant) amortized time.
5. **Process edges in order**: Iterate through the given edge array from the beginning, attempting a union operation for each edge. The edge for which union fails (i.e., both endpoints already belong to the same component) is the redundant edge, and the algorithm returns it.
6. **What to return**: Return the edge whose union operation failed as an `int[]`. The problem guarantees exactly one redundant edge exists, so there is always a valid answer.

## Prerequisites

### What is Union-Find (Disjoint Set Union)?

Union-Find is a data structure that partitions elements into groups (connected components) and efficiently performs two operations: checking whether two elements belong to the same group and merging two groups. A `parent` array represents the tree structure of each group, and two elements belong to the same group if and only if they share the same root (representative).

```java
int[] parent = new int[n + 1];  // parent[i] holds the parent of node i
int[] rank = new int[n + 1];    // rank[i] holds the upper bound on the height of the tree rooted at node i
for (int i = 1; i <= n; i++)
    parent[i] = i;              // Initially, each node is its own parent (every node is an independent group)
```

### Find operation (with path compression)

The find operation returns the root (representative) of the group to which node x belongs. It recursively follows parent pointers and reconnects every node along the path directly to the root (path compression). This speeds up subsequent find operations.

```java
int find(int[] parent, int x) {
    if (parent[x] != x)                    // If x is not the root
        parent[x] = find(parent, parent[x]); // Recursively follow parents and reconnect directly to the root
    return parent[x];                       // Return the root of x
}
```

### Union operation (union by rank)

The union operation merges the groups of two nodes. It attaches the tree with the smaller rank under the tree with the larger rank to minimize height growth. If the two nodes already belong to the same group, the operation does not merge and returns `false`.

```java
boolean union(int[] parent, int[] rank, int x, int y) {
    int rx = find(parent, x);  // Find the root of x
    int ry = find(parent, y);  // Find the root of y
    if (rx == ry) return false; // Same group — no merge needed → return false
    // Attach the tree with the smaller rank under the tree with the larger rank
    if (rank[rx] < rank[ry]) parent[rx] = ry;
    else if (rank[rx] > rank[ry]) parent[ry] = rx;
    else { parent[ry] = rx; rank[rx]++; }  // Equal ranks — attach one under the other and increment the rank
    return true;  // Merge succeeded → return true
}
```

### What is the inverse Ackermann function α(n)?

The inverse Ackermann function expresses the amortized cost per Union-Find operation. α(n) grows extremely slowly and satisfies α(n) ≤ 4 for all practical input sizes (n < 2^65536), so it is effectively constant.

## Complexity

| | Value |
|---|---|
| Time | O(n × α(n)) ≈ O(n) — Each of the n edges requires one find and one union call. Since α(n) is effectively constant, the total time is O(n). |
| Space | O(n) — The parent array and rank array each store n+1 elements. |

## Code

```java
// Input: an array of edges (each element is int[]{u, v} representing an edge between node u and node v)
// Output: the redundant edge that forms a cycle, returned as int[]

// Return the root of the group to which node x belongs (with path compression)
int find(int[] parent, int x) {
    if (parent[x] != x)
        // Recursively follow parents and reconnect directly to the root (path compression)
        parent[x] = find(parent,
            parent[x]);
    return parent[x];
}

// Merge the groups of two nodes. Return false if they already belong to the same group
boolean union(int[] parent,
        int[] rank, int x, int y) {
    int rx = find(parent, x); // Find the root of x
    int ry = find(parent, y); // Find the root of y
    if (rx == ry) return false; // Already in the same component → a cycle would form, so return false
    // Attach the tree with the smaller rank under the larger one to minimize height growth
    if (rank[rx] < rank[ry])
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        // Equal ranks — attach one under the other and increment the rank
        parent[ry] = rx;
        rank[rx]++;
    }
    return true; // Merge succeeded → no cycle was created
}

public int[] findRedundantConnection(
        int[][] edges) {
    // Number of edges = number of nodes (n-1 tree edges + 1 extra edge = n edges). Nodes are numbered 1 to n
    int n = edges.length;
    // Initialize each node as an independent group (parent[i] = i means each node is its own root)
    int[] parent = new int[n + 1];
    int[] rank = new int[n + 1]; // The rank array can remain at its default value of 0
    for (int i = 1; i <= n; i++)
        parent[i] = i;

    // Process edges one by one from the beginning and detect the edge that forms a cycle
    for (int[] e : edges) {
        // If union returns false, e[0] and e[1] already belong to the same connected component
        // → This edge is the redundant edge that forms a cycle, so return it immediately
        if (!union(parent, rank,
                e[0], e[1]))
            return e;
    }
    // The problem guarantees exactly one redundant edge exists, so this line is unreachable
    return new int[0];
}
```
