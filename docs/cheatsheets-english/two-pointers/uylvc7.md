# Maximizing Water Held Between Two Lines — Find the Maximum Volume of Water Held by a Container Formed by Two Vertical Lines

## Problem

The system receives a non-negative integer array `height`. Each element `height[i]` represents the height of a vertical line standing at position `i` on the x-axis. The algorithm selects two lines from this array and returns the **maximum amount of water** that a container formed by those two lines and the x-axis can hold. The container's water volume equals "the distance between the two lines × the height of the shorter line."

## Key Insight

The algorithm starts with the maximum width (both ends) and moves the shorter pointer inward. This approach preserves the possibility of improving the area through increased height while efficiently exploring all pairs. The algorithm moves the shorter pointer because, since the width is shrinking, the area cannot improve unless the height increases.

## Thought Process

1. **Organize the area formula**: The area of the container formed by two lines `i` and `j` (i < j) is `(j - i) × min(height[i], height[j])`. To maximize the area, the algorithm needs to maximize the product of "width" and "minimum height"
2. **Start from the maximum width**: To maximize width, the algorithm selects the leftmost line (index 0) and the rightmost line (index n-1). Starting the search from this state allows the algorithm to depart from the maximum possible width
3. **Decide which pointer to move**: Moving a pointer inward always reduces the width by 1. To improve the area, the algorithm must increase the height. The container's height is determined by the shorter of the two lines, so moving the shorter pointer inward gives the algorithm a chance to encounter a taller line. Conversely, moving the taller pointer would not improve the area because the shorter line remains the bottleneck
4. **Record the area at each step**: After moving a pointer, the algorithm calculates the new area and updates the maximum value found so far. This approach yields the same result as an exhaustive search
5. **Determine the termination condition**: When the left pointer and right pointer meet, the algorithm has examined all promising pairs, so the search terminates
6. **Determine the return value**: The algorithm returns `maxarea`, the maximum area recorded during the search

## Prerequisites

### Two Pointers

The two-pointer technique places two pointers (indices) at both ends or at different positions in an array and moves one or both pointers based on conditions during the search. This technique is effective when the algorithm can reduce an O(n²) exhaustive pair search to O(n) by leveraging specific conditions.

```java
int left = 0;                      // Place the left pointer at the start of the array
int right = height.length - 1;     // Place the right pointer at the end of the array
while (left < right) {             // Loop until the two pointers meet
    // Move left or right
    left++;   // Advance the left pointer one position to the right
    right--;  // Advance the right pointer one position to the left
}
```

### Math.min / Math.max

`Math.min(a, b)` returns the smaller of two values, and `Math.max(a, b)` returns the larger. The algorithm uses these methods to determine the container's height (the shorter line) and to update the maximum area.

```java
Math.min(3, 7);          // Returns the smaller of the two → 3
Math.max(10, 25);        // Returns the larger of the two → 25
```

### Calculating the Container Area

The area of the container formed by two lines `left` and `right` equals width × height. The height is determined by the shorter of the two lines.

```java
int width = right - left;                              // Width = the distance between the two lines
int minHeight = Math.min(height[left], height[right]);  // Height = the height of the shorter line
int area = width * minHeight;                           // Area = width × height
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The left and right pointers each advance inward once, scanning the array in a single pass |
| Space | O(1) — The algorithm uses only variables to hold the pointers and the maximum value |

## Code

```java
// Input: a non-negative integer array height (each element represents the height of a vertical line)
// Output: returns an int representing the maximum amount of water a container formed by two lines and the x-axis can hold
public int maxArea(int[] height) {
    // Variable to record the maximum area found during the search. Initialize it to 0
    int maxarea = 0;
    // Place the left pointer at the start of the array. Start the search from the maximum width state
    int left = 0;
    // Place the right pointer at the end of the array
    int right = height.length - 1;

    // Loop until the two pointers meet. When they meet, the algorithm has examined all promising pairs
    while (left < right) {
        // Width = the distance between the two lines
        int width = right - left;
        // Height = the height of the shorter line. The container's water volume is determined by the shorter line
        int minHeight = Math.min(height[left], height[right]);
        // Area = width × height
        int area = width * minHeight;

        // Compare with the maximum value found so far and update it
        maxarea = Math.max(area, maxarea);

        // Move the shorter pointer inward. Since the width is shrinking, the area cannot improve unless the height increases
        // Moving the taller pointer would not improve the area because the shorter line remains the bottleneck
        if (height[left] <= height[right]) {
            // The left line is shorter (or equal), so advance the left pointer one position to the right to seek a height improvement
            left++;
        } else {
            // The right line is shorter, so advance the right pointer one position to the left to seek a height improvement
            right--;
        }
    }
    // Return the maximum area recorded during the search
    return maxarea;
}
```
