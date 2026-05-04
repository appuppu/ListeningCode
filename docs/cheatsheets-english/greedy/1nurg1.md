# Finding the Subarray With Maximum Sum

## Problem

You are given an integer array `nums`. The array may contain both positive and negative numbers. You need to find the contiguous subarray whose sum of elements is the maximum, and return that **sum**.

## Key Insight

When you reach each element, you have only two choices: "extend the current subarray" or "start a new subarray from this element." If the running sum so far is negative, discarding it and starting fresh is always more beneficial than carrying it forward.

## Thought Process

1. **You have only two choices at each element**: When you reach element `nums[i]`, you can either "append `nums[i]` to the previous subarray to extend it" or "start a new subarray beginning with `nums[i]`." Due to the contiguous subarray constraint, you cannot skip elements in between.
2. **The criterion for extending versus starting fresh**: If the running sum `currentSum` up to the previous element is positive, adding it to `nums[i]` produces a value larger than `nums[i]` alone, so you extend. If `currentSum` is negative, adding it makes the result smaller than `nums[i]` alone, so you discard it and start fresh. In other words, you choose the larger of `currentSum + nums[i]` and `nums[i]`.
3. **You express this decision using `Math.max`**: The single line `currentSum = Math.max(currentSum + nums[i], nums[i])` completes the decision between extending and starting fresh. `currentSum + nums[i]` corresponds to extending, and `nums[i]` corresponds to starting a new subarray.
4. **You track the overall maximum separately**: `currentSum` represents "the sum of the current subarray," and its value fluctuates during the scan. Since the problem asks for "the maximum sum across the entire array," you use a separate variable `maxSum` to continuously record the highest `currentSum` encountered during the scan.
5. **You initialize `maxSum` to `Integer.MIN_VALUE`**: To ensure correct behavior even when all elements in the array are negative, you initialize `maxSum` to the minimum integer value. If you initialize it to 0, you would incorrectly determine that "an empty subarray (sum of 0)" is the maximum when all elements are negative.
6. **You return `maxSum` at the end**: When the array scan is complete, `maxSum` contains the maximum sum among all contiguous subarrays. You return this value.

## Prerequisites

### What Math.max Is

`Math.max` is a standard Java method that takes two values and returns the larger one. It expresses a conditional branch in a single line.

```java
Math.max(5, 3);       // Returns the larger of the two values → 5
Math.max(-2, -7);     // Returns the larger even among negative numbers → -2
Math.max(a + b, b);   // Can also compare the results of expressions
```

### What Integer.MIN_VALUE Is

`Integer.MIN_VALUE` is a constant representing the minimum value of Java's `int` type (-2,147,483,648). You use it as an initial value for a "nothing has been compared yet" state. When compared with any integer using `Math.max`, the other value is always selected.

```java
int maxSum = Integer.MIN_VALUE;   // Initialize with the minimum int value
maxSum = Math.max(maxSum, -5);    // Any value is larger than maxSum → -5
```

### What a Contiguous Subarray Is

A contiguous subarray is a portion of an array consisting of adjacent elements taken without any gaps. You cannot skip elements when selecting them.
Example: When `nums = [-2, 1, -3, 4, -1, 2]`, `[4, -1, 2]` is a contiguous subarray (sum is 5). `[1, 4, 2]` is not a contiguous subarray because the elements are not adjacent.

## Complexity

| | Value |
|---|---|
| Time | O(n) — You only need to scan the array once |
| Space | O(1) — You use only two variables: `maxSum` and `currentSum` |

## Code

```java
// Input: an integer array nums that may contain positive and negative numbers
// Output: return the maximum sum of a contiguous subarray as an int
public int maxSubArray(int[] nums) {
    // Variable that records the maximum subarray sum encountered throughout the scan
    // Initialize with Integer.MIN_VALUE so that the correct maximum is selected even when all elements are negative
    // Note: initializing with 0 would incorrectly determine "an empty subarray (sum of 0)" as the maximum when all elements are negative
    int maxSum = Integer.MIN_VALUE;
    // Variable that holds the sum of the subarray currently being built. It is 0 at the start of the scan because no elements are included yet
    int currentSum = 0;

    // Scan the array one element at a time from the beginning to the end
    for (int num : nums) {
        // currentSum + num is "the sum if you extend the previous subarray"
        // num is "the sum if you start a new subarray from this element"
        // By choosing the larger value, you always make the optimal decision
        currentSum = Math.max(currentSum + num, num);
        // If the current subarray sum exceeds the previous maximum, update it; otherwise, keep the previous maximum
        maxSum = Math.max(maxSum, currentSum);
    }
    // When the scan is complete, maxSum contains the maximum sum among all contiguous subarrays
    return maxSum;
}
```
