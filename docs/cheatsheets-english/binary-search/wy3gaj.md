# Searching for a Target in a Sorted Array

## Problem

You are given a sorted integer array `nums` and an integer `target`. You need to find the element in the array that matches `target` and return its **index**. If `target` does not exist in the array, you return `-1`.

## Key Insight

Because the array is sorted, you can narrow the search range in half each time by comparing the middle element with the target. This approach completes the search in O(log n) instead of O(n), which would require checking every element.

## Thought Process

1. **Leverage the sorted condition**: Because the array is sorted, you can look at any element and determine whether the target lies to its left or right. This property allows you to halve the search range each time.
2. **Manage the search range with two pointers**: You represent the search range with two pointers: `left` for the left boundary and `right` for the right boundary. The initial state covers the entire array.
3. **Compare the middle element with the target**: You calculate the middle index `mid` of the search range and compare `nums[mid]` with `target`. If they match, `mid` is the answer.
4. **Halve the search range based on the comparison result**: If `nums[mid] < target`, the target lies to the right of the middle, so you shrink the left boundary with `left = mid + 1`. If `nums[mid] > target`, the target lies to the left of the middle, so you shrink the right boundary with `right = mid - 1`.
5. **Repeat until the search range is exhausted**: You continue searching as long as `left <= right`. When `left > right`, the search range is empty, meaning the target does not exist in the array, so you return `-1`.
6. **Prevent overflow when calculating the middle index**: The expression `mid = (left + right) / 2` can cause `left + right` to exceed the maximum integer value. You avoid this overflow by writing `mid = left + (right - left) / 2` instead.

## Prerequisites

### What is Binary Search?

Binary search is an algorithm that efficiently finds a target element in a sorted array by halving the search range each time. It compares the middle element of the search range with the target, and if they do not match, it discards either the left half or the right half. By repeating this process, the number of comparisons becomes O(log n).

```java
// Number of searches when the array length is 8
// 1st: 8 → 4 (halve the range)
// 2nd: 4 → 2 (halve the range)
// 3rd: 2 → 1 (halve the range)
// Maximum 3 times = log₂(8) = 3
```

### Calculating the Middle Index

You find the midpoint between two pointers `left` and `right`. You use `left + (right - left) / 2` instead of `(left + right) / 2` to prevent integer overflow from the `left + right` addition.

```java
int left = 0;
int right = 10;
int mid = left + (right - left) / 2;  // mid = 0 + (10 - 0) / 2 = 5
```

### The While Loop Condition `left <= right`

The condition `left <= right` means that at least one element remains in the search range. When `left == right`, exactly one element remains in the search range, and you still need to check this element. Therefore, you use `<=` instead of `<`.

```java
// When left=3 and right=3, nums[3] has not been checked yet
// left <= right evaluates to true, so you can check nums[3]
// left < right would evaluate to false, causing you to skip nums[3]
```

## Complexity

| | Value |
|---|---|
| Time | O(log n) — The search halves the range each time, so it requires at most log₂(n) comparisons |
| Space | O(1) — The algorithm uses only pointer variables and requires no additional data structures |

## Code

```java
// Input: sorted integer array nums and integer target
// Output: return the index of the element matching target as int. Return -1 if it does not exist
public int binarySearch(int[] nums, int target) {
    // Initialize the left and right boundaries of the search range. These two variables manage the search range
    int left = 0;
    int right = nums.length - 1;

    // left <= right: repeat while at least one element remains in the search range
    // When left > right, the search range is empty, so exit the loop
    while (left <= right) {
        // Note: (left + right) / 2 can cause integer overflow from the left + right addition
        // Writing left + (right - left) / 2 prevents the overflow
        int mid = left
            + (right - left) / 2;

        // If the middle element matches the target, return its index
        if (nums[mid] == target) {
            return mid;
        }

        // If the target is greater than the middle element, narrow the search range to the right half
        // Use mid + 1 because mid itself has already been checked
        if (nums[mid] < target) {
            left = mid + 1;
        }
        // If the target is less than the middle element, narrow the search range to the left half
        // Use mid - 1 because mid itself has already been checked
        else {
            right = mid - 1;
        }
    }

    // The search range is empty, so the target does not exist in the array
    return -1;
}
```
