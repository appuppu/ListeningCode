# Finding the K Closest Points to the Origin

## Problem

You are given an array of points `points` on a 2D plane and an integer `k`. Return the `k` points that are closest to the origin (0, 0) by Euclidean distance. You may return the answer in any order.

## Key Insight

Finding the "k closest points" does not require a full sort. The Quickselect algorithm partitions the array around a pivot and finds the k-th boundary, which gathers the k nearest points on the left side.

## Thought Process

1. **A full sort is excessive**: You only need to return the k closest points, and order does not matter. This means you only need to partition the array into "the closest k" and "the rest." A full sort costs O(n log n), but partitioning alone can be done faster.
2. **Quickselect finds the partition boundary**: By using Quicksort's partition operation, elements smaller than the pivot gather on the left and larger elements gather on the right. If the pivot's final position is exactly k-1, the k elements on the left are the answer.
3. **Simplify the distance calculation**: The Euclidean distance is `√(x² + y²)`, but when you only need to compare magnitudes, the square root is unnecessary — comparing `x² + y²` is sufficient. This avoids floating-point arithmetic.
4. **How the partition operation works**: Choose the rightmost element as the pivot and use `storeIdx` to track "the next position to place an element less than or equal to the pivot." During the scan, when you find an element less than or equal to the pivot, swap it with the element at `storeIdx` and increment `storeIdx`.
5. **Narrow the search range based on the pivot's final position**: After partitioning, the pivot sits at position `storeIdx`. If this position is less than `k-1`, there are not enough elements on the left side, so you search the right half. If it is `k-1` or greater, you search the left half. This repetition completes the partitioning in O(n) on average.
6. **Return the first k elements**: When the loop finishes, the first k elements of the array are the k nearest points, so you extract them with `Arrays.copyOfRange(points, 0, k)`.

## Prerequisites

### What Is Quickselect

Quickselect is an algorithm that finds the k-th smallest element in an array in O(n) on average. It recursively applies Quicksort's partition operation to only one side, which determines the target position without performing a full sort.

```java
// Basic structure of the partition operation
int pivotValue = arr[right];       // Choose the rightmost element as the pivot
int storeIdx = left;               // Position to place elements less than or equal to the pivot
for (int i = left; i < right; i++) {
    if (arr[i] <= pivotValue) {    // Gather elements less than or equal to the pivot on the left
        swap(arr, i, storeIdx);
        storeIdx++;
    }
}
swap(arr, storeIdx, right);        // Place the pivot in its correct position
// storeIdx is the pivot's final position
```

### Squared Euclidean Distance

The distance from the origin is `√(x² + y²)`, but when you only need to compare magnitudes, you can omit the square root and compare using `x² + y²`. Because the square root function is monotonically increasing, the ordering of distances is preserved by the ordering of squared distances.

```java
private int dist(int[] point) {
    return point[0] * point[0] + point[1] * point[1];  // x² + y²
}
```

### What Is Arrays.copyOfRange

`Arrays.copyOfRange` is a Java utility method that copies a specified range of an array and returns it as a new array.

```java
int[][] result = Arrays.copyOfRange(points, 0, k);  // Copy k elements from index 0 to k-1
```

## Complexity

| | Value |
|---|---|
| Time | O(n) average — Because the partition is applied to only one side, the comparisons converge on average to n + n/2 + n/4 + ... = 2n |
| Space | O(1) — The input array is rearranged in-place, so no additional memory is used |

## Code

```java
// Input: an array of 2D coordinates points (each element is [x, y]) and an integer k
// Output: return an int[][] containing the k points closest to the origin

// Return the squared Euclidean distance from the origin (the square root is omitted because it is unnecessary for comparison)
private int dist(int[] p) {
    return p[0] * p[0] + p[1] * p[1];
}

public int[][] kClosest(int[][] points, int k) {
    // Initialize the left and right bounds of the search range. Repeatedly partition within this range so that the first k elements become the k nearest points
    int left = 0;
    int right = points.length - 1;

    // Repeatedly partition until the first k elements are the k nearest points
    while (left < right) {
        // Choose the rightmost point as the pivot and compute its squared Euclidean distance (x² + y²)
        int pivotDist = dist(points[right]);
        // storeIdx tracks the next position to place a point whose distance is less than or equal to the pivot
        int storeIdx = left;

        // Compare each point's distance to the pivot and gather points with distance less than or equal to the pivot on the left side
        for (int i = left; i < right; i++) {
            if (dist(points[i]) <= pivotDist) {
                // Distance is less than or equal to the pivot, so swap to the storeIdx position to gather it on the left
                int[] temp = points[i];
                points[i] = points[storeIdx];
                points[storeIdx] = temp;
                storeIdx++;
            }
        }

        // Place the pivot at its correct final position storeIdx. Points with distance less than or equal to the pivot are on the left, and points with greater distance are on the right
        int[] temp = points[storeIdx];
        points[storeIdx] = points[right];
        points[right] = temp;

        // Compare the pivot's final position with k-1 to halve the search range
        if (storeIdx < k - 1) {
            // There are fewer than k elements on the left side, so search the right side
            left = storeIdx + 1;
        } else {
            // Note: when storeIdx is exactly k-1, shrinking right causes the loop condition left < right to become false, which terminates the loop
            right = storeIdx - 1;
        }
    }

    // After the loop ends, the first k elements of the array are the k points closest to the origin
    return Arrays.copyOfRange(points, 0, k);
}
```
