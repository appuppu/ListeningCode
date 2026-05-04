# Counting Connected Components in an Undirected Graph

## Problem

The algorithm receives `n` nodes labeled from `0` to `n-1` and a list of undirected edges `edges`. It returns the number of **connected components** in the graph as an integer. A connected component is a set of nodes that can reach each other by traversing edges.

## Key Insight

The algorithm initially treats each node as an independent connected component and processes edges one by one, merging the groups to which both endpoints belong. The number of groups remaining after processing all edges equals the number of connected components.

## Thought Process

1. **Nodes connected by an edge belong to the same group**: A connected component is "a set of nodes reachable by traversing edges," so two nodes joined by an edge must belong to the same connected component. Repeating the operation "merge both endpoints into the same group" for every edge ultimately yields all connected components.
2. **Union-Find is well suited for managing groups**: Union-Find is a data structure that efficiently performs "merging two elements into the same group (union)" and "finding which group an element belongs to (find)." Each node stores a "parent node," and nodes sharing the same root are considered members of the same group.
3. **Each node initially has itself as its parent**: Initializing `parent[i] = i` makes each of the n nodes an independent group (connected component). The initial number of connected components is `n`.
4. **Each edge triggers a union, and a successful merge decrements the component count**: For each edge `[a, b]`, the algorithm finds the root of `a` and the root of `b`. If the roots differ, the two nodes belong to different groups, so the algorithm makes one root a child of the other and decrements the component count by one. If the roots are the same, the nodes already belong to the same group, so the algorithm does nothing.
5. **Path compression and rank accelerate operations**: During find, path compression re-attaches every visited node directly to the root. During union, the algorithm compares ranks (upper bounds on tree height) and attaches the shorter tree under the taller tree (union by rank). These optimizations reduce the amortized cost of find to nearly O(1) (precisely O(α(V))).
6. **The value of `components` after processing all edges is the answer**: Starting from the initial value `n` and decrementing by one for each successful union yields the final number of connected components.

## Prerequisites

### Union-Find (Disjoint Set Data Structure)

Union-Find is a data structure that partitions elements into groups. It provides two operations: "merge two elements into the same group (union)" and "find the representative (root) of the group to which an element belongs (find)." A `parent` array records each element's parent, and the algorithm traces parents up to the root to identify the group representative.

```java
int[] parent = new int[n];   // parent[i] stores the parent node of node i
for (int i = 0; i < n; i++)
    parent[i] = i;            // Initial state: each node is its own parent (independent group)
```

### Path Compression

Path compression is an optimization that re-attaches every node visited during find's recursion directly to the root. Subsequent find calls return the root immediately, and the flattened tree reduces the amortized time complexity to nearly O(1).

```java
int find(int[] parent, int x) {
    if (parent[x] != x)
        parent[x] = find(parent, parent[x]);  // Recursively find the root and re-attach parent to root
    return parent[x];                          // Return the root
}
```

### Union by Rank

Union by rank compares the ranks (upper bounds on tree height) during union and attaches the shorter tree under the taller tree. This strategy suppresses tree height growth and maintains find efficiency. The algorithm increments the rank of the merged root only when both ranks are equal.

```java
int[] rank = new int[n];     // rank[i] stores the upper bound on the height of the tree rooted at node i (initially 0)
// Attach the lower-rank tree under the higher-rank tree to prevent the tree from growing deep
if (rank[r1] > rank[r2])
    parent[r2] = r1;         // Attach r2's tree under r1
```

### α (Inverse Ackermann Function)

The inverse Ackermann function appears in Union-Find's time complexity. For any practical input size, α(V) is always 5 or less, so it is effectively a constant. Therefore, each Union-Find operation runs in nearly O(1) time.

## Complexity

| | Value |
|---|---|
| Time | O(V + E · α(V)) — Initialization takes O(V); find and union run for each edge, but since α(V) is effectively constant, the total is essentially O(V + E) |
| Space | O(V) — The parent array and the rank array each store V elements |

## Code

```java
// Input: number of nodes n and a list of edges (each edge is a 2-element array [a, b])
// Output: the number of connected components as an integer

// Find function with path compression: returns the root of the group to which node x belongs
int find(int[] parent, int x) {
    if (parent[x] != x)
        // Recursively find the root and re-attach the parent directly to the root (path compression)
        // This allows subsequent find calls to return the root immediately
        parent[x] = find(parent, parent[x]);
    return parent[x];
}

int countComponents(int n, int[][] edges) {
    // Array storing each node's parent. Initialize parent[i] = i to make each node an independent group
    int[] parent = new int[n];
    // Array storing the upper bound on the height of the tree rooted at each node (used to decide which tree to attach under during union)
    int[] rank = new int[n];
    for (int i = 0; i < n; i++)
        parent[i] = i;

    // Initially each node is an independent connected component, so the component count is n
    int components = n;

    // Process edges one by one, merging the groups to which both endpoints belong
    for (int[] e : edges) {
        // Find the roots of the groups to which both endpoints belong (path compression also re-attaches visited nodes to the root)
        int r1 = find(parent, e[0]);
        int r2 = find(parent, e[1]);

        // If the roots differ, the nodes belong to different groups, so merge them (if the roots are the same, they already belong to the same group, so do nothing)
        if (r1 != r2) {
            // Compare ranks and attach the shorter tree under the taller tree (to suppress tree height growth)
            if (rank[r1] > rank[r2])
                parent[r2] = r1;
            else if (rank[r1] < rank[r2])
                parent[r1] = r2;
            else {
                // If ranks are equal, attach r2 under r1 and increment r1's rank by one
                parent[r2] = r1;
                rank[r1]++;
            }
            // Two groups merged into one, so decrement the component count by one
            components--;
        }
    }
    // The value of components after processing all edges is the number of connected components
    return components;
}
```
