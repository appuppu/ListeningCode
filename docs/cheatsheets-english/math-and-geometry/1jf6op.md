# Traversing a Matrix in Spiral Order — Retrieve All Elements of a Matrix in Spiral Order

## Problem

You are given an m×n matrix `matrix`. Starting from the top-left corner, you trace the outer edges in the order right → down → left → up, then repeat inward to collect all elements in **spiral order** and return them as an array.

## Key Insight

You treat each outer ring of the matrix as a single "layer" and traverse its four sides — top, right, bottom, left — in sequence. After completing one layer, you shrink the four boundary pointers inward, which naturally transitions the traversal to the next inner layer.

## Thought Process

1. **Spiral traversal is a repetition of four directions**: The structure repeats right → down → left → up from the outer layer inward, so managing the current traversal range with "top, bottom, left, right" boundaries uniquely determines the range for each direction.
2. **Four boundary pointers represent the traversal range**: You prepare four variables: `top` (top row), `bottom` (bottom row), `left` (leftmost column), and `right` (rightmost column). These indicate the positions of the four sides of the current layer.
3. **You determine the traversal order for each side**: The top side goes left to right (incrementing columns), the right side goes top to bottom (incrementing rows), the bottom side goes right to left (decrementing columns), and the left side goes bottom to top (decrementing rows). These four for-loops complete the traversal of one layer.
4. **You shrink the boundary after traversing each side**: After traversing the top side, you execute `top++` (move the top boundary one row down). After the right side, `right--` (move the right boundary one column left). After the bottom side, `bottom--`. After the left side, `left++`. This ensures the next loop iteration traverses one layer further inward.
5. **The bottom and left side traversals require additional conditions**: Because `top` increases after the top-side traversal and `right` decreases after the right-side traversal, the condition `top <= bottom` may no longer hold when traversing the bottom side. Similarly, `left <= right` may no longer hold when traversing the left side. Without these checks, the algorithm would read already-traversed rows or columns a second time.
6. **The termination condition is the crossing of boundaries**: Once `top > bottom` or `left > right`, the traversal of all layers is complete. Setting the while-loop condition to `top <= bottom && left <= right` ensures natural termination.

## Prerequisites

### What Is an ArrayList

An ArrayList is a dynamically sized array. The `add` method appends an element to the end in O(1) time. You use it to build the resulting spiral-order array.

```java
List<Integer> res = new ArrayList<>();  // Create an empty ArrayList
res.add(5);                             // Append 5 to the end → [5]
res.add(3);                             // Append 3 to the end → [5, 3]
res.size();                             // Return the number of elements → 2
```

### What Are Boundary Pointers

Boundary pointers are four integer variables that define the traversal range of the matrix. `top` and `bottom` represent the row range, while `left` and `right` represent the column range. You modify these values after each traversal to shrink the range inward.

```java
int top = 0;                    // Row index of the top boundary (initial value: 0)
int bottom = matrix.length - 1; // Row index of the bottom boundary (initial value: last row)
int left = 0;                   // Column index of the left boundary (initial value: 0)
int right = matrix[0].length - 1; // Column index of the right boundary (initial value: last column)
top++;    // Shrink the top boundary one row down
right--;  // Shrink the right boundary one column to the left
```

## Complexity

| | Value |
|---|---|
| Time | O(m × n) — The algorithm traverses every element of the matrix exactly once |
| Space | O(1) — Excluding the output list, the algorithm uses only four boundary pointers |

## Code

```java
// Input: an m×n integer matrix
// Output: a List<Integer> containing all elements in spiral order
List<Integer> spiralOrder(int[][] matrix) {
    // Create a dynamically sized list to store the result
    List<Integer> res = new ArrayList<>();
    // If the matrix is empty (zero rows), return the empty list immediately
    if (matrix.length == 0) return res;

    // Initialize four boundary pointers that represent the four sides of the current layer
    int top = 0;                      // Top boundary row (topmost row)
    int bottom = matrix.length - 1;   // Bottom boundary row (bottommost row)
    int left = 0;                     // Left boundary column (leftmost column)
    int right = matrix[0].length - 1; // Right boundary column (rightmost column)

    // Repeat layer by layer while a valid traversal range exists. Traversal is complete when the boundaries cross
    while (top <= bottom && left <= right) {
        // Top side: traverse from left to right
        for (int c = left; c <= right; c++)
            res.add(matrix[top][c]);
        // Top side traversal is complete. Shrink the top boundary one row down to avoid reading corner elements twice during the right side traversal
        top++;

        // Right side: traverse from top to bottom (top is already updated, so no corner duplication occurs)
        for (int r = top; r <= bottom; r++)
            res.add(matrix[r][right]);
        // Right side traversal is complete. Shrink the right boundary one column to the left
        right--;

        // Bottom side: traverse from right to left
        // Condition check: if top++ caused top > bottom (only one row remained),
        // the bottom side is the same row as the top side and has already been traversed, so skip it
        if (top <= bottom) {
            for (int c = right; c >= left; c--)
                res.add(matrix[bottom][c]);
            // Shrink the bottom boundary one row up
            bottom--;
        }

        // Left side: traverse from bottom to top
        // Condition check: if right-- caused left > right (only one column remained),
        // the left side is the same column as the right side and has already been traversed, so skip it
        if (left <= right) {
            for (int r = bottom; r >= top; r--)
                res.add(matrix[r][left]);
            // Shrink the left boundary one column to the right
            left++;
        }
    }
    // Return the list containing all m×n elements in spiral order
    return res;
}
```
