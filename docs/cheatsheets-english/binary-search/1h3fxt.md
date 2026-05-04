# Searching for a Value in a Sorted Matrix

## Problem

You are given an m×n matrix where each row is sorted in ascending order and the first element of each row is greater than the last element of the previous row. You must determine whether a given `target` exists in the matrix and return a `boolean`.

## Key Insight

If you lay out the entire matrix from the top-left to the bottom-right into a single sequence, it forms one sorted array. By converting a 1D index `mid` to matrix coordinates `[mid / n][mid % n]`, you can perform a single binary search in O(log(m * n)) without actually flattening the matrix.

## Thought Process

1. **The entire matrix forms one sorted array**: Because each row is sorted in ascending order and the first element of the next row is greater than the last element of the previous row, reading the elements from top-left to bottom-right produces a single sorted array in ascending order.
2. **You can apply binary search to a sorted array**: The total number of elements is `m * n`, so you perform binary search over the range from 0 to `m * n - 1`. Set the lower bound `lo = 0` and the upper bound `hi = m * n - 1`.
3. **You need to convert a 1D index to 2D coordinates**: The midpoint `mid` in binary search is a 1D index. To retrieve a value from the matrix, you need 2D coordinates, so you compute the row index as `mid / n` (quotient of dividing by the number of columns) and the column index as `mid % n` (remainder of dividing by the number of columns).
4. **You apply standard binary search logic**: If the value at `matrix[mid / n][mid % n]` equals `target`, you return `true`. If the value is smaller, you narrow the search range to the right half by setting `lo = mid + 1`. If the value is larger, you narrow the search range to the left half by setting `hi = mid - 1`.
5. **If the search range is exhausted, the target does not exist**: If no match is found before `lo > hi`, the `target` does not exist in the matrix, so you return `false`.

## Prerequisites

### Binary Search

Binary search is an algorithm that finds a target value efficiently in a sorted array by halving the search range at each step. It requires at most log₂(n) comparisons for n elements.

```java
int lo = 0, hi = array.length - 1;  // Set the lower and upper bounds of the search range
while (lo <= hi) {                    // Loop while the search range exists
    int mid = lo + (hi - lo) / 2;    // Calculate the midpoint while preventing overflow
    if (array[mid] == target)         // Check if the midpoint value matches the target
        return true;
    else if (array[mid] < target)
        lo = mid + 1;                // The target is in the right half, so raise the lower bound
    else
        hi = mid - 1;                // The target is in the left half, so lower the upper bound
}
return false;                         // The target was not found
```

### Converting Between a 1D Index and 2D Coordinates

In a matrix with `n` columns, you convert a 1D index `idx` to 2D coordinates using division and modulo. This conversion allows you to treat the matrix as a virtual 1D array.

```java
int n = matrix[0].length;        // Get the number of columns
int row = idx / n;               // The quotient gives the row index (e.g., idx=7, n=4 → row=1)
int col = idx % n;               // The remainder gives the column index (e.g., idx=7, n=4 → col=3)
int val = matrix[row][col];      // Retrieve the matrix value using the 2D coordinates
```

## Complexity

| | Value |
|---|---|
| Time | O(log(m * n)) — Perform one binary search over all m * n elements |
| Space | O(1) — Use only pointer variables with no additional data structures |

## Code

```java
// Input: an m×n integer matrix and an integer target
// Output: return true if the target exists in the matrix, false otherwise
public boolean searchMatrix(int[][] matrix, int target) {
    // Get the number of rows and columns; used to compute total elements and for 1D-to-2D conversion
    int m = matrix.length;
    int n = matrix[0].length;

    // Set the binary search range to cover the entire matrix
    // lo=0 corresponds to the top-left, hi=m*n-1 corresponds to the bottom-right
    int lo = 0, hi = m * n - 1;

    // When lo > hi, the search range is exhausted and the target does not exist
    while (lo <= hi) {
        // Use this form instead of (lo + hi) / 2 to prevent integer overflow of lo + hi
        int mid = lo + (hi - lo) / 2;

        // Convert the 1D index to 2D coordinates and retrieve the value
        // Row index = mid / n (quotient), Column index = mid % n (remainder)
        int val = matrix[mid / n][mid % n];

        if (val == target)
            return true;           // The target was found, so return true
        else if (val < target)
            lo = mid + 1;          // The target is in the right half (larger side), so raise the lower bound
        else
            hi = mid - 1;          // The target is in the left half (smaller side), so lower the upper bound
    }

    // The loop ended without returning true, so the target does not exist in the matrix
    return false;
}
```
