# Finding the Lowest Common Ancestor in a BST

## Problem

You are given a binary search tree (BST) and two nodes `p` and `q` that exist in the tree. Return the deepest node that has both nodes as descendants (Lowest Common Ancestor: LCA). A node is considered a descendant of itself.

## Key Insight

In a BST, all left descendants are smaller than the current node, and all right descendants are larger. The moment `p` and `q` split to the left and right sides of the current node, that node is the LCA.

## Thought Process

1. **We can leverage the BST property**: A BST guarantees the ordering that all values in the left subtree < node value < all values in the right subtree for any node. This property allows us to determine which subtree `p` and `q` belong to by simply comparing their values against the current node's value.
2. **If both are on the left, move left**: If both `p.val` and `q.val` are smaller than the current node's value, both `p` and `q` exist in the left subtree. The LCA must also be within that left subtree, so we move to the left child.
3. **If both are on the right, move right**: If both `p.val` and `q.val` are larger than the current node's value, both `p` and `q` exist in the right subtree. The LCA must also be within that right subtree, so we move to the right child.
4. **If they split left and right, the current node is the LCA**: If `p` and `q` are on opposite sides of the current node (one is smaller and the other is larger), no single subtree deeper than this node can contain both of them. Therefore, the current node is the LCA. If `p` or `q` equals the current node, that node is also the LCA because a node is considered a descendant of itself.
5. **We can use iteration instead of recursion**: Since each step moves in only one direction—either left or right—we do not need a recursive call stack. We simply update the current node in a while loop, which achieves O(1) space complexity.

## Prerequisites

### Binary Search Tree (BST)

A binary search tree is a binary tree in which every node satisfies the ordering "left descendants < self < right descendants." This property allows us to determine which subtree a node belongs to by comparing values alone.

```
        6
       / \
      2    8
     / \  / \
    0   4 7   9
```

In this tree, the LCA of node 2 and node 8 is 6. The LCA of node 2 and node 4 is 2 (node 2 is also a descendant of itself).

### Lowest Common Ancestor (LCA)

The lowest common ancestor of two nodes `p` and `q` is the deepest node (farthest from the root) that is an ancestor of both. If `p` or `q` itself is an ancestor of the other, that node itself is the LCA.

### TreeNode Structure

A class that represents each node in the BST. It has a value `val`, a left child `left`, and a right child `right`.

```java
TreeNode node = new TreeNode(6);   // Create a node with value 6
node.val;                           // Get the node's value → 6
node.left;                          // Get the left child node
node.right;                         // Get the right child node
```

## Complexity

| | Value |
|---|---|
| Time | O(h) — The algorithm traverses at most the height of the tree. For a balanced BST, this is O(log n). |
| Space | O(1) — The iterative approach uses no additional memory. |

## Code

```java
// Input: the root node of a BST root, and two nodes p and q that exist in the tree
// Output: return the TreeNode that is the lowest common ancestor (LCA) of p and q
TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    // Initialize the current search position to the root. The while loop updates it.
    TreeNode node = root;

    // Continue searching while node is not null
    while (node != null) {
        // Check whether both p and q are smaller than the current node
        if (p.val < node.val && q.val < node.val) {
            // Both exist in the left subtree, so the LCA is also in the left subtree
            node = node.left;
        // Check whether both p and q are larger than the current node
        } else if (p.val > node.val && q.val > node.val) {
            // Both exist in the right subtree, so the LCA is also in the right subtree
            node = node.right;
        } else {
            // p and q split to opposite sides (or one equals the current node)
            // No single deeper subtree can contain both nodes, so the LCA is confirmed
            return node;
        }
    }
    // By the problem's constraints, p and q exist in the tree, so the above return always executes and this line is unreachable
    return null;
}
```
