# Determining if All Courses Can Be Completed

## Problem

You are given `numCourses` courses labeled from `0` to `n-1` and a list of prerequisite pairs `prerequisites`. Each pair `[a, b]` means that you must complete course `b` before you can take course `a`. Return a `boolean` indicating whether you can complete all courses. This problem requires detecting whether a cycle (circular dependency) exists in a directed graph.

## Key Insight

If you model the course dependencies as a directed graph, the question of whether you can complete all courses is equivalent to asking whether the graph contains no cycles. You perform a topological sort by processing nodes with an in-degree (the number of edges pointing into that node) of 0 first. If the sort processes all nodes, then no cycle exists.

## Thought Process

1. **Convert the problem into a graph**: Treat each course as a node and each prerequisite `[a, b]` as a directed edge from `b` to `a`, building an adjacency list. This represents the dependency relationships as a graph structure.
2. **A cycle makes full completion impossible**: If course A depends on B and B depends on A, you cannot complete either course first. Therefore, the problem reduces to detecting whether the directed graph contains a cycle.
3. **Focus on in-degrees**: Count the in-degree (number of prerequisites) of each node. Nodes with an in-degree of 0 have no prerequisites, so you can take them immediately. Use these nodes as starting points.
4. **Enqueue nodes with in-degree 0 and begin processing**: Use a queue in a BFS-like manner to process nodes with in-degree 0 in order. For each processed node, decrement the in-degree of its neighboring nodes by 1, and enqueue any node whose in-degree becomes 0.
5. **Judge by the count of processed nodes**: If you process all nodes (processed count == `numCourses`), no cycle exists and you can complete all courses. Nodes within a cycle never reach an in-degree of 0, so they remain unprocessed.

## Prerequisites

### Adjacency List

An adjacency list is a data structure for representing a graph. For each node, it stores a list of nodes to which that node has outgoing edges. You implement it as `List<List<Integer>>`, and `graph.get(i)` returns the list of neighbors of node `i`.

```java
List<List<Integer>> graph = new ArrayList<>();
for (int i = 0; i < n; i++)
    graph.add(new ArrayList<>());  // Create an empty list for each node
graph.get(0).add(1);               // Add an edge from node 0 to node 1
graph.get(0);                       // Get the neighbor list of node 0 → [1]
```

### In-degree

In a directed graph, the in-degree of a node is the number of edges pointing into that node. A node with an in-degree of 0 does not depend on any other node. You manage the in-degree of node `i` using the array `inDegree[i]`.

```java
int[] inDegree = new int[n];   // Initialize in-degree of all nodes to 0
inDegree[0]++;                  // Increment the in-degree of node 0 by 1
```

### Queue

A queue is a first-in, first-out (FIFO) data structure. In BFS, you use a queue to manage nodes waiting to be processed. `offer` adds an element to the tail, and `poll` removes and returns the element at the head.

```java
Queue<Integer> queue = new LinkedList<>();
queue.offer(0);       // Add 0 to the queue
queue.poll();          // Remove and return the head of the queue → 0
queue.isEmpty();       // Return whether the queue is empty as a boolean → true
```

## Complexity

| | Value |
|---|---|
| Time | O(V + E) — The algorithm processes all nodes (V) and all edges (E) exactly once each |
| Space | O(V + E) — The adjacency list stores all edges, and the in-degree array and queue store all nodes |

## Code

```java
// Input: number of courses numCourses and array of prerequisites (each element [a, b] represents the dependency b → a)
// Output: true if you can complete all courses, false if a cycle makes completion impossible
boolean canFinish(int numCourses, int[][] prerequisites) {
    // Array storing the in-degree (number of prerequisites) of each node. The in-degree represents how many prerequisites that course has
    int[] inDegree = new int[numCourses];

    // Build the graph using an adjacency list. graph.get(i) is the list of nodes to which node i has outgoing edges
    List<List<Integer>> graph = new ArrayList<>();
    for (int i = 0; i < numCourses; i++)
        graph.add(new ArrayList<>());

    // Add edges from each prerequisite and update in-degrees. This completes the dependency graph and the in-degree of each node
    for (int[] p : prerequisites) {
        graph.get(p[1]).add(p[0]);  // Add edge from p[1] to p[0]
        inDegree[p[0]]++;           // Increment the in-degree of p[0] by 1
    }

    // Enqueue nodes with in-degree 0 (no prerequisites). These are the courses you can take first
    Queue<Integer> queue = new LinkedList<>();
    for (int i = 0; i < numCourses; i++)
        if (inDegree[i] == 0)
            queue.offer(i);

    // Process nodes with in-degree 0 in order using BFS
    int count = 0;  // Variable to track the number of processed courses
    while (!queue.isEmpty()) {
        int course = queue.poll();
        count++;  // Treat this node as a completed course

        // Decrement the in-degree of each neighbor by 1 (meaning one prerequisite is fulfilled). If it reaches 0, all prerequisites are met, so enqueue it
        for (int nei : graph.get(course))
            if (--inDegree[nei] == 0)
                queue.offer(nei);
    }

    // If all nodes are processed, no cycle exists (all courses can be completed). Nodes within a cycle never reach in-degree 0 and remain unprocessed
    return count == numCourses;
}
```
