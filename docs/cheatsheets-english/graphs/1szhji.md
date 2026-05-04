# Deep Copying a Graph — Deep Copy All Nodes of a Connected Undirected Graph

## Problem

You are given a reference to one node of a connected undirected graph. You need to create a **deep copy (clone)** of the entire graph and return the corresponding node in the cloned graph. Each node has an integer value `val` and a list of adjacent nodes `neighbors`. You must construct a completely independent new graph that does not reference any node from the original graph.

## Key Insight

Because a graph can contain cycles, you use a HashMap to record the mapping from "original node → cloned node" so that you do not clone the same node twice. If a node has not been visited, you create its clone and register it in the HashMap. If a node has already been visited, you return its clone from the HashMap. This approach prevents infinite loops while accurately duplicating all nodes.

## Thought Process

1. **You need to traverse the graph**: To copy the entire graph, you must visit all nodes reachable from the starting node. Using DFS (Depth-First Search) with recursion is a natural approach for this traversal.
2. **You must handle cycles**: In an undirected graph, cycles such as A→B→A always exist. If you attempt to clone an already-visited node again, the program falls into an infinite loop. Therefore, you need a mechanism to determine whether a given node has already been cloned.
3. **You manage the mapping between original nodes and clones with a HashMap**: You prepare a `HashMap<Node, Node>` where the key is the original node and the value is its clone. This allows you to check whether a node has already been cloned in O(1) time and retrieve the existing clone in O(1) time.
4. **Each recursive step performs the following**: If the current node exists in the HashMap, you return its clone (the node has been visited). If the current node does not exist in the HashMap, you create a new Node, register it in the HashMap, recursively call the clone function on all neighbors of the original node, and add the returned clones to the current clone's neighbors list.
5. **You must register the clone before recursing**: You register the clone in the HashMap **before** making recursive calls on the neighbors. If you do not register it first, when a cycle leads back to the current node, the HashMap will not contain its clone, and the program will enter an infinite loop.
6. **You return the clone of the starting node**: The clone of the starting node is connected to all other cloned nodes through its adjacency list.

## Prerequisites

### What the Node Class Is

The Node class represents each vertex of the graph. It holds an integer value `val` and a list of adjacent nodes `neighbors`.

```java
class Node {
    public int val;
    public List<Node> neighbors;

    public Node(int val) {        // Create a node with the specified val
        this.val = val;
        this.neighbors = new ArrayList<>();  // The adjacency list is initialized as empty
    }
}
```

### What a HashMap Is

A HashMap is a data structure that stores key-value pairs. You can look up and retrieve a value by its key in O(1) time. In this problem, you store the original node as the key and its clone as the value, which serves both as a visited check and as a way to retrieve the clone.

```java
HashMap<Node, Node> map = new HashMap<>();  // Create an empty HashMap
map.put(original, clone);     // Store the original node as key and the clone as value
map.containsKey(original);    // Return a boolean indicating whether the original node is registered → true
map.get(original);            // Return the clone corresponding to the original node → clone
```

### What DFS (Depth-First Search) Is

DFS is a graph traversal algorithm. It proceeds as deep as possible in one direction and backtracks to explore another direction when it reaches a dead end. You can implement DFS naturally using recursive calls. Without visited-node management, DFS falls into an infinite loop when it encounters a cycle.

## Complexity

| | Value |
|---|---|
| Time | O(V + E) — The algorithm visits each node once (V) and processes each edge once (E) |
| Space | O(V) — The HashMap stores mappings for V nodes, and the recursion stack reaches a maximum depth of V |

## Code

```java
// Input: one node of a connected undirected graph (type: Node). null if the graph is empty
// Output: the cloned node corresponding to the input node in the deep copy of the entire graph (type: Node)

// HashMap that stores key=original node, value=cloned node
// Placed as a class field so that all recursive calls share it
Map<Node, Node> map = new HashMap<>();

public Node cloneGraph(Node node) {
    // If the graph is empty (null), return null
    if (node == null) return null;

    // If the current node has already been cloned, return its clone
    // This mechanism prevents infinite loops caused by cycles
    if (map.containsKey(node))
        return map.get(node);

    // Create a clone of the current node (neighbors is empty at this point)
    Node clone = new Node(node.val);

    // Note: registration must happen before the recursive calls in the for loop below
    // Without registering first, when a cycle leads back to this node, containsKey cannot detect it, causing an infinite loop
    map.put(node, clone);

    // Recursively clone all neighbors of the original node and add them to the clone's adjacency list
    // This builds the same adjacency relationships in the cloned graph as in the original graph
    for (Node nbr : node.neighbors) {
        clone.neighbors
            .add(cloneGraph(nbr));
    }

    // The clone returned to the initial call becomes the starting node of the entire cloned graph
    return clone;
}
```
