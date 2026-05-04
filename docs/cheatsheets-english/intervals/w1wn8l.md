# Finding the Minimum Removals for Non-Overlapping Intervals

## Problem

You are given an array of intervals `intervals`, where each interval is a pair `[start, end]`. Return the **minimum number of intervals you need to remove** so that the remaining intervals do not overlap with each other.

## Key Insight

If you sort the intervals by their end times and greedily keep the intervals that end earliest, you minimize the chance of overlapping with subsequent intervals. When an overlap occurs, you remove the interval that ends later (i.e., the current interval), which minimizes the total number of removals.

## Thought Process

1. **To reduce overlaps, prioritize keeping intervals that "take up less space"**: An interval that ends earlier leaves more room after it, making it less likely to overlap with subsequent intervals. Therefore, the optimal strategy is to sort the intervals in ascending order of end time and greedily select them from earliest to latest.
2. **After sorting, you only need to track the end time of the last kept interval**: Because the intervals are sorted by end time, you only need to remember the end time `lastEnd` of the most recently kept interval to determine whether the next interval overlaps. If the next interval's start time is less than `lastEnd`, the two intervals overlap.
3. **When an overlap occurs, remove the current interval**: When an overlap is detected, you must decide whether to remove the previously kept interval or the current interval. Since the intervals are sorted by end time, the current interval's end time is greater than or equal to the previous interval's end time. Removing the current interval (which ends later) has less impact on subsequent intervals. Therefore, you increment `removals` and do not update `lastEnd`.
4. **When no overlap occurs, keep the current interval**: If the current interval's start time is greater than or equal to `lastEnd`, the intervals do not overlap, so you keep the current interval and update `lastEnd` to the current interval's end time.
5. **What to return**: After the loop completes, return `removals` (the number of intervals removed).

## Prerequisites

### Custom Comparator for Arrays.sort

You can customize the sorting criteria by passing a lambda expression as the second argument to `Arrays.sort`. The expression `(a, b) -> a[1] - b[1]` sorts the intervals in ascending order based on each interval's end time (the element at index 1).

```java
int[][] intervals = {{1,3}, {2,4}, {0,2}};
Arrays.sort(intervals, (a, b) -> a[1] - b[1]);
// Result: {{0,2}, {1,3}, {2,4}} — sorted in ascending order of end time
```

### Greedy Algorithm

A greedy algorithm is a technique that makes the locally optimal choice at each step to find the globally optimal solution. In this problem, the local choice of "prioritizing keeping the interval with the earliest end time" leads to the global minimization of the number of removals.

```java
// Typical greedy pattern: sort first, then make the optimal choice sequentially
Arrays.sort(data, comparator);  // Sort by the chosen criteria
for (int i = 0; i < data.length; i++) {
    // Select if the condition is met; skip otherwise
}
```

## Complexity

| | Value |
|---|---|
| Time | O(n log n) — Sorting takes O(n log n) and the traversal takes O(n), so sorting dominates |
| Space | O(1) — No additional data structures are used, excluding the internal space used by sorting |

## Code

```java
// Input: an array of intervals int[][] intervals (each element is [start, end])
// Output: return an int representing the minimum number of intervals to remove to eliminate all overlaps
int eraseOverlapIntervals(int[][] intervals) {
    // If there are no intervals, no removal is needed
    if (intervals.length == 0)
        return 0;

    // Sort in ascending order of end time (to prioritize keeping intervals that end earliest)
    // Greedy: intervals that end earlier are less likely to overlap with subsequent ones, so keeping them first is optimal
    Arrays.sort(intervals, (a, b) -> a[1] - b[1]);

    // Variable to record the number of removed intervals
    int removals = 0;
    // Always keep the first interval after sorting (it has the earliest end time). Record its end time
    int lastEnd = intervals[0][1];

    // Traverse from index 1 (index 0 is already confirmed as a kept interval)
    for (int i = 1; i < intervals.length; i++) {
        // If the current interval's start time is less than lastEnd, it overlaps with the last kept interval
        if (intervals[i][0] < lastEnd) {
            // Remove the current interval. Since the array is sorted by end time, the current interval's end time
            // is >= lastEnd, so removing the later-ending current interval reduces future overlaps. Do not update lastEnd
            removals++;
        } else {
            // No overlap, so keep the current interval and update lastEnd to the current interval's end time
            // The overlap check for the next interval will use this new lastEnd as the reference
            lastEnd = intervals[i][1];
        }
    }
    // removals is the minimum number of intervals that need to be removed to eliminate all overlaps
    return removals;
}
```
