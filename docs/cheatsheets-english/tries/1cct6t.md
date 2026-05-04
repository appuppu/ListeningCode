# Implementing a Prefix Tree — Design a data structure that efficiently performs insertion, exact match search, and prefix search for given strings

## Problem

Design and implement a data structure called a Trie (prefix tree). This data structure must support three operations: (1) `insert(word)` inserts a word, (2) `search(word)` determines whether an exactly matching word exists, and (3) `startsWith(prefix)` determines whether any inserted word starts with the specified prefix.

## Key Insight

If you decompose strings into a tree structure with one node per character, words that share a common prefix will share nodes. By adding a flag to each node that indicates "a word ends here," the only difference between exact match search and prefix search becomes whether or not you check that flag at the end of traversal.

## Thought Process

1. **Expand strings into a tree structure one character at a time**: Represent each character of the inserted word as a node, and use parent-child relationships to express the ordering of characters. This way, words sharing a common prefix like "apple" and "app" can share the first three nodes (a→p→p)
2. **Manage each node's children with a HashMap**: Each node has child nodes corresponding to the next possible characters. Use a HashMap to manage children, storing the character as the key and the reference to the child node as the value. This allows O(1) transition to any character
3. **A flag is needed to distinguish word endings**: After inserting "apple," searching for "app" would successfully traverse the nodes a→p→p. However, since "app" has not been inserted, the search must return false. By adding an `isEnd` flag to each node and setting `isEnd = true` on the last node during `insert`, you can distinguish word endings
4. **All three operations are fundamentally node traversals**: `insert`, `search`, and `startsWith` all start from the root and traverse nodes one character at a time through the string. `insert` creates a new node when the next node does not exist. `search` and `startsWith` immediately return false when the next node does not exist
5. **The only difference between search and startsWith is checking isEnd**: `search` checks whether `node.isEnd` is true after traversing all characters. `startsWith` returns true as long as it successfully traverses all characters. The traversal logic is identical; only the final check differs
6. **The root node is a dummy node**: The root node, which serves as the starting point of the Trie, is initialized as an empty node that holds no character. All operations begin traversal from this root node

## Prerequisites

### What is a Trie

A Trie is a tree structure for efficiently storing and searching strings. Each node corresponds to one character, and a path from the root to a leaf represents one string. Strings that share a common prefix share nodes, making the Trie well-suited for prefix searches.

```
Example: Tree structure after inserting "app", "apple", "bat"

      root
      / \
     a   b
     |   |
     p   a
     |   |
     p*  t*
     |
     l
     |
     e*

* indicates nodes where isEnd = true (word endings)
```

### What is a HashMap

A HashMap is a data structure that stores key-value pairs. It can search for and retrieve values by key in O(1) time. In a Trie, a HashMap manages the child nodes of each node.

```java
HashMap<Character, TrieNode> children = new HashMap<>();  // Create an empty HashMap
children.put('a', new TrieNode());      // Store a new node with key 'a'
children.containsKey('a');              // Return a boolean indicating whether key 'a' exists → true
children.get('a');                      // Return the node corresponding to key 'a'
children.putIfAbsent('a', new TrieNode());  // Store a value only if key 'a' is not already registered
```

### What is putIfAbsent

putIfAbsent is a HashMap method that stores a value only when the specified key does not yet exist. If the key already exists, it does nothing. The `insert` operation uses putIfAbsent to add only new nodes without destroying existing paths.

```java
map.putIfAbsent('a', new TrieNode());  // Register a new node if 'a' is not yet registered
map.putIfAbsent('a', new TrieNode());  // 'a' is already registered, so this does nothing
```

## Complexity

| | Value |
|---|---|
| Time | O(m) — insert, search, and startsWith each traverse the string of length m exactly once |
| Space | O(n * m) — The Trie stores n words with an average length of m. Actual usage is less than this because shared prefixes share nodes |

## Code

```java
// Input: insert(word) takes a string word, search(word) takes a string word, startsWith(prefix) takes a string prefix
// Output: insert returns void (adds a word to the Trie), search returns a boolean indicating whether an exactly matching word exists, startsWith returns a boolean indicating whether a word matching the prefix exists

// TrieNode class: Represents each node in the Trie
class TrieNode {
    // Mapping to child nodes. Key = character, Value = corresponding child node
    Map<Character, TrieNode> children;
    // Flag indicating whether a word ends at this node (default is false)
    // This flag allows search to distinguish between exact matches and prefix matches
    boolean isEnd;

    TrieNode() {
        children = new HashMap<>();
        isEnd = false;
    }
}

class Trie {
    // Root node that serves as the starting point for all operations (an empty dummy node holding no character)
    private TrieNode root;

    // Constructor creates an empty TrieNode as the root
    public Trie() {
        root = new TrieNode();
    }

    public void insert(String word) {
        // node is a pointer representing the current traversal position. Start traversal from the root
        TrieNode node = root;
        // Traverse the string word one character at a time from the beginning
        for (char c : word.toCharArray()) {
            // putIfAbsent creates a new child node if one does not exist, and does nothing if one already exists
            // Using putIfAbsent avoids overwriting existing paths (nodes shared by other words)
            node.children.putIfAbsent(c, new TrieNode());
            // Advance the pointer to the child node corresponding to character c
            node = node.children.get(c);
        }
        // Set the word-ending flag on the last node
        // This flag allows search to distinguish that "apple" is inserted but "app" is not
        node.isEnd = true;
    }

    public boolean search(String word) {
        // Start traversal from the root
        TrieNode node = root;
        // Traverse the string word one character at a time from the beginning
        for (char c : word.toCharArray()) {
            // If the corresponding child node does not exist, no path for this character exists in the Trie, so return false immediately
            if (!node.children.containsKey(c))
                return false;
            // Advance the pointer to the child node
            node = node.children.get(c);
        }
        // Return true if the node reached after traversing all characters is a word ending, false otherwise
        // This correctly returns false for search("app") when "apple" is inserted but "app" is not
        return node.isEnd;
    }

    public boolean startsWith(String prefix) {
        // Start traversal from the root
        TrieNode node = root;
        // Traverse the string prefix one character at a time from the beginning
        for (char c : prefix.toCharArray()) {
            // If the corresponding child node does not exist, no path for this prefix exists in the Trie, so return false immediately
            if (!node.children.containsKey(c))
                return false;
            // Advance the pointer to the child node
            node = node.children.get(c);
        }
        // All characters were successfully traversed, so a word starting with this prefix exists in the Trie
        // The only difference from search is that this method does not check isEnd
        return true;
    }
}
```
