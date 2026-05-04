# Searching for a Target in a Rotated Sorted Array

## Problem

You are given an integer array sorted in ascending order that has been rotated at an unknown pivot. You must find the given `target` value in this array and return its index. If `target` does not exist in the array, return `-1`. All elements are unique.

## Key Insight

When you split a rotated sorted array at the middle, one of the two halves (left or right) is always sorted. You can determine whether `target` falls within the sorted half by checking if it lies within that half's range. If `target` does not fall within the sorted half, you search the other half. This approach halves the search range at every step.

## Thought Process

1. **You want to use Binary Search because the array is sorted**: For a normal sorted array, Binary Search finds elements in O(log n) time. You need to find a way to maintain this efficiency even with rotation.
2. **Splitting a rotated array at the middle guarantees one sorted half**: For the array `[4,5,6,7,0,1,2]` split at `mid=3` (value 7), the left half `[4,5,6,7]` is sorted and the right half `[0,1,2]` is also sorted. The rotation pivot exists in only one half, so the other half always maintains ascending order.
3. **You determine which half is sorted by comparing endpoints**: If `nums[left] <= nums[mid]` holds, the left half is sorted. Otherwise, the right half is sorted. You include the equals sign to correctly handle the case where `left == mid` (when the search range has two or fewer elements).
4. **You check whether target lies within the sorted half**: The sorted half has known minimum and maximum values, so you can determine whether `target` falls within that range using inequality checks. For example, if the left half is sorted, you check `target >= nums[left] && target < nums[mid]`.
5. **You search the half that contains target**: If `target` falls within the range of the sorted half, you narrow the search to that half. If `target` falls outside that range, it must exist in the other half, so you search there instead.
6. **You handle loop termination**: If the loop runs until `left > right` without finding `target`, then `target` does not exist in the array, so you return `-1`.

## Prerequisites

### Binary Search

Binary Search is a search technique that repeatedly examines the middle element of a sorted array and halves the search range. Because the range halves at every step, Binary Search achieves O(log n) time complexity.

```java
int left = 0;
int right = nums.length - 1;
while (left <= right) {                    // Loop while the search range is valid
    int mid = left + (right - left) / 2;   // Calculate middle index to prevent overflow
    // Compare nums[mid] with target and update left or right accordingly
}
```

### Rotated Sorted Array

A rotated sorted array is an ascending sorted array that has been split at some position, with the second half moved to the front. For example, rotating `[0,1,2,4,5,6,7]` at index 4 produces `[4,5,6,7,0,1,2]`. The entire array is not sorted, but each side of the pivot is individually sorted.

```
Original array:  [0, 1, 2, 4, 5, 6, 7]
After rotation:  [4, 5, 6, 7, 0, 1, 2]
                  sorted↑    ↑sorted
```

## Complexity

| | Value |
|---|---|
| Time | O(log n) — The search range halves at every step, so at most log n comparisons are needed |
| Space | O(1) — Only three variables (left, right, mid) are used, and no additional data structures are required |

## Code

```java
// Input: a rotated sorted integer array nums and an integer target
// Output: return the index of target as int, or return -1 if target does not exist
public int search(int[] nums, int target) {
    // Initialize both ends of the search range. These two variables represent the boundaries of the search range
    int left = 0;
    int right = nums.length - 1;

    // When left > right, the search range is empty
    while (left <= right) {
        // Use this formula instead of (left + right) / 2 to prevent integer overflow of left + right
        int mid = left + (right - left) / 2;

        // If the middle element matches target, return its index
        if (nums[mid] == target) {
            return mid;
        }

        // Determine whether the left half is sorted
        // Include the equals sign so that when left == mid (search range has two or fewer elements), the left half is correctly identified as sorted
        if (nums[left] <= nums[mid]) {
            // Determine whether target lies within the range of the left half
            if (target >= nums[left] && target < nums[mid]) {
                right = mid - 1;  // Target lies within the left half, so narrow the search to the left half
            } else {
                left = mid + 1;   // Target lies outside the left half, so narrow the search to the right half
            }
        // The right half is sorted
        } else {
            // Determine whether target lies within the range of the right half
            if (target > nums[mid] && target <= nums[right]) {
                left = mid + 1;   // Target lies within the right half, so narrow the search to the right half
            } else {
                right = mid - 1;  // Target lies outside the right half, so narrow the search to the left half
            }
        }
    }

    // The search range is empty, so target does not exist in the array
    return -1;
}
```
