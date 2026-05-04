# Traversing a Binary Tree Level by Level — Grouping Binary Tree Nodes by Level into Lists

## Problem

You are given the `root` of a binary tree. Group the nodes by **level (depth)**, store the node values at each level from left to right in a `List<Integer>`, and return a `List<List<Integer>>` ordered from the top level to the bottom level.

## Key Insight

A Queue allows you to process nodes in breadth-first order from left to right. By recording the queue size at the start of each level and dequeuing exactly that many nodes, you can precisely manage level boundaries.

## Thought Process

1. **Breadth-first search (BFS) is suited for level-by-level processing**: Depth-first search (DFS) traverses deep along a single branch, making level-based grouping difficult. BFS processes nodes in order of increasing depth, so it naturally corresponds to level-order traversal.
2. **Use a queue to implement BFS**: A queue is a FIFO (first-in, first-out) data structure that enables BFS behavior by processing shallower nodes (added earlier) before deeper ones.
3. **Determine level boundaries using queue size**: At the start of processing each level, all nodes currently in the queue belong to the same level. Record `queue.size()` into a variable `size` at this point, and dequeue exactly `size` nodes to process exactly one level.
4. **Add the children of each dequeued node to the queue as the next level**: When you dequeue a node, add its left and right children to the queue. These children will not be dequeued during the current level's processing (because the loop count is limited by `size`). They will be processed as the next level in the next iteration of the while loop.
5. **Collect each level's results into a list and return them**: Create a `List<Integer>` for each level and store that level's node values in it. After finishing one level, add this list to the final `List<List<Integer>>`.
6. **Processing is complete when the queue becomes empty**: Once all nodes have been dequeued, the queue becomes empty and the while loop terminates. At this point, the result list contains node values for all levels ordered from top to bottom.

## Prerequisites

### Queue

A first-in, first-out (FIFO) data structure. The element added first is removed first. In Java, you use LinkedList as an implementation of the Queue interface.

```java
Queue<TreeNode> queue = new LinkedList<>();  // Create an empty queue
queue.offer(node);   // Add node to the end of the queue
queue.poll();        // Remove and return the element at the front of the queue
queue.size();        // Return the number of elements in the queue → int
queue.isEmpty();     // Return whether the queue is empty as a boolean
```

### BFS (Breadth-First Search)

An algorithm that explores a graph or tree in the "breadth" direction. It processes nodes in order of proximity to the starting point. It is implemented using a queue. When applied to a tree, it visits nodes in the order level 0 → level 1 → level 2 and so on.

### TreeNode Structure

A class representing each node in a binary tree. It has three fields: the value `val`, the left child `left`, and the right child `right`.

```java
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
}
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm processes every node in the tree exactly once |
| Space | O(n) — The queue stores at most the number of nodes in the widest level of the tree (n/2 in the worst case) |

## Code

```java
// Input: root node of a binary tree, root
// Output: returns a List<List<Integer>> containing node values grouped by level
List<List<Integer>> levelOrder(TreeNode root) {
    // Final result that stores the list of node values for each level
    List<List<Integer>> result = new ArrayList<>();

    // If root is null, the tree is empty, so return the empty result as-is
    if (root == null) return result;

    // Create a queue for BFS and add the root node
    // At this point, the queue contains only one node at level 0
    Queue<TreeNode> queue = new LinkedList<>();
    queue.offer(root);

    // Repeat level-by-level processing until the queue becomes empty
    // When the queue becomes empty, all nodes have been processed
    while (!queue.isEmpty()) {
        // Note: you must save this value into a variable before the loop
        // Adding child nodes to the queue inside the for loop changes the queue size,
        // so using queue.size() directly in the for loop condition would break level boundaries
        int size = queue.size();
        // List to store node values for the current level
        List<Integer> level = new ArrayList<>();

        for (int i = 0; i < size; i++) {
            // Dequeue the node at the front of the queue
            TreeNode node = queue.poll();
            // Add the node's value to the current level's list
            level.add(node.val);

            // If the left child exists, add it to the queue (it will be processed at the next level)
            if (node.left != null)
                queue.offer(node.left);
            // If the right child exists, add it to the queue
            // By adding children in left-to-right order, the next level is also processed left to right
            if (node.right != null)
                queue.offer(node.right);
        }

        // One level's processing is complete, so add it to the result
        result.add(level);
    }
    // Return result containing node values for all levels ordered from top to bottom
    return result;
}
```
