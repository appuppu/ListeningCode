# Finding the Kth Largest Element in an Array — Find the Kth largest element from an unsorted array

## Problem

You are given an integer array `nums` and an integer `k`. Return the value of the element that would be at the kth position from the largest when the array is sorted in descending order. Duplicate values are counted independently (not the kth largest "distinct value").

## Key Insight

Even without sorting the entire array, you can immediately determine "what rank the pivot holds" by partitioning the array around a pivot. By narrowing the search range to one side until the pivot lands at position `k-1`, you can reach the target element in average O(n) time.

## Thought Process

1. **The kth largest element is determined by its index after sorting**: If you sort the array in descending order, the element at index `k-1` is the answer. However, a full sort costs O(n log n), so we seek a more efficient approach
2. **We only need the element at position k**: We do not need the full ordering — we only need to identify "which element is the kth largest." By using a pivot to partition the array into "elements larger than the pivot" and "elements less than or equal to the pivot," the pivot's index tells us its rank
3. **The pivot's position narrows the search range**: Suppose the partition places the pivot at index `p`. If `p == k-1`, we have found the answer. If `p < k-1`, the target element lies to the right of the pivot (the smaller side), so we narrow the search range to `p+1` onward. If `p > k-1`, we narrow the range to the left side
4. **Partition in descending order**: A standard QuickSort partition operates in ascending order, but to find "the kth largest," we partition in descending order. That is, we gather elements larger than the pivot to the left side. This way, index `k-1` corresponds to the position of the answer
5. **Repeatedly process only one side using a loop**: QuickSort recursively processes both sides, but Quickselect only needs to process the side that contains the answer. Using a while loop, we repeat the partition while `l <= r` and return the element as soon as `p == k-1`

## Prerequisites

### What is Quickselect

Quickselect is an algorithm that uses the same partition operation as QuickSort to find the kth smallest (or largest) element in an array in average O(n) time. While QuickSort recursively processes both sides, Quickselect processes only one side, which reduces the average time complexity to O(n).

### What is partition

Partition is an operation that selects one pivot from the array and moves elements larger than the pivot to the left side and elements less than or equal to the pivot to the right side. After the operation, the pivot is placed in its final correct position. This position (index) represents the pivot's "rank."

```java
// Descending partition: gather elements larger than the pivot to the left side
// Return value: the index where the pivot is placed
int pivot = nums[r];       // Choose the rightmost element as the pivot
int store = l;             // Pointer indicating the next position to swap into
// If nums[i] > pivot, swap nums[i] to the store position and advance store
// Finally, place the pivot at the store position → store is the pivot's final position
```

### What is swap

Swap is an operation that exchanges the positions of two elements in an array. By saving the value in a temporary variable `temp`, it prevents overwriting.

```java
int temp = nums[i];    // Save the value of nums[i] to a temporary variable
nums[i] = nums[store]; // Overwrite nums[i] with the value of nums[store]
nums[store] = temp;    // Write the saved original value of nums[i] into nums[store]
```

## Complexity

| | Value |
|---|---|
| Time | O(n) average — Because the search range is halved on average each time, n + n/2 + n/4 + ... ≈ 2n = O(n) |
| Space | O(1) — The array is manipulated in-place without using any additional data structures |

## Code

```java
// Input: integer array nums and integer k
// Output: return the value of the kth largest element in the array as an int

// Descending partition: gather elements larger than the pivot to the left side and return the pivot's final position
private int partition(int[] nums, int l, int r) {
    // Choose the rightmost element of the search range as the pivot
    int pivot = nums[r];
    // store points to "the next position where an element larger than the pivot should be placed"
    int store = l;

    // Scan from l to r-1 and gather elements larger than the pivot to the left side
    for (int i = l; i < r; i++) {
        // If the current element is larger than the pivot, swap it to the store position to gather it on the left side
        if (nums[i] > pivot) {
            int temp = nums[i];
            nums[i] = nums[store];
            nums[store] = temp;
            // Advance store by 1 to update the next swap destination
            store++;
        }
    }

    // Place the pivot at the store position (the pivot's final correct position)
    // At this point, elements larger than the pivot are to the left of store, and elements less than or equal to the pivot are to the right
    int temp = nums[store];
    nums[store] = nums[r];
    nums[r] = temp;
    // store is the pivot's final position, representing its "rank" in descending order
    return store;
}

public int findKthLargest(int[] nums, int k) {
    // Initialize the left and right boundaries of the search range. Initially, the entire array is the search range
    int l = 0, r = nums.length - 1;

    // The search range narrows with each iteration of the loop
    while (l <= r) {
        // Execute partition on the current search range [l, r] and obtain the pivot's position
        int p = partition(nums, l, r);

        if (p == k - 1) {
            // The pivot is at the kth largest position. In descending order, index k-1 is the position of the kth largest element
            return nums[p];
        } else if (p < k - 1) {
            // The kth largest element is to the right of the pivot (the smaller side)
            l = p + 1;
        } else {
            // The kth largest element is to the left of the pivot (the larger side)
            r = p - 1;
        }
    }
    // Given the problem constraints, a valid k is always provided, so this line is never reached
    return -1;
}
```
