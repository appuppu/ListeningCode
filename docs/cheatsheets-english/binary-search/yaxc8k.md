# Designing a Time-Based Key-Value Store

## Problem

Design a data structure that stores key-value pairs with timestamps via `set(key, value, timestamp)` and returns the value corresponding to the largest timestamp less than or equal to the specified timestamp via `get(key, timestamp)`. The system returns an empty string when no applicable timestamp exists.

## Key Insight

If you maintain timestamps in sorted order for each key, you can search for the largest key less than or equal to a given value in logarithmic time. Java's TreeMap provides this operation natively through the `floorEntry` method.

## Thought Process

1. **Organize the operations**: `set` adds a timestamp-value pair to a key, and `get` returns the value corresponding to the largest timestamp less than or equal to the specified timestamp. The essence of `get` is a search problem: "find the largest value that does not exceed a given value."
2. **Manage timestamps per key**: Different keys are independent of each other, so the outer HashMap separates data by key, and each key holds a timestamp-to-value mapping.
3. **Choose a data structure that efficiently finds the largest value less than or equal to a target**: Finding the largest value not exceeding a target in sorted data requires binary search. A TreeMap (a balanced binary search tree based on a red-black tree) maintains keys in sorted order and returns the largest entry less than or equal to a specified key in O(log n) via `floorEntry(key)`.
4. **Determine the set implementation**: If the key does not exist in the outer HashMap, create a new TreeMap. Then `put` the timestamp as the key and the value as the value into the TreeMap. Using `computeIfAbsent` allows you to write the existence check and creation in a single line.
5. **Determine the get implementation**: First check whether the key exists in the HashMap; if it does not, return an empty string. If it does, call `floorEntry(timestamp)` on the TreeMap and return the value if the result is not null, or an empty string if it is null.
6. **Handle edge cases**: Return an empty string in two cases: when the key itself is not registered, and when the key exists but all its timestamps are greater than the specified value.

## Prerequisites

### What is a HashMap

A HashMap is a data structure that stores key-value pairs. It retrieves and searches for values by key in O(1) time.

```java
HashMap<String, TreeMap<Integer, String>> map = new HashMap<>();  // Create an empty HashMap
map.containsKey("foo");    // Return a boolean indicating whether key "foo" exists
map.get("foo");            // Return the value associated with key "foo"
```

### What is computeIfAbsent

`computeIfAbsent` is a HashMap method. It generates and registers a value using a lambda expression only when the key is not registered, and returns that value. If the key already exists, it returns the existing value. This method combines existence check, creation, and registration into a single line.

```java
map.computeIfAbsent("foo", k -> new TreeMap<>());
// "foo" is not registered → Create a new TreeMap, register it, and return that TreeMap
// "foo" is already registered → Return the existing TreeMap
```

### What is a TreeMap

A TreeMap is a balanced binary search tree-based Map that maintains keys in sorted order (ascending). Unlike a regular HashMap, it provides search operations based on key ordering. Both `put` and `get` operate in O(log n) time.

```java
TreeMap<Integer, String> tree = new TreeMap<>();  // Create an empty TreeMap
tree.put(1, "one");        // Store "one" at timestamp 1
tree.put(3, "three");      // Store "three" at timestamp 3
tree.put(5, "five");       // Store "five" at timestamp 5
```

### What is floorEntry

`floorEntry` is a TreeMap method. It returns the entry (key-value pair) corresponding to the largest key less than or equal to the specified key. It returns null when no applicable entry exists. It operates in O(log n) because it performs binary search internally.

```java
tree.floorEntry(4);   // Largest key ≤ 4 → Return the entry for key 3: {3="three"}
tree.floorEntry(5);   // Largest key ≤ 5 → Return the entry for key 5: {5="five"}
tree.floorEntry(0);   // No entry with key ≤ 0 exists → Return null

Map.Entry<Integer, String> entry = tree.floorEntry(4);
entry.getValue();     // Get the value from the entry → "three"
```

## Complexity

| | Value |
|---|---|
| Time | O(log n) — Both set and get perform TreeMap operations in O(log n), where n is the number of timestamps stored for that key |
| Space | O(n) — The system stores all entries saved across all set calls, where n is the total number of entries |

## Code

```java
// Input: set(key, value, timestamp) — string key, string value, integer timestamp / get(key, timestamp) — string key, integer timestamp
// Output: set returns void / get returns the corresponding value as a string (returns empty string if no match)
class TimeMap {
    // HashMap that holds a TreeMap of (timestamp → value) for each key
    // The outer HashMap separates data by key, and the inner TreeMap maintains timestamps in sorted order
    Map<String, TreeMap<Integer, String>> map;

    public TimeMap() {
        // Create a HashMap as the outer data structure
        map = new HashMap<>();
    }

    public void set(String key, String val, int ts) {
        // computeIfAbsent automatically creates and registers a new TreeMap if the key is not registered, or returns the existing TreeMap otherwise
        // TreeMap places keys in sorted order upon insertion, so no explicit sorting operation is needed
        map.computeIfAbsent(key, k -> new TreeMap<>())
            .put(ts, val);
    }

    public String get(String key, int ts) {
        // If the key itself does not exist, set has never been called for it, so return an empty string
        if (!map.containsKey(key))
            return "";

        // Retrieve the TreeMap for this key
        TreeMap<Integer, String> tree = map.get(key);

        // Search for the largest entry with timestamp ≤ the specified timestamp (TreeMap traverses its internal BST in O(log n))
        Map.Entry<Integer, String> entry = tree.floorEntry(ts);

        // If an entry is found, return its value. If null, all timestamps are greater than the specified value, so return an empty string
        return entry != null ? entry.getValue() : "";
    }
}
```
