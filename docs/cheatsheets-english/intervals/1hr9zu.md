# Finding the Smallest Interval Containing Each Query

## Problem

You are given a 2D integer array `intervals` (where each element is `[left, right]`) and an integer array `queries`. For each query value, you need to find the interval that contains the query value and has the **smallest size**. The size of an interval is defined as `right - left + 1`. If no interval contains the query value, you return `-1`.

## Key Insight

You sort both the queries and the intervals, then process the queries in ascending order. This approach allows you to incrementally add intervals whose left endpoint is less than or equal to the current query value into a Min-Heap. You then extract the interval with the smallest size whose right endpoint is greater than or equal to the query value from the Min-Heap, and that interval gives you the answer.

## Thought Process

1. **Checking all intervals for each query is inefficient**: Scanning all intervals for each query costs O(n×q). Sorting both the queries and the intervals allows you to share the interval-adding process across all queries, eliminating redundant scans.
2. **Processing queries in ascending order makes interval addition monotonic**: When you sort the intervals by their left endpoint and sort the queries by value in ascending order, the set of intervals satisfying "left endpoint ≤ query value" only grows as the query value increases — it never shrinks. This means adding intervals is a monotonic operation that simply advances a pointer.
3. **You need to efficiently retrieve the smallest-size interval among the candidates**: A Min-Heap is well suited for extracting the minimum-size interval from the candidate set. By using the interval size as the heap key, you can retrieve the smallest interval in O(1) with a peek operation.
4. **Intervals whose right endpoint is less than the query value are invalid**: Among the intervals remaining in the heap, any interval whose right endpoint is less than the query value does not contain that query. You remove these intervals by polling them from the top of the heap. Once you remove an interval, it remains invalid for all subsequent queries (since query values only increase), so you never need to re-add it.
5. **You must preserve the original order of the queries**: You sort the queries for processing, but you must return the results in the original order. To achieve this, you store each query as a pair with its original index before sorting, and you write each answer to the corresponding position in the result array.
6. **If the heap is empty, no interval contains that query**: After removing all invalid intervals, if the heap is empty, no interval contains the current query value, so you store `-1` in the result.

## Prerequisites

### PriorityQueue (Min-Heap)

A PriorityQueue is a data structure that manages elements in priority order. By default, the smallest value appears at the front (Min-Heap). Adding and removing elements costs O(log n), and peeking at the front element costs O(1).

```java
// Min-Heap that stores int[] and orders by the 0th element (size) in ascending order
PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[0] - b[0]);
heap.offer(new int[]{5, 10});  // Add an element
heap.peek();                    // View the front element without removing it → {5, 10}
heap.poll();                    // Remove and return the front element → {5, 10}
heap.isEmpty();                 // Check whether the heap is empty → true
```

### Offline Query Processing

Offline query processing is a technique where you reorder the queries in a convenient processing order rather than handling them in arrival order. You write the results back to their correct positions using the original indices. This technique is effective when there are no dependencies between queries.

```java
int q = queries.length;
int[][] sortedQ = new int[q][2];
for (int i = 0; i < q; i++) {
    sortedQ[i] = new int[]{queries[i], i};  // Create a pair of {query value, original index}
}
Arrays.sort(sortedQ, (a, b) -> a[0] - b[0]);  // Sort in ascending order by query value
```

### Custom Comparator for Arrays.sort

You can sort 2D arrays or object arrays by an arbitrary criterion. The lambda expression `(a, b) -> a[0] - b[0]` means you sort in ascending order by the 0th value of each element.

```java
int[][] intervals = {{3, 6}, {1, 4}, {2, 8}};
Arrays.sort(intervals, (a, b) -> a[0] - b[0]);  // Sort in ascending order by left endpoint → {{1,4}, {2,8}, {3,6}}
```

## Complexity

| | Value |
|---|---|
| Time | O(n log n + q log q) — Sorting the intervals costs O(n log n), sorting the queries costs O(q log q), and heap operations cost O(n log n) since each interval is added and removed at most once |
| Space | O(n + q) — The heap stores at most n intervals, and the sorted query array stores q elements |

## Code

```java
// Input: 2D integer array intervals (each element is [left, right]) and integer array queries
// Output: Return an int[] containing the size of the smallest interval that contains each query, or -1 if no such interval exists
public int[] minInterval(int[][] intervals, int[] queries) {
    // Sort intervals in ascending order by left endpoint. This allows advancing pointer j to add all intervals with left endpoint ≤ query value
    Arrays.sort(intervals, (a, b) -> a[0] - b[0]);

    int q = queries.length;
    // Pair each query with its original index. This is necessary to write results back to the correct positions after sorting
    int[][] sortedQ = new int[q][2];
    for (int i = 0; i < q; i++) {
        sortedQ[i] = new int[]{queries[i], i};
    }
    // Sort queries in ascending order by value. Processing in ascending order makes interval addition a monotonic operation
    Arrays.sort(sortedQ, (a, b) -> a[0] - b[0]);

    // Min-Heap storing {interval size, right endpoint}, ordered by size in ascending order. Using size as the key allows O(1) access to the smallest interval
    PriorityQueue<int[]> heap =
        new PriorityQueue<>((a, b) -> a[0] - b[0]);

    int[] res = new int[q];
    int j = 0;  // Pointer scanning the interval array. It only advances forward across all queries, so total interval additions are O(n)

    for (int[] sq : sortedQ) {
        int val = sq[0], idx = sq[1];  // val = query value, idx = original index

        // Add all intervals with left endpoint ≤ query value to the heap. Since j never moves backward, the total cost is O(n)
        while (j < intervals.length && intervals[j][0] <= val) {
            int sz = intervals[j][1] - intervals[j][0] + 1;  // Interval size = right - left + 1
            heap.offer(new int[]{sz, intervals[j][1]});  // Add {size, right endpoint} to the heap
            j++;
        }

        // Remove intervals whose right endpoint is less than the query value (they do not contain the query). Since query values increase monotonically, a removed interval remains invalid for all subsequent queries
        while (!heap.isEmpty() && heap.peek()[1] < val) {
            heap.poll();
        }

        // If the heap is empty, no interval contains this query. Otherwise, the front element's size is the answer (all invalid intervals have been removed, so the front is both the smallest and valid)
        res[idx] = heap.isEmpty() ? -1 : heap.peek()[0];
    }
    return res;
}
```
