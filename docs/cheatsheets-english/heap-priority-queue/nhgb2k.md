# Simulating a Last Stone Weight Game — Find the weight of the last remaining stone after smashing stones two at a time

## Problem

You are given an integer array `stones`. In each turn, you pick the **two heaviest stones** and smash them together. If the two stones have equal weight, both stones are destroyed. If the weights differ, the lighter stone is destroyed and the heavier stone's weight is reduced by the difference. You repeat this process until at most one stone remains, then return the weight of the last remaining stone. If no stones remain, you return 0.

## Key Insight

You need to efficiently retrieve the two heaviest stones in each turn. A Max-Heap allows you to extract the maximum value in O(log n), so you can always obtain the two heaviest stones without re-sorting the entire collection.

## Thought Process

1. **Each turn requires the two largest values**: The smashing rule always selects the two heaviest stones. This means the problem reduces to repeatedly extracting the maximum value twice from the current collection.
2. **You want to extract the maximum value quickly**: Sorting the array every turn costs O(n log n) per round. A Max-Heap reduces the extraction cost to O(log n) per element, and insertion also costs O(log n).
3. **You use Java's PriorityQueue as a Max-Heap**: Java's PriorityQueue is a Min-Heap (smallest value at the head) by default. Passing `Collections.reverseOrder()` as the comparator makes it function as a Max-Heap where the largest value is at the head.
4. **You insert all stones into the heap**: You add every element of the `stones` array to the PriorityQueue. This prepares the heap to manage the maximum value.
5. **You repeat the smashing operation while two or more stones remain**: You call `poll()` twice on the heap to extract the two largest values. If their difference is non-zero, you put the difference back into the heap with `add()`. If the difference is zero, you add nothing back (both stones are destroyed).
6. **You check the final state and return the result**: After the loop ends, if the heap is empty, all stones have been destroyed, so you return 0. If one stone remains in the heap, you extract its weight with `poll()` and return it.

## Prerequisites

### What is a PriorityQueue?

A PriorityQueue is a data structure that automatically maintains the ordering of its elements internally when you add them, and always lets you extract the highest-priority element via `poll()`. Its internal implementation is a heap (binary heap), and both insertion and extraction run in O(log n).

```java
// The default is a Min-Heap (smallest value at the head)
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.add(5);       // Add element 5
minHeap.add(2);       // Add element 2
minHeap.poll();       // Extract and return the minimum value 2
minHeap.size();       // Return the current number of elements → 1
minHeap.isEmpty();    // Return whether the queue is empty as a boolean → false
```

### What is Collections.reverseOrder()?

`Collections.reverseOrder()` is a comparator that you pass to the PriorityQueue constructor to reverse the default ascending order (Min-Heap) into descending order (Max-Heap). This makes `poll()` return the maximum value.

```java
// Create a Max-Heap (largest value at the head)
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
- After adding all elements to the heap, the internal structure manages them as `[8, 7, 4, 1, 2, 1]`
- `poll()` → extracts 8. The heap restructures to `[7, 4, 2, 1, 1]`
- `poll()` → extracts 7. The difference 8 - 7 = 1 is added back to the heap via `add()`

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
    // Create a Max-Heap (largest value at the head) using Collections.reverseOrder()
    // The default PriorityQueue is a Min-Heap, so the comparator reverses it to descending order
    PriorityQueue<Integer> pq =
        new PriorityQueue<>(Collections.reverseOrder());

    // Add all stones to the heap. After adding all elements, the heap manages the largest value at the head
    for (int s : stones) pq.add(s);

    // Repeat the smashing operation while two or more stones remain
    while (pq.size() >= 2) {
        // Call poll() twice to extract the heaviest stone and the second heaviest stone
        // Since this is a Max-Heap, a >= b always holds
        int a = pq.poll();  // Extract the heaviest stone
        int b = pq.poll();  // Extract the second heaviest stone

        // If the weights differ, add the difference back to the heap. If they are equal, both are destroyed so add nothing back
        if (a != b) pq.add(a - b);
    }

    // If the heap is empty, all stones have been destroyed so return 0. Otherwise, return the remaining stone's weight
    return pq.isEmpty() ? 0 : pq.poll();
}
```
