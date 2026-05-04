# Two Sum — Find a Pair of Numbers That Adds Up to the Target

## Problem

You are given an integer array `nums` and an integer `target`. Find two elements in `nums` that add up to `target`, and return their **indices** as an array. Exactly one solution exists, and you cannot use the same element twice.

## Key Insight

When you traverse the array, each element `nums[i]` uniquely determines its pair partner (`target - nums[i]`). If you record previously seen elements in a HashMap, you can check whether the partner exists in O(1) time and find the answer in a single pass.

## Thought Process

1. **You can compute the pair partner directly**: Since you are looking for a pair that sums to `target`, the other value for the current element `nums[i]` is uniquely determined as `complement = target - nums[i]`.
2. **You want to quickly determine whether the partner has appeared before**: If you record every number you have seen so far while traversing the array, you can check whether the complement has been recorded in O(1) time. A HashMap is ideal for this recording.
3. **Decide what to store in the HashMap**: The problem requires you to return indices, so you store the "number" as the key and "its index" as the value. This lets you confirm the partner's existence and retrieve its index at the same time.
4. **Build the HashMap as you traverse**: Traverse the array from the beginning, and for each element, check whether the complement exists in the HashMap. If it does, you have found the pair. If it does not, register the current element in the HashMap and move on.
5. **Register after checking, not before**: If you register `nums[i]` in the HashMap before checking, `nums[i]` itself could match as the complement. Therefore, you must always check first, then register.
6. **What to return**: When you find the complement in the HashMap, return `map.get(complement)` (the partner's index) and `i` (the current index) as an `int[]`.

## Prerequisites

### What Is a HashMap

A HashMap is a data structure that stores key-value pairs. It can search for and retrieve a value by key in O(1) time. Think of it as a dictionary that provides the same access speed as array index access but allows any key.

```java
HashMap<Integer, Integer> map = new HashMap<>();  // Create an empty HashMap
map.put(10, 0);           // Store value 0 with key 10
map.containsKey(10);      // Return whether key 10 exists as a boolean → true
map.get(10);              // Return the value associated with key 10 → 0
```

### What Is a Complement

A complement is the value obtained by subtracting the current element from `target`. It represents the pair partner. You compute it as `complement = target - nums[i]`.
Example: When target=9 and nums[i]=2, complement=7. If 7 exists in the array, the pair is complete.

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm only needs to traverse the array once |
| Space | O(n) — The HashMap stores at most n elements |

## Code

```java
// Input: integer array nums and integer target
// Output: return the indices of the two elements that sum to target as an int[]
public int[] twoSum(int[] nums, int target) {
    // HashMap where key = number, value = that number's index
    // The problem asks for indices, not values, so we store indices as values
    HashMap<Integer, Integer> map = new HashMap<>();

    for (int i = 0; i < nums.length; i++) {
        // Compute the pair partner and store it in a variable to reuse in containsKey and get
        int complement = target - nums[i];

        // If the complement is already registered in the HashMap, the pair is found
        if (map.containsKey(complement)) {
            // map.get(complement) is the partner's index, i is the current index
            return new int[]{map.get(complement), i};
        }

        // Note: register after checking. Registering first would let nums[i] match itself
        map.put(nums[i], i);
    }
    // Per the problem constraints, a solution always exists, so this line is never reached
    return new int[]{};
}
```
