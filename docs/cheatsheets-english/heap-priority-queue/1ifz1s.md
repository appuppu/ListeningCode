# Finding the Median From a Data Stream — Finding the Median in Real Time From a Data Stream

## Problem

Design a data structure that supports two operations as integers are continuously added from a data stream. `addNum(int num)` adds an integer, and `findMedian()` returns the **median** of all integers added so far. If the number of elements is odd, the method returns the middle value; if even, it returns the average of the two middle values.

## Key Insight

If you split all elements into a "lower half" and an "upper half" and manage them with a max-heap and a min-heap respectively, you can always retrieve the median in O(1) from the tops of the two heaps.

## Thought Process

1. **The median sits in the "middle"**: To find the median, you need to maintain all elements in sorted order and access the middle element. However, sorting after every insertion costs O(n log n).
2. **You don't need the full sorted order — you only need the middle**: If you split all elements into a "lower half" and an "upper half," the maximum of the lower half and the minimum of the upper half become the median candidates.
3. **You want fast access to each half's extreme value**: A max-heap retrieves the maximum of the lower half in O(1), and a min-heap retrieves the minimum of the upper half in O(1). Insertion into a heap takes only O(log n).
4. **Maintain size balance between the two heaps**: To compute the median correctly, the size difference between the two heaps must be at most 1. You keep `lo` (max-heap) at a size greater than or equal to `hi` (min-heap).
5. **Balancing procedure on element insertion**: First add the new element to `lo`, then move `lo`'s maximum to `hi`. This guarantees that `lo`'s maximum ≤ `hi`'s minimum at all times. After that, if `hi`'s size exceeds `lo`'s size, move `hi`'s minimum back to `lo`.
6. **Retrieving the median**: If `lo`'s size is greater than `hi`'s size, the total number of elements is odd, so `lo`'s top (maximum) is the median. If the sizes are equal, the total number of elements is even, so the median is the average of `lo`'s top and `hi`'s top.

## Prerequisites

### What Is a PriorityQueue (Heap)?

A PriorityQueue is a data structure that manages elements in priority order. By default, it operates as a min-heap (the smallest value is at the front). Retrieving the front element takes O(1), and adding or removing elements takes O(log n).

```java
// min-heap (default): the smallest value is at the front
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.offer(5);       // Add element 5
minHeap.offer(3);       // Add element 3
minHeap.peek();          // Get the front minimum value → 3 (does not remove)
minHeap.poll();          // Remove and return the front minimum value → 3 (removes it)

// max-heap: the largest value is at the front (specify Collections.reverseOrder())
PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
maxHeap.offer(5);       // Add element 5
maxHeap.offer(3);       // Add element 3
maxHeap.peek();          // Get the front maximum value → 5
```

### Differences Between offer / poll / peek

| Method | Behavior | Return Value |
|---|---|---|
| `offer(e)` | Adds element `e` to the heap | `boolean` (true on success) |
| `poll()` | Removes and returns the front element | The removed element (`null` if empty) |
| `peek()` | Returns the front element **without removing** it | The front element (`null` if empty) |

### What Is a Median?

The median is the middle value in a sorted list. If the number of elements is odd, it is the single middle element; if even, it is the average of the two middle elements.
Example: `[1, 2, 3]` → the median is `2`. `[1, 2, 3, 4]` → the median is `(2 + 3) / 2.0 = 2.5`.

## Complexity

| | Value |
|---|---|
| Time | O(log n) — `addNum` performs up to 3 heap insertions/removals, each costing O(log n). `findMedian` runs in O(1) |
| Space | O(n) — The two heaps store all elements |

## Code

```java
// Input: addNum(int num) receives integers one at a time as a stream
// Output: findMedian() returns the median of all integers added so far as a double
class MedianFinder {
    // Max-heap managing the lower half (the front is the maximum)
    PriorityQueue<Integer> lo;
    // Min-heap managing the upper half (the front is the minimum)
    PriorityQueue<Integer> hi;

    MedianFinder() {
        // Use Collections.reverseOrder() to make the max-heap sort in descending order
        lo = new PriorityQueue<>(Collections.reverseOrder());
        // The min-heap uses the default ascending order
        hi = new PriorityQueue<>();
    }

    void addNum(int num) {
        // Always add any element to the lower half (lo) first
        lo.offer(num);
        // Move lo's maximum to hi to always maintain the invariant: all elements in lo ≤ all elements in hi
        hi.offer(lo.poll());

        // If hi's size exceeds lo's size, move hi's minimum back to lo to restore balance
        // This operation ensures lo's size is always ≥ hi's size (difference is at most 1)
        if (hi.size() > lo.size())
            lo.offer(hi.poll());
    }

    double findMedian() {
        // If lo's size is larger = total element count is odd → lo's front (the maximum of the lower half) is the median
        if (lo.size() > hi.size())
            return lo.peek();

        // If sizes are equal = total element count is even → return the average of the two middle elements
        // Dividing by 2.0 performs floating-point division instead of integer division
        return (lo.peek() + hi.peek()) / 2.0;
    }
}
```
