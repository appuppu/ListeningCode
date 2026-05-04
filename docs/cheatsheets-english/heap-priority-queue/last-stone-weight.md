# Simulating a Last Stone Weight Game — Find the weight of the last remaining stone after smashing stones two at a time

## Problem

You are given an integer array `stones`. Each turn, you pick the **two heaviest stones** and smash them together. If the two stones have equal weight, both stones are destroyed. If they have different weights, the lighter stone is destroyed and the heavier stone is reduced to the difference in weight. You repeat this process until at most one stone remains, then return the weight of the last remaining stone. If no stones remain, return 0.

## Key Insight

You need to efficiently extract the two heaviest stones each turn. By using a Max-Heap, you can extract the maximum value in O(log n) time, which eliminates the need to re-sort and allows you to always retrieve the two heaviest stones.

## Thought Process

1. **Each operation requires the two largest values**: The smashing rule always selects the two heaviest stones. This means the problem requires repeatedly extracting the maximum value twice from the current collection.
2. **You want to extract the maximum value quickly**: Sorting the array each round costs O(n log n). A Max-Heap allows you to extract the maximum in O(log n) and insert an element in O(log n).
3. **Use Java's PriorityQueue as a Max-Heap**: Java's PriorityQueue is a Min-Heap (smallest value at the front) by default. Passing `Collections.reverseOrder()` as the comparator makes it operate as a Max-Heap with the largest value at the front.
4. **Insert all stones into the heap**: Add all elements of the `stones` array to the PriorityQueue. This prepares the heap to manage the maximum value.
5. **Repeat the smashing operation while two or more stones remain**: Call `poll()` twice on the heap to extract the two largest values. If the difference is not 0, add the difference back to the heap with `add()`. If the difference is 0, add nothing back (both stones are destroyed).
6. **Check the final state and return**: After the loop ends, if the heap is empty, all stones have been destroyed, so return 0. If one stone remains in the heap, extract its weight with `poll()` and return it.

## Prerequisites

### What is a PriorityQueue?

A PriorityQueue is a data structure that automatically maintains ordering when elements are added, and always extracts the highest-priority element via `poll()`. Its internal implementation is a heap (binary heap), and both insertion and extraction operate in O(log n).

```java
// Default is Min-Heap (smallest value at the front)
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.add(5);       // Add element 5
minHeap.add(2);       // Add element 2
minHeap.poll();       // Extract and return the minimum value 2
minHeap.size();       // Return the current number of elements → 1
minHeap.isEmpty();    // Return whether the queue is empty as a boolean → false
```

### What is Collections.reverseOrder()?

A comparator passed to the PriorityQueue constructor that reverses the default ascending order (Min-Heap) to descending order (Max-Heap). This causes `poll()` to return the maximum value.

```java
// Create a Max-Heap (largest value at the front)
PriorityQueue<Integer> maxHeap =
    new PriorityQueue<>(Collections.reverseOrder());
maxHeap.add(3);       // Add element 3
maxHeap.add(7);       // Add element 7
maxHeap.add(1);       // Add element 1
maxHeap.poll();       // Extract and return the maximum value 7
maxHeap.poll();       // Extract and return the next maximum value 3
```

### How a Max-Heap Works

For stones = [2, 7, 4, 1, 8, 1]:
- After adding all elements to the heap, the internal structure is managed as `[8, 7, 4, 1, 2, 1]`
- `poll()` → extracts 8. The heap is restructured to `[7, 4, 2, 1, 1]`
- `poll()` → extracts 7. The difference 8 - 7 = 1 is added back to the heap with `add()`

## Complexity

| | Value |
|---|---|
| Time | O(n log n) — There are at most n smashing operations, and each operation costs O(log n) for heap extraction and insertion |
| Space | O(n) — The heap stores at most n stones |

## Code

```java
// Input: integer array stones (each element represents a stone's weight)
// Output: return the weight of the last remaining stone as an int. Return 0 if no stones remain
public int lastStoneWeight(int[] stones) {
    // Specify Collections.reverseOrder() as the comparator to create a Max-Heap where poll() returns the maximum value
    PriorityQueue<Integer> pq =
        new PriorityQueue<>(Collections.reverseOrder());

    // Add all stones to the heap. Once complete, the heap manages the maximum value at the front
    for (int s : stones) pq.add(s);

    // Repeat the operation of smashing the two heaviest stones while two or more stones remain
    while (pq.size() >= 2) {
        // Call poll() twice to extract the heaviest stone and the second heaviest stone
        // Since this is a Max-Heap, a >= b always holds
        int a = pq.poll();
        int b = pq.poll();

        // If the weights differ, add the difference back to the heap. If equal, both are destroyed so add nothing back
        if (a != b) pq.add(a - b);
    }

    // If the heap is empty, all stones have been destroyed so return 0. Otherwise, return the weight of the remaining stone
    return pq.isEmpty() ? 0 : pq.poll();
}
```
