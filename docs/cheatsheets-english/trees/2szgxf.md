# Counting Good Nodes in a Binary Tree

## Problem

Given a binary tree, a node is considered a "good node" if its value is greater than or equal to the maximum value among all nodes on the path from the root to that node. Return the number of good nodes in the entire tree.

## Key Insight

If you carry the "maximum value so far" while traversing from the root to each node, you can determine whether each node is a good node in O(1) time. By propagating the maximum value to child nodes during DFS traversal, you can find the answer by visiting every node exactly once.

## Thought Process

1. **Clarify the condition for judgment**: Whether a node is a good node depends only on comparing its value with the maximum value on the path from the root to that node. In other words, you can make the judgment as long as you know the maximum value on the path.
2. **Decide how to manage the maximum value on the path**: When you traverse the tree with DFS, the recursive call stack corresponds to the path from the root to the current node. By passing "the maximum value so far" as a parameter of the recursive function, each node obtains the information needed for judgment.
3. **Define the processing at each node**: If the current node's value is greater than or equal to the maximum value, it is a good node, so you add 1 to the result; otherwise you add 0. This performs both judgment and counting simultaneously.
4. **Update the maximum value passed to child nodes**: The maximum value passed to child nodes is the larger of the current maximum value and the current node's value. This ensures the maximum value updates monotonically non-decreasingly as the path extends.
5. **Recursively process the left and right subtrees**: Recursively compute the number of good nodes in the left subtree and the right subtree, then sum them with the current node's result and return.
6. **Initial maximum value for the first call**: The root node is always a good node (only itself is on the path). By setting the initial value to `Integer.MIN_VALUE`, the root's value is guaranteed to be greater than or equal to it, so the judgment works correctly.

## Prerequisites

### Recursive DFS (Depth-First Search)

Recursive DFS is an algorithm that traverses a tree or graph by prioritizing the deeper direction. In a binary tree, a recursive function calls itself on the left child and the right child. The recursive call stack implicitly maintains the path from the root to the current node.

```java
void dfs(TreeNode node) {
    if (node == null) return;  // Base case: return when reaching a null node
    // Process the current node
    dfs(node.left);            // Recursively traverse the left subtree
    dfs(node.right);           // Recursively traverse the right subtree
}
```

### Math.max

Math.max is a method that returns the larger of two values. You use it when updating the maximum value on the path.

```java
Math.max(5, 3);    // → 5 (returns the larger of 5 and 3)
Math.max(-1, 4);   // → 4
```

### Integer.MIN_VALUE

Integer.MIN_VALUE is the minimum value that Java's `int` type can hold (-2,147,483,648). Since any node's value is greater than or equal to this, using it as the initial maximum value ensures the root node is always judged as a good node.

```java
Integer.MIN_VALUE;  // → -2147483648 (minimum value of int type)
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm visits every node exactly once |
| Space | O(h) — The recursive call stack uses space proportional to the height of the tree |

## Code

```java
// Input: root node of a binary tree, root
// Output: return the total number of good nodes as an int

// Helper function: returns the number of good nodes in the subtree rooted at node
// maxSoFar represents the maximum value on the path from the root to the current node
private int dfs(TreeNode node, int maxSoFar) {
    // Base case: return 0 when reaching null (beyond a leaf node, so there are no nodes to count)
    if (node == null) return 0;

    // Determine whether the current node is a good node (it is good if its value >= the maximum on the path)
    int result = node.val >= maxSoFar ? 1 : 0;

    // Update the maximum value to pass to child nodes (update if the current node's value is larger; otherwise keep the existing maximum)
    int newMax = Math.max(maxSoFar, node.val);

    // Recursively compute the number of good nodes in the left subtree and add it
    result += dfs(node.left, newMax);
    // Recursively compute the number of good nodes in the right subtree and add it
    result += dfs(node.right, newMax);

    // Return the total number of good nodes in the entire subtree rooted at the current node
    return result;
}

public int goodNodes(TreeNode root) {
    // Setting the initial maximum to the minimum int value ensures the root node is always judged as a good node
    return dfs(root, Integer.MIN_VALUE);
}
```
