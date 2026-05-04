# Rotating a Matrix 90 Degrees — Rotate an n×n matrix 90 degrees clockwise without additional memory

## Problem

An n×n square matrix is given. The task is to rotate this matrix 90 degrees clockwise. The transformation must be performed **in-place** without allocating a new matrix. After rotation, each element `matrix[i][j]` moves to position `matrix[j][n-1-i]`.

## Key Insight

A 90-degree rotation can be decomposed into two simple operations: "transpose (swap rows and columns)" + "reverse each row horizontally." This decomposition allows each element to move to its correct position without additional memory.

## Thought Process

1. **Observe the destination of each element after rotation**: An element `matrix[i][j]` moves to `matrix[j][n-1-i]` in a 90-degree clockwise rotation. Performing this transformation one element at a time requires a 4-element cyclic swap, which becomes complex
2. **Consider whether the rotation can be decomposed into known operations**: The transpose operation moves `matrix[i][j]` to `matrix[j][i]`. After transposing, reversing each row moves `matrix[j][i]` to `matrix[j][n-1-i]`. This matches the original 90-degree rotation mapping of `matrix[i][j]` → `matrix[j][n-1-i]`
3. **Implement the transpose in-place**: Swap elements across the diagonal (`i == j`) between the upper and lower triangles. Iterating over the range `j > i` and swapping `matrix[i][j]` with `matrix[j][i]` ensures each pair is swapped exactly once
4. **Implement row reversal in-place**: For each row, set up a left pointer and a right pointer and swap elements while moving both pointers toward the center. This operation requires no additional memory
5. **Apply the two operations in sequence**: First transpose the entire matrix, then reverse each row. Since both operations are performed in-place, the entire 90-degree rotation completes with O(1) additional memory

## Prerequisites

### Transpose

A transpose is an operation that swaps the rows and columns of a matrix. It exchanges the positions of elements `matrix[i][j]` and `matrix[j][i]`. For a square matrix, elements on the diagonal remain unchanged, and the operation swaps elements at symmetric positions across the diagonal.

```java
// Example of transposing a 3×3 matrix
// Before transpose:    After transpose:
// [1, 2, 3]           [1, 4, 7]
// [4, 5, 6]  →        [2, 5, 8]
// [7, 8, 9]           [3, 6, 9]

// matrix[0][1]=2 and matrix[1][0]=4 are swapped
int temp = matrix[i][j];
matrix[i][j] = matrix[j][i];
matrix[j][i] = temp;
```

### Array Reversal

Array reversal is an operation that symmetrically swaps elements from left to right. Two pointers advance from the left end and right end toward the center, swapping elements as they go.

```java
// [1, 4, 7] → [7, 4, 1]
int left = 0, right = n - 1;
while (left < right) {
    int temp = array[left];
    array[left] = array[right];
    array[right] = temp;
    left++;
    right--;
}
```

### In-Place Operation

An in-place operation directly modifies the input data without allocating a new data structure. Using temporary variables (`temp`) is acceptable since they require only O(1) space. The problem instructs "do not allocate a new matrix," so the solution must be performed in-place.

## Complexity

| | Value |
|---|---|
| Time | O(n²) — The transpose performs n²/2 swaps, and the reversal performs n²/2 swaps |
| Space | O(1) — Only temporary variables are used; no new matrix is allocated |

## Code

```java
// Input: an n×n integer matrix (2D array int[][]). Since it is a square matrix, the number of rows equals the number of columns
// Output: void. The method modifies the input matrix itself to be rotated 90 degrees clockwise
public void rotate(int[][] matrix) {
    // Get the matrix size n using matrix.length
    int n = matrix.length;

    // Step 1: Transpose (swap elements across the diagonal to exchange rows and columns)
    for (int i = 0; i < n; i++) {
        // j starts from i+1 because: elements on the diagonal (i==j) need no swap, and the range j<i has already been swapped
        for (int j = i + 1; j < n; j++) {
            // Swap matrix[i][j] and matrix[j][i] using a temporary variable to exchange rows and columns
            int temp = matrix[i][j];
            matrix[i][j] = matrix[j][i];
            matrix[j][i] = temp;
        }
    }

    // Step 2: Reverse each row horizontally
    for (int i = 0; i < n; i++) {
        // Set up two pointers at the left end and right end, and swap elements while moving toward the center
        int left = 0, right = n - 1;
        while (left < right) {
            // Swap matrix[i][left] and matrix[i][right] to reverse the row horizontally
            int temp = matrix[i][left];
            matrix[i][left] = matrix[i][right];
            matrix[i][right] = temp;
            left++;
            right--;
        }
    }
    // At this point, after all rows have been reversed, the entire matrix is in its 90-degree clockwise rotated state
}
```
