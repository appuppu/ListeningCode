# Calculating Trapped Rainwater Between Bars

## Problem

The system receives an array `height` of non-negative integers. Each element represents the height of a bar with width 1, forming an elevation map. The function calculates and returns the **total amount of water** trapped between the bars after rainfall.

## Key Insight

The amount of water trapped at a given position is determined by subtracting the bar's height at that position from the smaller of the maximum height on the left side and the maximum height on the right side. By moving two pointers inward from both ends while updating the maximum height on each side, the algorithm can calculate the water volume at each position without using any additional arrays.

## Thought Process

1. **The water volume at each position depends on the maximum heights on both sides**: The amount of water trapped at position `i` is `min(max height on left, max height on right) - height[i]`. Water can only accumulate up to the height of the shorter wall between the left and right sides
2. **The algorithm needs to compute the left and right maximum heights efficiently**: Scanning for the left and right maximum heights at every position costs O(n²). Precomputing them with two arrays achieves O(n) but requires O(n) space. The goal is to find an approach that uses O(1) space
3. **Two pointers move inward from both ends**: The algorithm places a pointer `left` at the left end and a pointer `right` at the right end, then moves them inward. Two variables `maxLeftHeight` and `maxRightHeight` track the maximum height seen so far on each pointer's side
4. **The algorithm moves the pointer on the smaller side**: When `height[left] <= height[right]`, the maximum height on the left side is guaranteed to be less than or equal to the maximum height on the right side. This guarantee holds because a wall at least as tall as `height[right]` exists on the right side. Therefore, the algorithm can determine the water volume at the left pointer's position using only `maxLeftHeight`
5. **The algorithm adds the water volume after moving the pointer**: The algorithm advances the pointer by one position, updates the maximum height at that new position, and adds `maxLeftHeight - height[left]` (or `maxRightHeight - height[right]`) to the total water volume. Because the maximum height is always greater than or equal to the current bar's height, this difference is always non-negative
6. **The loop terminates when the two pointers meet**: The loop continues while `left < right`, and the function returns `totalwater`, which contains the sum of water volumes across all positions

## Prerequisites

### Two Pointers

The two pointers technique places two pointers at both ends or different positions of an array and moves one of them based on a condition during traversal. This technique can process the entire array in a single pass and is effective for sorted arrays or searches from both ends.

```java
int left = 0;                    // Left pointer
int right = height.length - 1;   // Right pointer
while (left < right) {           // Loop until the two pointers meet
    // Move the pointer inward with left++ or right-- based on the condition
}
```

### Math.max

`Math.max` is a static method in Java that returns the larger of two values. In this algorithm, it updates the maximum height seen so far each time the pointer advances.

```java
int maxHeight = 3;
maxHeight = Math.max(maxHeight, 5);  // maxHeight updates to 5
maxHeight = Math.max(maxHeight, 2);  // maxHeight stays 5 (because 2 < 5)
```

### Condition for Water Accumulation

For water to accumulate at a given position, both sides of that position must have walls taller than the current bar. The amount of trapped water equals the height of the shorter wall on either side minus the height of the current bar.

```
// height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]
// Position 2 (height 0): left max = 1, right max = 3 → min(1,3) - 0 = 1 unit of water trapped
// Position 5 (height 0): left max = 2, right max = 3 → min(2,3) - 0 = 2 units of water trapped
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The left and right pointers move a total of n times to traverse the array once |
| Space | O(1) — The algorithm uses only pointer and maximum height variables without any additional arrays |

## Code

```java
// Input: an array height of non-negative integers (each element represents a bar's height)
// Output: the total amount of water trapped between the bars, returned as an int
public int trap(int[] height) {
    // Initialize the variable that holds the total trapped water to 0
    int totalwater = 0;

    // Set the left pointer to the start of the array and the right pointer to the end
    int left = 0;
    int right = height.length - 1;

    // Initialize the maximum heights seen so far on each side
    // The bars at both ends cannot trap water themselves, so they serve as initial values
    int maxLeftHeight = height[left];
    int maxRightHeight = height[right];

    // Loop until the two pointers meet
    while (left < right) {
        // When height[left] <= height[right], a wall at least as tall as height[right] exists on the right side
        // Therefore, the algorithm can determine the water volume using only the left maximum height
        if (height[left] <= height[right]) {
            // Advance the pointer one position to the right, then calculate the water volume
            left++;
            // Update the left maximum height seen so far
            maxLeftHeight = Math.max(maxLeftHeight, height[left]);
            // Because maxLeftHeight is always >= height[left], the added value is always non-negative
            totalwater += maxLeftHeight - height[left];
        } else {
            // When height[left] > height[right], a wall at least as tall as height[left] exists on the left side
            // Therefore, the algorithm can determine the water volume using only the right maximum height
            right--;
            // Update the right maximum height seen so far
            maxRightHeight = Math.max(maxRightHeight, height[right]);
            // Because maxRightHeight is always >= height[right], the added value is always non-negative
            totalwater += maxRightHeight - height[right];
        }
    }
    // After the loop ends, return totalwater which contains the summed water volume across all positions
    return totalwater;
}
```
