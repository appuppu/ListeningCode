# Finding the Kth Largest Element in an Array — Find the Kth Largest Element from an Unsorted Array

## Problem

You are given an integer array `nums` and an integer `k`. Return the value of the kth largest element in the array when the array is sorted in descending order. The algorithm counts duplicate values independently (it does not find the kth largest "distinct" value).

## Key Insight

Even without sorting the entire array, you can determine "how large the pivot ranks" instantly by partitioning the array around a pivot. By narrowing the search range to one side until the pivot lands at position `k-1`, you can reach the target element in O(n) on average.

## Thought Process

1. **The kth largest element corresponds to an index in the sorted array**: If you sort the array in descending order, the element at index `k-1` is the answer. However, a full sort costs O(n log n), so you should consider a more efficient approach
2. **You only need the element at position k**: You do not need the full ordering — you only need to identify "which element is the kth largest." By using a pivot to partition the array into "a group larger than the pivot" and "a group equal to or smaller than the pivot," the pivot's index tells you its rank
3. **The pivot's position narrows the search range**: Suppose the partition places the pivot at index `p`. If `p == k-1`, you have found the answer. If `p < k-1`, the target element lies to the right of the pivot (the smaller side), so you narrow the search range to `p+1` onward. If `p > k-1`, you narrow the range to the left side
4. **Partition in descending order**: A standard QuickSort partition works in ascending order, but to find "the kth largest," you partition in descending order. This means you gather elements larger than the pivot on the left side. This way, index `k-1` corresponds to the position of the answer
5. **Repeatedly process only one side using a loop**: QuickSort recursively processes both sides, but Quickselect only needs to process the side that contains the answer. A while loop repeats the partition while `l <= r` and returns the element once `p == k-1`

## Prerequisites

### What Is Quickselect

Quickselect is an algorithm that uses the same partition operation as QuickSort to find the kth smallest (or largest) element in an array in O(n) on average. While QuickSort recursively processes both sides, Quickselect processes only one side, which results in an average time complexity of O(n).

### What Is Partition

Partition is an operation that selects one pivot from the array and moves elements larger than the pivot to the left side and elements equal to or smaller than the pivot to the right side. After the operation, the pivot is placed at its final correct position. This position (index) represents the pivot's "rank."

```java
// Descending partition: gather elements larger than the pivot on the left side
// Return value: the index where the pivot is placed
int pivot = nums[r];       // Choose the rightmost element as the pivot
int store = l;             // Pointer indicating the next position to swap into
// If nums[i] > pivot, swap nums[i] to the store position and advance store
// Finally, place the pivot at the store position → store becomes the pivot's final position
```

### What Is Swap

Swap is an operation that exchanges the positions of two elements in an array. It uses a temporary variable `temp` to save a value and prevent it from being overwritten.

```java
int temp = nums[i];    // Save the value of nums[i] to a temporary variable
nums[i] = nums[store]; // Overwrite nums[i] with the value of nums[store]
nums[store] = temp;    // Write the saved original value of nums[i] into nums[store]
```

## Complexity

| | Value |
|---|---|
| Time | O(n) average — Because the search range shrinks by half on average each time, n + n/2 + n/4 + ... ≈ 2n = O(n) |
| Space | O(1) — The algorithm operates on the array in-place and uses no additional data structures |

## Code

```java
// Input: an integer array nums and an integer k
// Output: return the value of the kth largest element in the array as an int

// Descending partition: gather elements larger than the pivot on the left side and return the pivot's final position
private int partition(int[] nums, int l, int r) {
    // Choose the rightmost element of the search range as the pivot
    int pivot = nums[r];
    // store points to "the next position where an element larger than the pivot should be placed"
    int store = l;

    // Scan from l to r-1 and gather elements larger than the pivot on the left side
    for (int i = l; i < r; i++) {
        // If the current element is larger than the pivot, swap it to the store position to gather it on the left
        if (nums[i] > pivot) {
            int temp = nums[i];
            nums[i] = nums[store];
            nums[store] = temp;
            // Advance store to update the placement position for the next larger element
            store++;
        }
    }

    // Place the pivot at the store position (the pivot's final correct position)
    // At this point, elements to the left of store are larger than the pivot, and elements to the right are equal to or smaller
    int temp = nums[store];
    nums[store] = nums[r];
    nums[r] = temp;
    // store is the pivot's final position = the pivot's "rank in descending order"
    return store;
}

public int findKthLargest(int[] nums, int k) {
    // Initialize the search range to the entire array
    int l = 0, r = nums.length - 1;

    // Repeat partition while the search range is valid. The search range narrows with each iteration
    while (l <= r) {
        // Execute partition on the current search range and obtain the pivot's position
        int p = partition(nums, l, r);

        if (p == k - 1) {
            // The pivot is at the kth largest position, so return the answer
            // In descending order, index k-1 counted from the left is the position of the kth largest element
            return nums[p];
        } else if (p < k - 1) {
            // The kth element is to the right of the pivot (the smaller side), so narrow the left bound of the search range
            l = p + 1;
        } else {
            // The kth element is to the left of the pivot (the larger side), so narrow the right bound of the search range
            r = p - 1;
        }
    }
    // Given the problem constraints, a valid k is always provided, so this line is never reached
    return -1;
}
```
