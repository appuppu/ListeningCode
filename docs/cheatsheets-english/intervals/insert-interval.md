# Inserting a New Interval Into a Sorted List — Insert a new interval into a sorted, non-overlapping interval list and merge overlaps

## Problem

You are given a sorted, non-overlapping interval list `intervals` and a new interval `newInterval`. You must insert `newInterval` at the correct position, merge all overlapping intervals, and return the resulting non-overlapping interval list.

## Key Insight

When you scan a sorted interval list from left to right, each interval falls into one of three groups: "completely before the new interval," "overlapping with the new interval," or "completely after the new interval." Processing these three phases in order completes both insertion and merging in a single pass.

## Thought Process

1. **There are only 3 positional relationships between intervals**: Each interval in the sorted list can be classified as "completely before," "overlapping with," or "completely after" newInterval. By leveraging this classification, you can process the list in a single scan.
2. **Condition for "completely before"**: If the end of an existing interval `intervals[i][1]` is less than the start of newInterval `newInterval[0]`, that interval does not overlap with newInterval. You add intervals satisfying this condition directly to the result.
3. **Condition for "overlapping"**: If the start of an existing interval `intervals[i][0]` is less than or equal to the end of newInterval `newInterval[1]`, that interval overlaps with newInterval. Each time you find an overlapping interval, you update the start and end of newInterval to expand the merged range.
4. **How to merge**: You take the smaller of the overlapping interval's start and newInterval's start as the new start, and the larger of the overlapping interval's end and newInterval's end as the new end. This consolidates multiple overlapping intervals into a single interval.
5. **When to add the merged result**: Once there are no more overlapping intervals, you add the merged newInterval to the result. All subsequent intervals are completely after newInterval, so you add them directly to the result.
6. **What to return**: You convert the result list built across the three phases into an `int[][]` and return it.

## Prerequisites

### ArrayList

ArrayList is a resizable array. You can append elements with `add()` in O(1) amortized time and convert the list to a fixed-size array at the end. You use ArrayList when the result size is unknown in advance.

```java
List<int[]> res = new ArrayList<>();   // Create an empty ArrayList
res.add(new int[]{1, 3});              // Append an element to the end
res.toArray(new int[0][]);             // Convert to an int[][] array
```

### Math.min / Math.max

These methods return the smaller or larger of two values. You use them to determine the start and end when merging intervals.

```java
Math.min(1, 3);   // → 1 (returns the smaller value)
Math.max(1, 3);   // → 3 (returns the larger value)
```

### Overlap Detection for Intervals

You can determine whether two intervals `[a, b]` and `[c, d]` overlap by checking `a <= d && c <= b`. In this problem, because the list is sorted, checking only one of these conditions is sufficient.

```java
// The existing interval is completely before newInterval (no overlap)
intervals[i][1] < newInterval[0]   // end of existing interval < start of new interval

// The existing interval overlaps with newInterval
intervals[i][0] <= newInterval[1]  // start of existing interval <= end of new interval
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — You only need a single pass through the interval list |
| Space | O(n) — The result list stores at most n+1 intervals |

## Code

```java
// Input: a sorted, non-overlapping interval list intervals (int[][]) and a new interval newInterval (int[])
// Output: return the non-overlapping interval list (int[][]) after inserting and merging newInterval
public int[][] insert(int[][] intervals, int[] newInterval) {
    // A resizable list to store the result. Use ArrayList because the size is unknown in advance
    List<int[]> res = new ArrayList<>();
    // A variable to track the current scan position
    int i = 0;
    // Store the total number of intervals for repeated reference in loop conditions
    int n = intervals.length;

    // Phase 1: Add intervals that are completely before newInterval as-is
    // Condition: end of existing interval < start of newInterval → no overlap
    while (i < n && intervals[i][1] < newInterval[0]) {
        res.add(intervals[i]);
        i++;
    }

    // Phase 2: Merge all intervals that overlap with newInterval
    // Condition: start of existing interval <= end of newInterval → overlap exists
    while (i < n && intervals[i][0] <= newInterval[1]) {
        // Take the smaller start (the merged range may expand to the left)
        newInterval[0] = Math.min(newInterval[0], intervals[i][0]);
        // Take the larger end (the merged range may expand to the right)
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

    // Convert the ArrayList to int[][] and return. new int[0][] serves as a type hint for toArray
    return res.toArray(new int[0][]);
}
```
