# Viewing a Binary Tree From the Right Side — Return the values of nodes visible when viewing a binary tree from the right side

## Problem

You are given the `root` of a binary tree. When you view the tree from the right side, only the rightmost node at each depth is visible. Return a `List<Integer>` containing the values of those visible nodes, ordered from top (root) to bottom.

## Key Insight

If you perform a DFS that visits the right child first, the first node you reach at each depth is always the "node visible from the right side." You can determine whether a node is the first visited at its depth simply by comparing the current depth to the size of the result list.

## Thought Process

1. **What is a node visible from the right side**: The node positioned furthest to the right at each depth is the "node visible from the right side." This means the problem reduces to selecting exactly one node per depth.
2. **Consider a DFS that visits the right child first**: When traversing the tree with DFS, if you recursively visit the right child before the left child, you reach the rightmost node at each depth first. By leveraging this property, you only need to record the first node visited at each depth.
3. **How to determine "first visit at each depth"**: The size of the result list `result` represents "the number of depths recorded so far." If the current `depth` equals `result.size()`, it means no node at that depth has been recorded yet. You call `result.add(node.val)` only when this condition holds.
4. **Structure of the recursion**: At each node, the process follows this order: "record the value if the depth is new" → "recurse on the right child" → "recurse on the left child." Because the right child is visited first, right-side nodes are recorded preferentially at each depth.
5. **Base case**: When the node is `null`, the method simply returns without doing anything. This allows the recursion to terminate naturally beyond leaf nodes.
6. **What to return at the end**: After the DFS completes, the `result` list contains the values of the nodes visible from the right side, ordered from depth 0 onward. You return this list as-is.

## Prerequisites

### DFS (Depth-First Search)

DFS is an algorithm for traversing trees and graphs. It starts from a given node, goes as deep as possible, and then backtracks. You can implement DFS naturally using recursion.

```java
void dfs(TreeNode node) {
    if (node == null) return;  // Base case: do nothing if null
    // Perform processing on node here
    dfs(node.left);   // Recursively traverse the left child
    dfs(node.right);  // Recursively traverse the right child
}
```

### List's size() and add()

A `List` is a variable-length array. `size()` returns the current number of elements, and `add()` appends an element to the end. Elements are indexed as 0, 1, 2... in the order they were added.

```java
List<Integer> list = new ArrayList<>();  // Create an empty list
list.size();      // Returns the current number of elements → 0
list.add(5);      // Append 5 to the end → [5]
list.add(3);      // Append 3 to the end → [5, 3]
list.size();      // → 2
```

### Depth

Depth is the number of edges from the root to a given node. The root has depth 0, the root's children have depth 1, and the grandchildren have depth 2. You can track each node's depth by passing `depth + 1` in the recursive call.

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm visits every node exactly once |
| Space | O(h) — The recursion call stack requires space proportional to the height of the tree (h is the height of the tree) |

## Code

```java
// Input: root node of a binary tree, root
// Output: List<Integer> containing the values of nodes visible from the right side, ordered from top to bottom
List<Integer> rightSideView(TreeNode root) {
    // List to store the value of the rightmost node at each depth
    // The list index corresponds to the depth (index 0 = depth 0)
    List<Integer> result = new ArrayList<>();
    dfs(root, 0, result);
    // After DFS completes, result contains the values of nodes visible from the right side, ordered from depth 0 onward
    return result;
}

void dfs(TreeNode node, int depth,
         List<Integer> result) {
    // Base case: do nothing if null (terminates recursion for non-existent children beyond leaf nodes)
    if (node == null) return;

    // If depth == result.size(), no node at this depth has been recorded yet
    // result.size() represents "the number of depths recorded so far"
    if (depth == result.size()) {
        // Since this DFS visits the right child first, the first node reached at each depth is always the rightmost node
        result.add(node.val);
    }

    // Visit the right child first so that the rightmost node at each depth is recorded first
    // This is the core of the algorithm: visit in right → left order
    dfs(node.right, depth + 1, result);
    // At depths where no right child exists, the left child becomes "the first node visited at that depth" and is correctly recorded
    dfs(node.left, depth + 1, result);
}
```
