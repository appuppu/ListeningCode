# Finding the Minimum in a Rotated Sorted Array

## Problem

A sorted array of unique integers in ascending order has been rotated between 1 and n times. You need to find and return the **minimum element** in this rotated array. A rotation moves the last element of the array to the front, creating a "pivot" where the original sorted order breaks.

## Key Insight

In a rotated sorted array, the minimum value exists at the "pivot" position where the sorted order breaks. By comparing the middle element with the rightmost element, you can determine whether the minimum value exists in the left half or the right half in a single comparison, allowing you to find it in O(log n) time using binary search.

## Thought Process

1. **The minimum value exists at the pivot position**: A rotated sorted array splits into two sorted subsequences: a "larger subsequence" and a "smaller subsequence." The minimum value exists at the head of the "smaller subsequence," which is the pivot position. Finding this pivot is the essence of the problem.
2. **You want to use binary search instead of linear search**: The array is not fully sorted, but it has the structure of being divided into two sorted parts. You can exploit this structure to apply binary search, discarding half the array each iteration.
3. **Compare the middle element with the rightmost element**: If `nums[mid] > nums[right]` holds, a pivot (break in sorted order) exists between mid and right, so the minimum value is in the right half. Conversely, if `nums[mid] <= nums[right]`, the range from mid to right is sorted, so the minimum value is at or to the left of mid (including mid itself).
4. **The reason you compare with the right end instead of the left end**: Comparing with the left end fails when the array has not been rotated (the entire array is sorted). Comparing with the right end correctly narrows down the minimum value's position regardless of whether the array has been rotated.
5. **How to update the search range**: When `nums[mid] > nums[right]`, mid is definitively not the minimum, so you set `left = mid + 1`. Otherwise, mid could be the minimum, so you set `right = mid` (without excluding mid).
6. **Loop termination condition**: The loop continues while `left < right`, and when `left == right`, the search range has narrowed to a single element. That element `nums[left]` is the minimum value.

## Prerequisites

### What a Rotated Sorted Array Is

Rotating the ascending sorted array `[1, 2, 3, 4, 5]` to the right twice produces `[4, 5, 1, 2, 3]`. The array splits into two sorted subsequences `[4, 5]` and `[1, 2, 3]`, and the boundary between them is the pivot.

```
Original array:       [1, 2, 3, 4, 5]
After 2 rotations:    [4, 5, 1, 2, 3]
                            ↑ Pivot (minimum value)
```

### Basic Structure of Binary Search

Binary search is a technique that finds a target element in O(log n) time by halving the search range each iteration. It manages the search range with two pointers, left and right, and updates the range based on the middle element.

```java
int left = 0;
int right = nums.length - 1;
int mid = left + (right - left) / 2;  // Midpoint calculation that prevents overflow
```

### What `left + (right - left) / 2` Means

This expression calculates the middle index. Although `(left + right) / 2` produces the same result, when left and right are large values, their addition may exceed the maximum int value. This expression is a safe way to **prevent that overflow**.

## Complexity

| | Value |
|---|---|
| Time | O(log n) — The search range is halved each iteration, so the minimum is found in at most log n comparisons |
| Space | O(1) — Only three variables (left, right, mid) are used, and no additional data structures are needed |

## Code

```java
// Input: a rotated sorted array of unique integers, nums
// Output: return the minimum value in the array as an int
public int findMin(int[] nums) {
    // Initialize both ends of the search range. These two variables represent the boundaries of the search range
    int left = 0;
    int right = nums.length - 1;

    // When left == right, the search range has narrowed to one element, and that element is the minimum
    while (left < right) {
        // Use this expression instead of (left + right) / 2 to prevent integer overflow
        int mid = left + (right - left) / 2;

        // If the middle element is greater than the rightmost, a pivot (break in sorted order) exists between mid and right
        if (nums[mid] > nums[right]) {
            // The minimum is to the right of mid. Since mid is greater than the rightmost, it cannot be the minimum and can be excluded
            left = mid + 1;
        } else {
            // The range from mid to right is sorted. The minimum is at or to the left of mid (including mid itself)
            // Since mid itself could be the minimum, do not exclude mid from the search range
            right = mid;
        }
    }

    // left == right, so the search range has narrowed to one element, and that element is the minimum
    return nums[left];
}
```
