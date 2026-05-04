# Serializing and Deserializing a Binary Tree — Converting a Binary Tree to a String and Restoring the Original Tree Structure

## Problem

Design an algorithm that serializes a binary tree into a string and deserializes that string back into the original binary tree. The round trip must be lossless — the restored tree must be completely identical to the original tree.

## Key Insight

When you serialize a tree using preorder traversal, the "left child → right child" structure of each node is recorded recursively. If you explicitly record null as a sentinel value, deserialization can uniquely restore the original tree structure simply by consuming tokens sequentially from the beginning in a recursive manner.

## Thought Process

1. **What is required to uniquely restore a tree structure**: To uniquely determine the structure of a binary tree, you need information about whether each node's children exist or not. If you explicitly record the positions of null, you can uniquely reconstruct the tree structure from a single traversal order alone.
2. **Why preorder traversal is suitable**: Preorder visits nodes in the order "root → left subtree → right subtree." Because the root comes first, deserialization can recursively generate nodes while consuming tokens from the beginning. The traversal order matches the node generation order, making the implementation natural.
3. **Recording null as a sentinel value**: When a node is null, you record the string `"null"`. This allows deserialization to determine "the subtree ends here" as a boundary. Without the sentinel, you cannot identify where a subtree terminates.
4. **Serialization format**: You concatenate each node's value with commas as delimiters. The format looks like `"1,2,null,null,3,4,null,null,5,null,null"`. Splitting by commas produces an array of tokens.
5. **Deserialization consumes tokens recursively**: You poll (remove and return) tokens one by one from the front of the token list. If the retrieved value is `"null"`, you return null; otherwise, you create a node and recursively build its left and right children. Using a LinkedList enables O(1) polling from the front.
6. **The recursion order matches preorder**: The preorder sequence during serialization (root → left → right) and the recursive call order during deserialization (create node → left child → right child) match exactly, so consuming tokens in order correctly restores the tree.

## Prerequisites

### What Is Preorder Traversal

Preorder traversal is a method that recursively visits a binary tree in the order "root → left subtree → right subtree." Because the root is processed first, the beginning of the serialized data is always the root node.

```java
void preorder(TreeNode node) {
    if (node == null) return;
    visit(node);           // Process the root first
    preorder(node.left);   // Then recursively process the left subtree
    preorder(node.right);  // Finally recursively process the right subtree
}
```

### What Is StringBuilder

StringBuilder is a class for efficiently concatenating strings. String concatenation using the `+` operator creates a new String object each time, resulting in O(n²) complexity, but StringBuilder appends to an internal buffer, achieving O(n) complexity.

```java
StringBuilder sb = new StringBuilder();  // Create an empty StringBuilder
sb.append("hello");                      // Append a string to the end
sb.append(",");                          // Append a comma
sb.deleteCharAt(sb.length() - 1);        // Delete the last character
sb.toString();                           // Convert to String → "hello"
```

### LinkedList and the poll Method

LinkedList is a data structure that supports O(1) addition and removal at both the front and the end of the list. The `poll()` method removes and returns the first element of the list (the element is removed from the list). It returns null if the list is empty.

```java
LinkedList<String> tokens = new LinkedList<>(Arrays.asList("1", "2", "null"));
tokens.poll();  // Returns "1" and removes it from the list. Remaining: ["2", "null"]
tokens.poll();  // Returns "2" and removes it from the list. Remaining: ["null"]
```

### What Is a Sentinel Value

A sentinel value is a special value used to indicate the end of data or a special state. In this problem, the string `"null"` serves as a sentinel to represent "no child node exists at this position." The sentinel enables deserialization to accurately determine subtree boundaries.

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm visits all n nodes exactly once |
| Space | O(n) — The serialized string and token list use space for n elements. The recursion call stack is O(n) in the worst case (for a skewed tree) |

## Code

```java
// Input: Serialize — root node of a binary tree. Deserialize — comma-delimited string data
// Output: Serialize — comma-delimited string representing the tree. Deserialize — root node of the original binary tree

// Serialize a binary tree into a string
public String serialize(TreeNode root) {
    // Buffer to accumulate all node values as comma-delimited text
    StringBuilder sb = new StringBuilder();
    // Traverse the tree in preorder and append values to the StringBuilder
    serHelper(root, sb);
    // Remove the trailing extra comma
    if (sb.length() > 0)
        sb.deleteCharAt(sb.length() - 1);
    return sb.toString();
}

// Traverse the tree in preorder and append each node's value to the StringBuilder
void serHelper(TreeNode node, StringBuilder sb) {
    // Record null nodes as the sentinel value "null" (to identify subtree boundaries during deserialization)
    if (node == null) {
        sb.append("null,");
        return;
    }
    // Record the current node's value (preorder processes the root first)
    // Each value is separated by a comma
    sb.append(node.val).append(",");
    // Recursively process the left subtree
    serHelper(node.left, sb);
    // Recursively process the right subtree (root → left → right order achieves preorder)
    serHelper(node.right, sb);
}

// Deserialize a string into a binary tree
public TreeNode deserialize(String data) {
    // An empty string represents an empty tree
    if (data.isEmpty()) return null;
    // Split by commas and convert to a LinkedList (poll() is needed to remove from the front in O(1))
    LinkedList<String> tokens =
        new LinkedList<>(Arrays.asList(data.split(",")));
    // Recursively generate nodes while consuming tokens from the front
    return desHelper(tokens);
}

// Recursively generate nodes while consuming tokens from the front
TreeNode desHelper(LinkedList<String> tokens) {
    // Remove and return the front token (poll removes the element, so the next token becomes the front in the next recursion)
    String val = tokens.poll();
    // If the value is the sentinel, return null to terminate recursion (the parent node's child is set to null)
    if (val.equals("null")) return null;
    // Convert the token value to an integer and create a new node
    TreeNode node = new TreeNode(Integer.parseInt(val));
    // Build the left child first following preorder (the correct token corresponds because it matches the serialization order)
    node.left = desHelper(tokens);
    // Then build the right child
    node.right = desHelper(tokens);
    // Return the constructed node (the return value of the first call is the root node = the entire restored tree)
    return node;
}
```
