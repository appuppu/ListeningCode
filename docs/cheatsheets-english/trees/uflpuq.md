# Checking if a Tree is a Subtree of Another

## Problem

You are given two binary trees `root` and `subRoot`. You return a `boolean` indicating whether `root` contains a subtree that is identical to `subRoot` in both structure and values. A subtree means that when you take some node in `root` as the root, the entire tree below that node is identical to `subRoot`.

## Key Insight

If you serialize each tree into a string using preorder traversal with null markers, the subtree check reduces to a string search problem — determining whether one string contains another string as a substring.

## Thought Process

1. **Subtree matching requires comparing the entire shape and values of a tree**: For one tree to be a subtree of another, the structure and all node values below some node must match exactly. This means you need a method that preserves structural information for comparison.
2. **A unique representation of a tree makes comparison straightforward**: Comparing trees directly requires recursive traversal at every node. If you serialize each tree into a string, you convert structural and value comparison into string comparison, which you can process efficiently.
3. **Preorder traversal with null markers guarantees uniqueness**: Preorder traversal alone can produce the same string for different trees. By inserting a marker such as `#` at every position where a child is null, you encode the tree structure uniquely.
4. **Prepending a comma delimiter before each node value prevents ambiguity**: You prepend a comma `,` before each node value to clearly separate value boundaries. This prevents confusion between values like `2` and `12`.
5. **Subtree detection reduces to substring containment**: If the serialized string of `subRoot` appears as a substring within the serialized string of `root`, then `subRoot` is a subtree of `root`. Java's `String.contains()` performs this check in O(m+n) time.

## Prerequisites

### Preorder Traversal of a Binary Tree

Preorder traversal visits nodes in the order "root → left child → right child." When implemented recursively, you process the current node first, then recursively traverse the left subtree, and finally recursively traverse the right subtree.

```java
void preorder(TreeNode node) {
    if (node == null) return;
    System.out.println(node.val);  // Process the root
    preorder(node.left);           // Recursively traverse the left subtree
    preorder(node.right);          // Recursively traverse the right subtree
}
```

### StringBuilder

StringBuilder is a class for concatenating strings efficiently. The `+` operator on `String` creates a new object on every concatenation, but `StringBuilder` appends to an internal buffer in O(1) time.

```java
StringBuilder sb = new StringBuilder();  // Create an empty StringBuilder
sb.append(",5");                         // Append the string ",5" to the end of the buffer
sb.append(",#");                         // Append the string ",#" to the end of the buffer
sb.toString();                           // Convert the buffer contents to a String → ",5,#"
```

### String.contains()

This method returns a `boolean` indicating whether a string contains another string as a substring.

```java
String s = ",1,2,#,#,3,#,#";
s.contains(",2,#,#");    // Check whether s contains ",2,#,#" → true
s.contains(",4,#,#");    // Check whether s contains ",4,#,#" → false
```

### Null Marker

A null marker is a special symbol inserted at positions where a child node does not exist (is null) during tree serialization. The symbol `#` is commonly used. Without null markers, different tree structures can produce the same traversal result. For example, you need null markers to distinguish a tree that has only a left child from a tree that has only a right child.

## Complexity

| | Value |
|---|---|
| Time | O(m + n) — You traverse root (m nodes) and subRoot (n nodes) once each to serialize them, then perform substring containment check |
| Space | O(m + n) — You store the serialized results of both trees in StringBuilders |

## Code

```java
// Input: root nodes of two binary trees, root and subRoot
// Output: return true if subRoot is a subtree of root, otherwise return false

// Helper method that serializes a tree into a string using preorder traversal
void serialize(TreeNode node, StringBuilder sb) {
    if (node == null) {
        // Append null marker ",#" to indicate that no child node exists
        // This allows distinguishing a tree with only a left child from one with only a right child
        sb.append(",#");
        return;
    }
    // Prepend a comma before the value to prevent boundary ambiguity between values like 2 and 12
    sb.append("," + node.val);
    // Recursively serialize the left subtree
    serialize(node.left, sb);
    // Recursively serialize the right subtree
    serialize(node.right, sb);
}

boolean isSubtree(TreeNode root, TreeNode subRoot) {
    // sb1 stores the serialized result of root, sb2 stores the serialized result of subRoot
    StringBuilder sb1 = new StringBuilder();
    StringBuilder sb2 = new StringBuilder();

    // Serialize both trees into strings using preorder traversal
    serialize(root, sb1);
    serialize(subRoot, sb2);

    // If the string of root contains the string of subRoot as a substring, then subRoot is a subtree
    return sb1.toString().contains(sb2.toString());
}
```
