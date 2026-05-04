# Designing a Least Recently Used Cache — Design a cache that automatically evicts the least recently used element when capacity is exceeded

## Problem

Design a cache that stores integer keys and values. The cache must support two operations, `get(key)` and `put(key, value)`, and both must run in O(1) time. When the cache exceeds its `capacity`, the cache must automatically evict the **Least Recently Used element** before inserting a new element.

## Key Insight

If you create a Java LinkedHashMap in access-order mode and override `removeEldestEntry`, every get/put call automatically updates the access order, and the oldest element is automatically evicted when capacity is exceeded. The entire LRU cache functionality can be implemented using only the internal mechanisms of LinkedHashMap.

## Thought Process

1. **O(1) get/put is required**: A HashMap is necessary for fast key-to-value access. However, a standard HashMap has no ability to track the usage order of elements.
2. **Usage order tracking is required**: An LRU cache must identify the least recently used element. The cache needs an ordered structure where each accessed element moves to the most recent position, and the element remaining at the head becomes the oldest.
3. **LinkedHashMap combines both capabilities**: Java's LinkedHashMap provides HashMap functionality and additionally maintains an internal doubly linked list. Passing `true` as the third constructor argument enables access-order mode, which automatically moves the accessed element to the tail of the list on every get or put call.
4. **Automatic eviction on capacity overflow**: Override the `removeEldestEntry` method of LinkedHashMap to return `true` when `size() > capacity`. LinkedHashMap calls this method immediately after a new element is put, and if the method returns `true`, LinkedHashMap automatically removes the element at the head of the list (the oldest element).
5. **Handling a nonexistent key in get**: The problem specification requires the cache to return `-1` when the key does not exist. Using `getOrDefault(key, -1)` performs the existence check and value retrieval in a single call.
6. **Final structure**: The constructor creates a LinkedHashMap in access-order mode and overrides `removeEldestEntry`. Both the get and put methods simply delegate to the LinkedHashMap.

## Prerequisites

### What is LinkedHashMap

LinkedHashMap is a data structure that provides all the functionality of HashMap and additionally maintains element order using an internal doubly linked list. When you pass `true` to the `accessOrder` third constructor argument, every access (get or put) to an element moves that element to the tail of the list. The element that has not been accessed for the longest time remains at the head of the list.

```java
// Arg 1: initial capacity, Arg 2: load factor, Arg 3: true = access-order mode
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(16, 0.75f, true);
map.put(1, 10);     // Store value 10 for key 1. List: [1]
map.put(2, 20);     // Store value 20 for key 2. List: [1, 2]
map.get(1);          // Access key 1. List: [2, 1] (1 moves to the tail)
map.put(3, 30);     // Store value 30 for key 3. List: [2, 1, 3]
// At this point, key 2 at the head of the list is the least recently used element
```

### What is removeEldestEntry

`removeEldestEntry` is a method that LinkedHashMap automatically calls immediately after a new element is put. When this method returns `true`, LinkedHashMap automatically removes the oldest element at the head of the list. By default, this method always returns `false`, so you must override it to define the eviction condition.

```java
LinkedHashMap<Integer, Integer> map = new LinkedHashMap<>(cap, 0.75f, true) {
    @Override
    protected boolean removeEldestEntry(Map.Entry<Integer, Integer> eldest) {
        return size() > cap;  // Return true when size exceeds capacity, causing the oldest element to be removed
    }
};
```

### What is getOrDefault

`getOrDefault` is a method of the Map interface. It returns the value associated with the key if the key exists, and returns the default value specified as the second argument if the key does not exist. This method consolidates two separate calls to `containsKey` and `get` into a single call.

```java
map.put(1, 10);
map.getOrDefault(1, -1);   // Key 1 exists, so the method returns value 10
map.getOrDefault(99, -1);  // Key 99 does not exist, so the method returns default value -1
```

## Complexity

| | Value |
|---|---|
| Time | O(1) — Both get and put operate in O(1) because HashMap access and linked list repositioning are all O(1) operations |
| Space | O(n) — The LinkedHashMap stores up to capacity elements (n is capacity) |

## Code

```java
// Input: constructor receives integer capacity (maximum cache size), get receives integer key, put receives integer key and integer value
// Output: get returns the value for the key (returns -1 if the key does not exist). put returns nothing
class LRUCache {
    LinkedHashMap<Integer, Integer> map;
    // Instance variable to store capacity. Used for eviction check inside removeEldestEntry
    int cap;

    // Receive capacity and initialize a LinkedHashMap in access-order mode
    LRUCache(int capacity) {
        cap = capacity;
        // Arg 1: initial capacity, Arg 2: default load factor, Arg 3: true = access-order mode
        // Access-order mode automatically moves the accessed element to the tail of the list on every get or put
        map = new LinkedHashMap<>(cap, 0.75f, true) {
            // Method that LinkedHashMap automatically calls after every put
            // Returns true when size() > cap, causing the oldest element at the head of the list to be automatically removed
            // This ensures the cache size never exceeds cap
            protected boolean removeEldestEntry(Map.Entry<Integer, Integer> e) {
                return size() > cap;
            }
        };
    }

    // If the key exists: access-order mode moves the element to the tail of the list (marking it as most recent), and the value is returned
    // If the key does not exist: the default value -1 is returned
    int get(int key) {
        return map.getOrDefault(key, -1);
    }

    // Insert or update a key-value pair
    // After insertion, removeEldestEntry is automatically called, and if size() > cap, the oldest element is evicted
    // If the key already exists, the value is overwritten and the element moves to the tail of the list
    void put(int key, int value) {
        map.put(key, value);
    }
}
```
