# Determining if All Meetings Can Be Attended

## Problem

You are given an array `intervals` of intervals (pairs of start and end times) representing meeting time slots. You must determine whether a single person can **attend all meetings** and return a `boolean`. If one meeting starts before another meeting ends, the two meetings conflict (overlap), and the person cannot attend all of them.

## Key Insight

If you sort the intervals by start time, overlaps can only occur between adjacent intervals. By comparing adjacent pairs in order and checking whether the next interval's start time comes before the previous interval's end time, you can determine whether any overlap exists across the entire array.

## Thought Process

1. **Clarify the overlap condition**: Two intervals overlap when one interval's start time comes before the other interval's end time. However, if the intervals are in arbitrary order, you need to compare all pairs, resulting in O(n²) time complexity.
2. **Use sorting to limit comparison targets**: When you sort the intervals in ascending order by start time, overlaps can only occur between adjacent intervals. This is because if `intervals[i]` overlaps with `intervals[i+2]`, then `intervals[i]` must also overlap with `intervals[i+1]`.
3. **Check adjacent pairs for overlap**: After sorting, if the start time of `intervals[i]` comes before the end time of `intervals[i-1]`, the two meetings overlap. You can express this condition as `intervals[i][0] < intervals[i-1][1]`.
4. **A single overlap immediately determines the result**: If you find even one overlapping pair, the person cannot attend all meetings, so you return `false`. If you check all adjacent pairs and find no overlaps, you return `true`.

## Prerequisites

### Arrays.sort with a Custom Comparator

`Arrays.sort` is a method that sorts an array. For a 2D array, you can specify a Comparator (comparison function) using a lambda expression to control which element the sort uses as its key.

```java
int[][] intervals = {{7, 10}, {2, 4}, {5, 8}};
Arrays.sort(intervals, (a, b) -> a[0] - b[0]);  // Sort in ascending order by each interval's start time ([0])
// Result: {{2, 4}, {5, 8}, {7, 10}}
```

`(a, b) -> a[0] - b[0]` takes two intervals `a` and `b` and returns the difference of their start times. If the difference is negative, `a` comes first; if positive, `b` comes first.

### Interval Overlap Detection

When two intervals are sorted by start time, the intervals overlap if the later interval's start comes before the earlier interval's end.

```java
int[] prev = {2, 4};   // Meeting from 2:00 to 4:00
int[] curr = {3, 6};   // Meeting from 3:00 to 6:00
curr[0] < prev[1];     // 3 < 4 → true → The intervals overlap
```

## Complexity

| | Value |
|---|---|
| Time | O(n log n) — Sorting takes O(n log n) and scanning adjacent pairs takes O(n), so sorting dominates |
| Space | O(1) — Sorting rearranges the input array in place, so it uses no additional arrays |

## Code

```java
// Input: A 2D integer array intervals representing meeting time slots (each element is [start time, end time])
// Output: true if the person can attend all meetings, false if any meetings overlap
public boolean canAttendMeetings(int[][] intervals) {
    // Sort the intervals in ascending order by start time
    // Pass the lambda expression (a, b) -> a[0] - b[0] as the Comparator
    // This ensures that comparing only adjacent pairs is sufficient for the chronologically ordered intervals
    Arrays.sort(intervals, (a, b) -> a[0] - b[0]);

    // Start from i = 1, not i = 0, because each step compares the adjacent pair intervals[i] and intervals[i-1]
    for (int i = 1; i < intervals.length; i++) {
        // If the current meeting's start time comes before the previous meeting's end time, the meetings overlap
        if (intervals[i][0] < intervals[i - 1][1]) {
            // If even one overlap exists, the person cannot attend all meetings, so return false immediately
            return false;
        }
        // If there is no overlap, proceed to the next adjacent pair
    }
    // If the loop completes without finding any overlap in any adjacent pair, return true
    return true;
}
```
