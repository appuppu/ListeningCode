# Finding the K Most Frequent Elements — Return the K elements with the highest frequency from an array

## Problem

The function receives an integer array `nums` and an integer `k`. It selects the top `k` elements with the highest occurrence count from `nums` and returns them as an array. The order of the returned elements does not matter. The problem guarantees that the answer is unique.

## Key Insight

After counting the frequency of each element, the algorithm creates a bucket array that uses frequency as its index. This approach extracts elements in frequency order in O(n) time without using sorting (O(n log n)). The maximum frequency cannot exceed the array length `n`, so the bucket array has a finite size.

## Thought Process

1. **The algorithm must first count the occurrence of each element**: To find the top K most frequent elements, the algorithm needs to know how many times each element appears. A HashMap stores each number as a key and its occurrence count as a value, aggregating all frequencies in O(n) time.
2. **The algorithm needs frequency ordering, but sorting costs O(n log n)**: Once the frequency map is complete, the algorithm must extract the top K elements by frequency. Sorting by frequency costs O(n log n), but a faster method exists.
3. **The algorithm uses a bucket array indexed by frequency**: When the array length is `n`, no element can appear more than `n` times. The algorithm prepares an array of size `n+1` and stores a list of elements with frequency `i` at index `i`. This is the concept behind bucket sort.
4. **The algorithm traverses the bucket array from the end to collect K elements**: A higher index in the bucket array corresponds to a higher frequency. The algorithm scans from the tail (index `n`) toward the head and adds elements from each non-empty bucket to the result list. When the result list reaches size `k`, the algorithm converts the list to an array and returns it.

## Prerequisites

### What is a HashMap

A HashMap is a data structure that stores key-value pairs. It retrieves and looks up values by key in O(1) time. In this problem, the algorithm uses a HashMap as a counter to count the occurrence of each number.

```java
HashMap<Integer, Integer> map = new HashMap<>();  // Create an empty HashMap
map.merge(1, 1, Integer::sum);  // Add 1 to the value of key 1 (initialize to 1 if the key does not exist)
map.entrySet();                 // Return all key-value pairs as a Set
entry.getKey();                 // Get the key from a pair
entry.getValue();               // Get the value from a pair
```

### What is the merge method

`map.merge(key, value, remappingFunction)` stores `value` directly if the key does not exist, and combines the existing value with `value` using `remappingFunction` if the key already exists. Passing `Integer::sum` adds `value` to the existing value. This method provides a one-line shorthand for the `put` + `getOrDefault` combination.

```java
map.merge(5, 1, Integer::sum);  // Store 1 if key 5 does not exist, or store existing value + 1 if it does
// The above is equivalent to the following
map.put(5, map.getOrDefault(5, 0) + 1);
```

### What is bucket sort

Bucket sort is a sorting technique that distributes elements into array positions using the element values themselves as indices. Unlike comparison-based sorting (O(n log n)), bucket sort runs in O(n) time when the range of values is finite. In this problem, the algorithm uses occurrence frequency (maximum `n`) as the index.

```java
List<Integer>[] buckets = new ArrayList[4];  // Create a bucket array with indices 0 to 3
buckets[2] = new ArrayList<>();              // Initialize the bucket at index 2
buckets[2].add(7);                           // Store 7 as an element with frequency 2
// buckets = [null, null, [7], null]
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — Building the frequency map takes O(n), constructing the bucket array takes O(n), and collecting the results takes O(n), so the overall time is O(n) |
| Space | O(n) — The frequency map holds at most n entries, the bucket array has size n+1, so the overall space is O(n) |

## Code

```java
// Input: an integer array nums and an integer k
// Output: return an int[] containing the top k elements with the highest frequency
public int[] topKFrequent(int[] nums, int k) {
    // Step 1: Count the frequency of each element using a HashMap
    Map<Integer, Integer> freqMap = buildFrequencyMap(nums);
    // Step 2: Build a bucket array indexed by frequency
    List<Integer>[] buckets = buildBuckets(freqMap, nums.length);
    // Step 3: Traverse the bucket array from the end to collect the top K elements
    return collectTopK(buckets, k);
}

// Count the occurrence of each element using a HashMap and return it
// Key = number, Value = occurrence count of that number
public Map<Integer, Integer> buildFrequencyMap(int[] nums) {
    Map<Integer, Integer> freqMap = new HashMap<>();
    for (int num : nums) {
        // merge initializes to 1 if the key does not exist, or adds 1 to the existing value
        freqMap.merge(num, 1, Integer::sum);
    }
    // After traversal, the HashMap contains the frequency of every element
    return freqMap;
}

// Build and return a bucket array indexed by frequency
// buckets[i] contains a list of elements that appear exactly i times
public List<Integer>[] buildBuckets(Map<Integer, Integer> freqMap, int n) {
    // The size is n+1 because an element can appear at most n times, requiring indices 0 through n
    List<Integer>[] buckets = new ArrayList[n + 1];
    for (var entry : freqMap.entrySet()) {
        int num = entry.getKey();
        int freq = entry.getValue();
        // Create a new ArrayList if the bucket is null before adding
        if (buckets[freq] == null) {
            buckets[freq] = new ArrayList<>();
        }
        // Add the number num to the bucket at the index corresponding to its frequency freq
        buckets[freq].add(num);
    }
    return buckets;
}

// Traverse the bucket array from the end and collect K elements in descending order of frequency
// Higher indices correspond to higher frequencies, so reverse traversal extracts the most frequent elements first
public int[] collectTopK(List<Integer>[] buckets, int k) {
    List<Integer> result = new ArrayList<>();
    // Traverse from the tail (index n) toward the head. Exclude index 0 because it represents frequency 0
    for (int i = buckets.length - 1; i > 0; i--) {
        if (buckets[i] != null) {
            for (int num : buckets[i]) {
                result.add(num);
                // Return the result as an array as soon as K elements are collected
                if (result.size() == k) {
                    return result.stream().mapToInt(Integer::intValue).toArray();
                }
            }
        }
    }
    // The problem constraints guarantee an answer exists, so this line is unreachable
    return new int[0];
}
```
