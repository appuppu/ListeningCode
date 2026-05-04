# Finding the Diameter of a Binary Tree — Find the longest path (number of edges) in a binary tree

## Problem

You are given the `root` of a binary tree. Return the length (number of edges) of the longest path between any two nodes in the tree. This path does not need to pass through the root.

## Key Insight

At any node, "left subtree height + right subtree height + 2" equals the number of edges in the longest path passing through that node. By computing the height of each node via DFS while tracking the maximum of this value, you can determine the diameter in a single traversal.

## Thought Process

1. **The diameter passes through some node as its "apex"**: The longest path always takes one node as its highest point (turning point), going from somewhere in that node's left subtree to somewhere in its right subtree. Therefore, you compute "the path length with that node as the apex" for each node, and the maximum among all nodes is the diameter.
2. **The path length through an apex is determined by the left and right heights**: The number of edges in a path with a given node as the apex is "left subtree height + right subtree height + 2". The left height represents the number of edges to the deepest left-side node, and the right height represents the number of edges to the deepest right-side node. Adding 2 accounts for the one edge from the apex to each child.
3. **Align the definition of height with "number of edges"**: Define a node's height as "the number of edges from that node to its farthest leaf." Under this definition, a leaf node has height 0, and a null node has height -1. Setting null to -1 allows the leaf node's height to be naturally computed as `1 + max(-1, -1) = 0`.
4. **Update the diameter while returning heights via DFS**: Use a post-order DFS to recursively obtain the heights of each node's left and right children. From the obtained left and right heights, compute "the path length with that node as the apex," update the global variable `maxDiameter`, and return the node's own height `1 + max(left, right)` as the return value.
5. **Track the maximum value with a global variable**: The DFS return value is the "height," not the "diameter," so you record the maximum diameter in the global variable `maxDiameter`. At each node, you compare `left + right + 2` with the current `maxDiameter` and keep the larger value.
6. **What to return at the end**: After the DFS has traversed all nodes, the value stored in `maxDiameter` is the diameter of the entire tree.

## Prerequisites

### Height of a Binary Tree

The number of edges in the path from a given node to its farthest leaf node. A leaf node has height 0, and a null node has height -1 by definition. The height of a parent node is computed as `1 + max(left child's height, right child's height)`.

```
      1          Height of node 1: 2 (edges in 1→2→4)
     / \         Height of node 2: 1 (edges in 2→4)
    2   3        Height of node 3: 0 (leaf node)
   /             Height of node 4: 0 (leaf node)
  4
```

### DFS (Depth-First Search) Using Recursion

A technique that recursively visits each node of a tree. In post-order traversal, processing occurs in the order: left child → right child → current node. This approach is suitable when you need to use the children's results to compute the parent's value.

```java
int dfs(TreeNode node) {
    if (node == null) return -1;   // Base case: a null node has height -1
    int left = dfs(node.left);     // Recursively process the left subtree
    int right = dfs(node.right);   // Recursively process the right subtree
    return 1 + Math.max(left, right);  // Compute and return the current node's height
}
```

### Math.max

A standard Java method that returns the larger of two values.

```java
Math.max(3, 5);    // → 5
Math.max(-1, -1);  // → -1
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — A single DFS that visits each node exactly once is sufficient |
| Space | O(n) — The call stack from recursive calls can reach a maximum depth of n (in the case of a skewed tree) |

## Code

```java
// Input: the root node of a binary tree, root
// Output: the diameter of the tree (number of edges in the longest path between any two nodes) as an int

// Global variable that holds the maximum diameter found during DFS traversal
// The initial value is 0 because the diameter of a tree with only one node is 0
int maxDiameter = 0;

// Recursive function that returns each node's height while updating maxDiameter as a side effect
int dfs(TreeNode node) {
    // A null node has height -1 (representing the absence of any edge)
    // Returning -1 allows the parent (a leaf node) to correctly compute its height as 1 + max(-1, -1) = 0
    if (node == null) return -1;

    // Recursively obtain the height of the left subtree
    int left = dfs(node.left);
    // Recursively obtain the height of the right subtree
    int right = dfs(node.right);

    // Update the maximum diameter using the number of edges in the path through the current node (left + right + 2)
    // The +2 accounts for the two edges from the current node to its left and right children
    maxDiameter = Math.max(
        maxDiameter,
        left + right + 2);

    // Return the current node's height to its parent (note: this is the height, not the diameter)
    // The parent node uses this value to compute its own path length
    return 1 + Math.max(left, right);
}

public int diameterOfBinaryTree(TreeNode root) {
    // Traverse all nodes via DFS and update maxDiameter from the path length at each node as the apex
    dfs(root);
    // After traversal is complete, maxDiameter holds the diameter of the entire tree
    return maxDiameter;
}
```
