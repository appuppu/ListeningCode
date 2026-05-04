# Checking if a Binary Tree is Height-Balanced

## Problem

Given the root node `root` of a binary tree, determine whether the tree is **height-balanced**. A binary tree is height-balanced if, for every node, the difference between the height of the left subtree and the height of the right subtree is at most 1. Return the result as a `boolean`.

## Key Insight

During the recursive computation of each node's height, the algorithm returns `-1` and propagates it upward the moment it detects an imbalance. By performing height calculation and balance checking simultaneously in a single post-order traversal, the algorithm visits every node exactly once to produce the answer.

## Thought Process

1. **Capture the definition of balance recursively**: A tree is balanced if and only if the height difference between the left and right subtrees is at most 1 for every node. This means determining whether a node is balanced requires the heights of its left and right subtrees.
2. **Height calculation itself is recursive**: The height of a node equals `1 + max(left height, right height)`. Traversing the tree bottom-up (post-order) with this recursion naturally yields the height of each node.
3. **Integrate height calculation with balance checking**: Within the recursive function that returns height, the algorithm returns the special value `-1` the moment the height difference between left and right exceeds 1. This allows a single function to perform both height calculation and balance checking simultaneously.
4. **Eliminate unnecessary exploration with early termination**: If the left subtree's result is `-1`, the entire tree is imbalanced without needing to examine the right subtree. The algorithm checks whether each recursive return value is `-1` and immediately returns `-1` to cut off the recursion as soon as it detects an imbalance.
5. **Leverage the dual meaning of the return value**: A return value of `0 or greater` represents a valid height, while `-1` indicates an imbalance. The calling `isBalanced` method only needs to check whether the final return value is not `-1` to obtain the answer.

## Prerequisites

### Height of a Binary Tree

The height of a node is the number of edges on the longest path from that node to a leaf. A leaf node has a height of 1 (when counting by number of nodes), and `null` has a height of 0. Recursively, the formula is `height(node) = 1 + max(height(node.left), height(node.right))`.

```
        1           Height of node 1: 3
       / \          Height of node 2: 2
      2   3         Height of node 4: 1
     /              Height of node 3: 1
    4
```

### Post-Order Traversal

Post-order traversal processes nodes in the order: left subtree → right subtree → current node. Because the algorithm finalizes children's information before processing the parent, post-order traversal is well-suited for bottom-up aggregation tasks such as computing a parent's height from its children's heights.

```java
void postOrder(TreeNode node) {
    if (node == null) return;
    postOrder(node.left);   // Process the left subtree first
    postOrder(node.right);  // Process the right subtree next
    // Process the current node here (left and right results are already finalized)
}
```

### Math.abs

`Math.abs` is a standard Java method that returns the absolute value of an integer. The algorithm uses it to check whether the height difference between left and right subtrees is at most 1, regardless of which side is taller.

```java
Math.abs(3 - 1);    // → 2
Math.abs(1 - 3);    // → 2
Math.abs(2 - 3);    // → 1
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm visits each node exactly once |
| Space | O(n) — The recursion call stack reaches a maximum depth of n (when the tree is skewed) |

## Code

```java
// Input: root node of a binary tree, root
// Output: return true if the tree is height-balanced, false otherwise

// Recursive function that returns the height of a node. Returns sentinel value -1 if it detects an imbalance.
// A return value of 0 or greater represents a valid height; -1 means "some subtree is imbalanced."
private int checkHeight(TreeNode node) {
    // Base case: null represents an empty subtree with height 0
    if (node == null) return 0;

    // Recursively compute the height of the left subtree (the "left first" part of post-order traversal)
    int left = checkHeight(node.left);
    // If the left subtree is imbalanced, propagate -1 immediately without examining the right subtree (early termination)
    if (left == -1) return -1;

    // Recursively compute the height of the right subtree (the "right next" part of post-order traversal)
    int right = checkHeight(node.right);
    // If the right subtree is imbalanced, propagate -1 immediately
    if (right == -1) return -1;

    // If the height difference at the current node exceeds 1, it is imbalanced (the "process current node" part of post-order traversal)
    // Use Math.abs to correctly compute the difference regardless of which side is taller
    if (Math.abs(left - right) > 1)
        return -1;

    // If balanced, return the current node's height. The parent node will use this value in its computation.
    return 1 + Math.max(left, right);
}

public boolean isBalanced(TreeNode root) {
    // If checkHeight does not return -1, the entire tree is balanced
    // -1 is a sentinel value indicating "some subtree is imbalanced"
    return checkHeight(root) != -1;
}
```
