# Finding the Kth Smallest Element in a BST

## Problem

You are given the root node `root` of a binary search tree (BST) and an integer `k`. You need to return the **kth smallest value** among all node values in the BST. The tree is guaranteed to contain at least k nodes.

## Key Insight

An in-order traversal of a BST visits nodes in ascending order. Therefore, the value of the kth node visited during an in-order traversal is the answer. You do not need to traverse all nodes; you can stop immediately upon reaching the kth node.

## Thought Process

1. **Leverage the BST property**: In a BST, every node satisfies "all nodes in the left subtree < the node itself < all nodes in the right subtree." This property guarantees that an in-order traversal (left → self → right) produces node values in ascending order.
2. **The kth smallest value is the kth element in the in-order traversal**: The kth element of the ascending sequence produced by an in-order traversal is the answer, so you can simply count nodes as you traverse.
3. **Choose an iterative traversal with a stack instead of recursion**: With recursion, you cannot return immediately upon reaching the kth node (you need to unwind the call stack). With an iterative traversal using a stack, you can return the moment you find the kth node.
4. **Implement in-order traversal using a stack**: From the current node, keep following the left child and push each node onto the stack. When you reach the leftmost node, pop from the stack and "visit" that node. Then move to the right child and repeat the same process.
5. **Detect the kth node with a counter**: Each time you pop and visit a node, decrement k. When k reaches 0, the value of that node is the answer.
6. **What to return**: Return the node value `curr.val` at the point when k reaches 0.

## Prerequisites

### In-Order Traversal of a BST

In-order traversal visits a binary search tree in the order "left subtree → self → right subtree." When you perform an in-order traversal on a BST, you obtain node values in ascending order.

```
Example:     5
            / \
           3   7
          / \
         2   4

In-order traversal result: 2, 3, 4, 5, 7 (ascending order)
```

### Stack

A stack is a last-in, first-out (LIFO) data structure. The element added last is the first one removed. In an in-order traversal, you use a stack to remember the parent nodes you passed through while following left children.

```java
Stack<TreeNode> stack = new Stack<>();  // Create an empty stack
stack.push(node);      // Push node onto the top of the stack
stack.pop();           // Remove and return the top element of the stack
stack.isEmpty();       // Return a boolean indicating whether the stack is empty
```

### Iterative In-Order Traversal Pattern

An iterative in-order traversal using a stack repeats the cycle: "go as far left as possible → pop and visit → move to the right child." The loop continues as long as either the current node is not null or the stack is not empty.

```java
TreeNode curr = root;
while (curr != null || !stack.isEmpty()) {
    while (curr != null) {       // Go as far left as possible
        stack.push(curr);
        curr = curr.left;
    }
    curr = stack.pop();          // Visit (nodes are obtained in ascending order here)
    curr = curr.right;           // Move to the right child
}
```

## Complexity

| | Value |
|---|---|
| Time | O(h + k) — Descend h times to the leftmost node and pop k nodes |
| Space | O(h) — The stack holds at most h nodes, where h is the height of the tree |

## Code

```java
// Input: the root node of a BST and an integer k
// Output: return the kth smallest node value in the BST as an int
public int kthSmallest(TreeNode root, int k) {
    // A stack to temporarily store parent nodes passed while following left children, so we can return to them later
    Stack<TreeNode> stack = new Stack<>();
    // A pointer to the node currently being examined
    TreeNode curr = root;

    // Continue as long as there are unvisited nodes: either curr is not null or the stack still has nodes
    while (curr != null || !stack.isEmpty()) {
        // Go as far left as possible, pushing each node onto the stack (reaching the minimum value in the current subtree)
        while (curr != null) {
            stack.push(curr);
            curr = curr.left;
        }

        // The popped node is the next node to visit in the in-order traversal (the smallest value among unvisited nodes)
        curr = stack.pop();
        // Popping corresponds to visiting one node in the in-order traversal, so decrement the remaining visit count by one
        k--;

        // If k reaches 0, this node is the kth smallest element, so return its value immediately
        if (k == 0)
            return curr.val;

        // If a right subtree exists, the next iteration will go as far left as possible within it. Otherwise, curr becomes null and the parent will be popped from the stack
        curr = curr.right;
    }
    // Due to the problem constraints, the tree contains at least k nodes, so this line is never reached
    return -1;
}
```
