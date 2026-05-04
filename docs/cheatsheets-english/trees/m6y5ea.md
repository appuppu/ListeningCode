# Finding the Maximum Path Sum in a Binary Tree

## Problem

You are given a binary tree where each node holds an integer value (which can be negative). You must find the path that maximizes the sum of node values among all possible paths connecting nodes via edges (each node can appear at most once in a path), and return that **maximum sum**. The path does not need to pass through the root; it can go from any node to any other node.

## Key Insight

At each node, you calculate the "maximum gain from the left subtree" and the "maximum gain from the right subtree," then treat the sum of the path connecting left and right through that node as a candidate for the global maximum. However, the value you return to the parent must choose only one branch (left or right), because a path cannot branch at a node.

## Thought Process

1. **Analyze the structure of a path**: Every path has exactly one "highest node" (the apex). From that node's perspective, the path consists of three parts: "a descent into the left subtree," "the node itself," and "a descent into the right subtree." You try every node as the apex and find the maximum path sum across all of them.
2. **Define the gain at each node**: The "gain" of a node is the maximum sum you can carry upward toward the parent from the subtree rooted at that node. You compute the gain as "the node's value + the larger gain among its left and right children." Because a path cannot branch, you cannot return both the left and right gains to the parent simultaneously.
3. **Treat negative gains as 0**: If a child's gain is negative, including that branch would reduce the path sum. You use `Math.max(0, gain)` to clamp negative gains to 0 (meaning you skip that branch). This naturally handles cases where the optimal path is a single node or uses only one branch.
4. **Track the global maximum separately**: At each node, "left gain + node's value + right gain" represents the maximum path sum passing through that node as the apex. You compare this value against a global variable `maxSum` and update it accordingly. Because this calculation is independent from the gain returned to the parent, you must track it separately.
5. **Use postorder DFS for computation**: You need the children's gains before you can compute the current node's values, so postorder DFS (left → right → self) is the natural fit. This allows you to try every node as the apex in a single traversal.
6. **Return the final result**: After the DFS completes, `maxSum` holds the maximum path sum found across all nodes tried as the apex. You return this value.

## Prerequisites

### Postorder DFS on a Binary Tree

Postorder DFS is a traversal method that recursively visits nodes in the order "left child → right child → self." It is well suited for cases where you need the children's results before computing the parent's result.

```java
void postorder(TreeNode node) {
    if (node == null) return;     // Base case: do nothing if the node is null
    postorder(node.left);         // Process the left subtree first
    postorder(node.right);        // Process the right subtree next
    // Process the current node here (children's results are already computed)
}
```

### Math.max

A standard Java method that returns the larger of two values. It is used to clamp negative gains to 0 and to compare the left and right gains.

```java
Math.max(0, -5);    // → 0 (clamp a negative value to 0)
Math.max(3, 7);     // → 7 (return the larger value)
Math.max(0, gain(node.left));  // Clamp the left child's gain to 0 if it is negative
```

### Integer.MIN_VALUE

The smallest possible value of Java's `int` type (−2,147,483,648). It is used as the initial value in algorithms that find a maximum. It is guaranteed to be updated on the very first comparison with any value.

```java
int maxSum = Integer.MIN_VALUE;  // An initial value smaller than any possible path sum
maxSum = Math.max(maxSum, 10);   // → 10 (the first comparison always triggers an update)
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The DFS visits each node exactly once |
| Space | O(n) — The recursion call stack can reach a depth of n in the worst case (a skewed tree) |

## Code

```java
// Input: the root node of a binary tree (each node has an integer value val, a left child left, and a right child right)
// Output: return the maximum path sum among all possible paths in the binary tree as an int
class Solution {
    // Record the maximum path sum found across all nodes tried as the apex
    // Initialize to Integer.MIN_VALUE so that it is smaller than any negative path sum and is guaranteed to be updated on the first comparison
    int maxSum = Integer.MIN_VALUE;

    // A recursive function that returns the maximum gain you can carry upward toward the parent from this node (computed via postorder DFS: children before parent)
    int gain(TreeNode node) {
        // Base case: the gain of a null node is 0 (a nonexistent child contributes nothing)
        if (node == null) return 0;

        // Get the left child's gain and clamp it to 0 if negative (including a negative branch would reduce the path sum, so you choose not to use it)
        int leftGain = Math.max(0, gain(node.left));
        // Get the right child's gain and clamp it to 0 if negative for the same reason
        int rightGain = Math.max(0, gain(node.right));

        // Update the global maximum with the path sum that passes through the current node as the apex
        // This value represents the path "left subtree → current node → right subtree"
        // When leftGain or rightGain is 0, it represents a path using only one branch or the node alone
        maxSum = Math.max(maxSum, node.val + leftGain + rightGain);

        // Return only the larger branch's gain to the parent
        // A path must be continuous like a single stroke and cannot branch at one node, so you cannot return both branches
        return node.val + Math.max(leftGain, rightGain);
    }

    int maxPathSum(TreeNode root) {
        // Start the recursive DFS from the root to try every node as the apex
        gain(root);
        // After the DFS completes, maxSum holds the maximum path sum found among all paths
        return maxSum;
    }
}
```
