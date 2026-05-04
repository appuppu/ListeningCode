# Constructing a Binary Tree From Traversal Orders — Reconstructing the Original Binary Tree From Preorder and Inorder Traversals

## Problem

The function receives two integer arrays, `preorder` (preorder traversal) and `inorder` (inorder traversal). It constructs and returns the original binary tree from these two traversal results. The preorder traversal lists elements in "root → left → right" order, and the inorder traversal lists elements in "left → root → right" order.

## Key Insight

The first element of the preorder traversal is always the root of the current subtree. By finding where that root value appears in the inorder traversal, we can split the inorder traversal into "elements of the left subtree" and "elements of the right subtree." Repeating this split recursively reconstructs the entire tree.

## Thought Process

1. **The first element of the preorder traversal is the root**: The preorder traversal lists elements in "root → left → right" order, so the first element of the array is always the root node of the entire tree. This property holds recursively for every subtree.
2. **Finding the root's position in the inorder traversal enables a left-right split**: The inorder traversal follows "left → root → right" order, so when the root value is at position `mid` in the inorder traversal, all elements to the left of `mid` belong to the left subtree, and all elements to the right of `mid` belong to the right subtree.
3. **We want to find the root's position efficiently**: A linear search through the inorder traversal each time would cost O(n²) overall. By prebuilding a HashMap that maps "value → index in the inorder traversal," we can retrieve the root's position in O(1).
4. **We represent subtree ranges with index boundaries instead of copying arrays**: Copying arrays at each recursive call would require O(n²) space. By representing the inorder traversal range with two indices, `inLeft` and `inRight`, we can specify the subtree range without any array copying.
5. **We advance a global pointer through the preorder traversal**: The preorder traversal is ordered as "root → entire left subtree → entire right subtree," so by maintaining a global pointer `preIdx` and incrementing it each time we extract a root, the pointer naturally points to the right subtree's root once the left subtree recursion completes.
6. **We build the left subtree first**: The preorder traversal follows "root → left → right" order, so after extracting the root, we must always recursively build the left subtree first, then the right subtree. Maintaining this order ensures that `preIdx` advances correctly.

## Prerequisites

### Preorder Traversal

A traversal method that visits a binary tree in "root → left subtree → right subtree" order. The first element of the array is always the root node's value.

```
        3
       / \
      9   20
         / \
        15   7

Preorder: [3, 9, 20, 15, 7]  ← 3 at the front is the root
```

### Inorder Traversal

A traversal method that visits a binary tree in "left subtree → root → right subtree" order. Using the root's value as a reference point, elements to its left belong to the left subtree and elements to its right belong to the right subtree.

```
Inorder: [9, 3, 15, 20, 7]  ← [9] to the left of 3 is the left subtree; [15, 20, 7] to the right is the right subtree
```

### HashMap

A data structure that stores key-value pairs. It can search for and retrieve a value by its key in O(1).

```java
HashMap<Integer, Integer> map = new HashMap<>();  // Create an empty HashMap
map.put(3, 1);           // Store value 1 with key 3
map.get(3);              // Return the value for key 3 → 1
```

### TreeNode

A class representing a single node in a binary tree. It has a value `val`, a left child `left`, and a right child `right`.

```java
TreeNode root = new TreeNode(3);    // Create a node with value 3
root.left = new TreeNode(9);        // Set a node with value 9 as the left child
root.right = new TreeNode(20);      // Set a node with value 20 as the right child
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm processes each node exactly once, and each HashMap lookup takes O(1) |
| Space | O(n) — The HashMap stores n elements, and the recursion stack is O(n) in the worst case (for a skewed tree) |

## Code

```java
// Input: integer array preorder (preorder traversal) and integer array inorder (inorder traversal)
// Output: return the root TreeNode of the reconstructed binary tree

// HashMap that stores key=inorder value, value=that value's index in the inorder traversal
// Used to retrieve the root's position in the inorder traversal in O(1)
Map<Integer, Integer> map = new HashMap<>();
// Global pointer indicating the position of the next root to extract from the preorder array
// Incremented with each recursive call to advance through the array
int preIdx = 0;

public TreeNode buildTree(int[] preorder, int[] inorder) {
    // Register each value and its index from the inorder traversal into the HashMap
    // This allows instant lookup of any value's position in the inorder traversal
    for (int i = 0; i < inorder.length; i++)
        map.put(inorder[i], i);

    // Start recursion with the full array range (inLeft=0, inRight=last index)
    return helper(preorder, 0, inorder.length - 1);
}

// inLeft and inRight represent the current subtree's range within the inorder traversal array
TreeNode helper(int[] preorder, int inLeft, int inRight) {
    // If the subtree range is empty (inLeft > inRight), no child node exists
    if (inLeft > inRight) return null;

    // Extract the root value from the current position in the preorder traversal and advance the pointer
    int rootVal = preorder[preIdx++];
    TreeNode root = new TreeNode(rootVal);

    // Use the HashMap to find where the root value appears in the inorder traversal
    // mid marks the boundary between the left subtree and the right subtree in the inorder traversal
    int mid = map.get(rootVal);

    // Note: The preorder traversal is ordered as "root → left → right," so we must build the left subtree first
    // This order ensures that preIdx correctly points to the right subtree's root afterward
    // The left subtree spans from inLeft to mid-1 in the inorder traversal
    root.left = helper(preorder, inLeft, mid - 1);
    // The right subtree spans from mid+1 to inRight in the inorder traversal
    root.right = helper(preorder, mid + 1, inRight);

    // Return the constructed root node. When all recursion completes, the root of the entire tree is returned
    return root;
}
```
