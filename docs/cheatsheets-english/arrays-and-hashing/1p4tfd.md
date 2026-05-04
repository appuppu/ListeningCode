# Finding Duplicates in an Array — Determine whether duplicate values exist in an array

## Problem

You are given an integer array `nums`. Return `true` if any value appears at least twice in the array, and return `false` if every element is distinct.

## Key Insight

You can determine whether each element has already appeared in O(1) time by scanning the array and recording every element you have seen so far in a HashSet. You can return `true` immediately the moment you find a duplicate.

## Thought Process

1. **Detecting duplicates means checking whether you have seen the same value before**: When you scan the array from the beginning, the current element is a duplicate if it has already appeared earlier. In other words, you can detect duplicates as long as you maintain a set of elements you have seen so far.
2. **You need to search previously seen elements quickly**: A HashSet is ideal for determining whether you have already seen a given value in O(1) time. A HashSet is a data structure that checks for the existence of an element in O(1) time.
3. **You only need to store values in the HashSet**: The problem only requires you to return a boolean rather than an index, so storing the values themselves in the HashSet is sufficient.
4. **You build the HashSet as you scan the array**: You scan the array from the beginning and check whether the HashSet already contains each element. If it does, you have found a duplicate. If it does not, you add the current element to the HashSet and move on to the next element.
5. **You improve efficiency by returning early**: You return `true` immediately when you find a duplicate. If you finish scanning the entire array without finding a duplicate, you return `false`.

## Prerequisites

### What is a HashSet?

A HashSet is a data structure that manages a collection of unique elements. It performs both insertion and existence checks in O(1) time. Unlike a HashMap, a HashSet stores only values rather than key-value pairs. It automatically eliminates duplicates.

```java
HashSet<Integer> set = new HashSet<>();  // Create an empty HashSet
set.add(10);              // Add element 10
set.contains(10);         // Check whether element 10 exists, returns boolean → true
set.contains(5);          // Check whether element 5 exists, returns boolean → false
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — You only need to scan the array once |
| Space | O(n) — The HashSet stores at most n elements |

## Code

```java
// Input: integer array nums
// Output: true if a duplicate value exists, false if all values are distinct
public boolean containsDuplicate(int[] nums) {
    // A HashSet that records elements seen so far during the scan
    // The problem only requires a boolean, so storing values alone is sufficient
    HashSet<Integer> seen = new HashSet<>();

    for (int num : nums) {
        // If the current element already exists in the HashSet, the same value has appeared twice, confirming a duplicate
        if (seen.contains(num)) {
            return true;  // Return immediately when a duplicate is found (early return)
        }

        // Add the current element to the HashSet and move on to the next element
        // This element will be referenced as a "previously seen element" in subsequent iterations
        seen.add(num);
    }
    // If the loop finishes without finding a duplicate, all elements are confirmed to be distinct
    return false;
}
```
