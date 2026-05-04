# Checking if Two Binary Trees Are Identical — Determine whether two binary trees have the same structure and values

## Problem

The problem gives you two binary trees `p` and `q`. Two trees are "identical" when their structures match exactly and every corresponding node holds the same value. The function returns `true` if the trees are identical and `false` otherwise.

## Key Insight

The algorithm enqueues corresponding nodes from both trees as pairs and dequeues them one pair at a time in level order. If every pair matches in both structure and value, the trees are identical. If any single pair differs, the algorithm immediately concludes the trees are not identical.

## Thought Process

1. **Compare corresponding nodes one pair at a time**: To determine whether two trees are identical, the algorithm compares nodes at the same position in each tree, one pair at a time. If every pair has equal values and identical structure (presence or absence of children), the two trees are identical.
2. **Manage pairs with a queue**: The algorithm needs to process pairs of nodes in order. A queue (FIFO) lets the algorithm dequeue and compare pairs level by level in breadth-first order. The queue stores `TreeNode[]` arrays of size 2, where `pair[0]` represents a node from tree p and `pair[1]` represents a node from tree q.
3. **Evaluate three cases for each dequeued pair**: The algorithm checks three cases in order for each dequeued pair: (a) if both nodes are null, the structure matches at this position, so the algorithm proceeds to the next pair; (b) if only one node is null, the structure differs, so the algorithm returns `false`; (c) if both nodes are non-null but their values differ, the algorithm returns `false`.
4. **Enqueue child pairs after a pair passes all checks**: When the current pair matches, the algorithm must next compare the left children and the right children. The algorithm enqueues `{n1.left, n2.left}` and `{n1.right, n2.right}` as two new pairs. The algorithm may enqueue null children because step 3's null checks handle them correctly.
5. **An empty queue means all pairs matched**: If the algorithm finishes comparing every pair without finding a mismatch, the two trees are identical, so the algorithm returns `true`.

## Prerequisites

### Queue

A queue is a first-in, first-out (FIFO) data structure. The queue returns the element that was added first before any element added later. Breadth-first search uses a queue to process nodes level by level. Java implements the `Queue` interface with `LinkedList`.

```java
Queue<TreeNode[]> queue = new LinkedList<>();  // Create a queue that stores TreeNode arrays
queue.add(new TreeNode[]{p, q});               // Add a pair (2-element array) to the tail of the queue
TreeNode[] pair = queue.poll();                 // Remove and return the pair at the head of the queue (returns null if the queue is empty)
queue.isEmpty();                               // Return whether the queue is empty → true/false
```

### TreeNode

TreeNode is a class that represents each node in a binary tree. The `val` field stores the node's value, and the `left` and `right` fields hold references to the left child node and the right child node, respectively. A field is `null` when the corresponding child does not exist.

```java
TreeNode node = new TreeNode(5);   // Create a node with value 5
node.val;                          // Get the node's value → 5
node.left;                         // Get the left child node (null if it does not exist)
node.right;                        // Get the right child node (null if it does not exist)
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm compares up to n nodes from each tree exactly once |
| Space | O(n) — The queue holds a number of pairs proportional to the node count |

## Code

```java
// Input: root nodes p and q of two binary trees
// Output: return true if the two trees are identical in structure and values, false otherwise
public boolean isSameTree(TreeNode p, TreeNode q) {
    // Create a queue to manage pairs of nodes to compare
    // Each pair is stored as a TreeNode[] array of size 2, where pair[0] is a node from tree p and pair[1] is a node from tree q
    Queue<TreeNode[]> queue = new LinkedList<>();
    // Add the root node pair as the initial state (the first pair to compare)
    queue.add(new TreeNode[]{p, q});

    // Dequeue and compare one pair at a time while the queue is not empty
    while (!queue.isEmpty()) {
        // Dequeue the pair at the head of the queue
        TreeNode[] pair = queue.poll();
        TreeNode n1 = pair[0];
        TreeNode n2 = pair[1];

        // If both are null, neither tree has a child at this position, so the structure matches. Proceed to the next pair
        if (n1 == null && n2 == null)
            continue;
        // If only one is null, one tree has a node where the other does not, so the structure differs
        if (n1 == null || n2 == null)
            return false;
        // If the values differ, the corresponding nodes do not match, so return false
        if (n1.val != n2.val)
            return false;

        // The current pair matched, so enqueue the child node pairs to compare next
        // Null children are enqueued as-is (the null checks above handle them correctly)
        queue.add(new TreeNode[]{n1.left, n2.left});
        queue.add(new TreeNode[]{n1.right, n2.right});
    }
    // All pairs matched in both structure and value, so return true
    return true;
}
```
