# Inserting a New Interval Into a Sorted List — Insert a new interval into a sorted list of non-overlapping intervals and merge overlaps

## Problem

You are given a sorted list of non-overlapping intervals `intervals` and a new interval `newInterval`. Insert `newInterval` at the correct position, merge all overlapping intervals, and return the resulting list of non-overlapping intervals.

## Key Insight

When you scan a sorted interval list from left to right, each interval falls into one of three groups: "completely before the new interval," "overlapping with the new interval," or "completely after the new interval." Processing these three phases sequentially completes the insertion and merging in a single pass.

## Thought Process

1. **There are only 3 positional relationships between intervals**: Each interval in the sorted list can be classified as "completely before," "overlapping with," or "completely after" newInterval. By leveraging this classification, you can process the list in a single scan.
2. **Condition for "completely before"**: If the end of an existing interval `intervals[i][1]` is less than the start of newInterval `newInterval[0]`, that interval does not overlap with newInterval. Add intervals satisfying this condition directly to the result.
3. **Condition for "overlapping"**: If the start of an existing interval `intervals[i][0]` is less than or equal to the end of newInterval `newInterval[1]`, that interval overlaps with newInterval. Each time you find an overlapping interval, update the start and end of newInterval to expand the merged range.
4. **How to merge**: Take the smaller of the overlapping interval's start and newInterval's start as the new start, and the larger of the overlapping interval's end and newInterval's end as the new end. This consolidates multiple overlapping intervals into a single interval.
5. **When to add the merged result**: Once there are no more overlapping intervals, add the merged newInterval to the result. All subsequent intervals are completely after newInterval, so add them directly to the result.
6. **What to return**: Convert the result list built across the 3 phases into an `int[][]` and return it.

## Prerequisites

### ArrayList

ArrayList is a dynamically-sized array. You can append elements with `add()` in O(1) amortized time and convert it to a fixed-size array at the end. Use it when the result size is not known in advance.

```java
List<int[]> res = new ArrayList<>();   // Create an empty ArrayList
res.add(new int[]{1, 3});              // Append an element to the end
res.toArray(new int[0][]);             // Convert to an int[][] array
```

### Math.min / Math.max

These methods return the smaller or larger of two values. Use them to determine the start and end when merging intervals.

```java
Math.min(1, 3);   // → 1 (returns the smaller value)
Math.max(1, 3);   // → 3 (returns the larger value)
```

### Interval Overlap Detection

You can determine whether two intervals `[a, b]` and `[c, d]` overlap by checking `a <= d && c <= b`. In this problem, since the list is sorted, checking only one of these conditions is sufficient.

```java
// The existing interval is completely before newInterval (no overlap)
intervals[i][1] < newInterval[0]   // existing interval's end < new interval's start

// The existing interval overlaps with newInterval
intervals[i][0] <= newInterval[1]  // existing interval's start <= new interval's end
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — Only a single pass through the interval list is needed |
| Space | O(n) — The result list stores at most n+1 intervals |

## Code

```java
// Input: a sorted list of non-overlapping intervals (int[][]) and a new interval newInterval (int[])
// Output: return the non-overlapping interval list (int[][]) after inserting and merging newInterval
public int[][] insert(int[][] intervals, int[] newInterval) {
    // List to store the result. Use ArrayList because the size is not known in advance
    List<int[]> res = new ArrayList<>();
    // Variable to track the current scan position
    int i = 0;
    // Store the total number of intervals to avoid referencing .length in every loop condition
    int n = intervals.length;

    // Phase 1: Add intervals that are completely before newInterval as-is
    // Condition: if existing interval's end < newInterval's start, there is no overlap
    while (i < n && intervals[i][1] < newInterval[0]) {
        res.add(intervals[i]);
        i++;
    }

    // Phase 2: Merge all intervals that overlap with newInterval
    // Condition: if existing interval's start <= newInterval's end, there is overlap
    while (i < n && intervals[i][0] <= newInterval[1]) {
        // Take the smaller start (expand newInterval's left edge to the overlapping interval's left edge)
        newInterval[0] = Math.min(newInterval[0], intervals[i][0]);
        // Take the larger end (expand newInterval's right edge to the overlapping interval's right edge)
        newInterval[1] = Math.max(newInterval[1], intervals[i][1]);
        i++;
    }
    // Add the merged newInterval to the result (added as-is even if zero intervals overlapped)
    res.add(newInterval);

    // Phase 3: Add intervals that are completely after newInterval as-is (no merging needed)
    while (i < n) {
        res.add(intervals[i]);
        i++;
    }

    // Convert the ArrayList to int[][] and return. new int[0][] is an empty array to convey type information
    return res.toArray(new int[0][]);
}
```
