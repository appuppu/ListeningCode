# Tracking the Kth Largest Element in a Stream — Always Retrieve the Kth Largest Element from a Stream

## Problem

You design a class that receives an integer `k` and an initial list of numbers. Each time the `add` method is called, the method adds a new number to the stream and returns the **Kth largest element** across the entire stream at that point.

## Key Insight

Since you only need the Kth largest element, you maintain only the top K elements in a Min-Heap. The root (minimum value) of the heap always represents the Kth largest element.

## Thought Process

1. **You only need the Kth largest element**: You do not need to sort the entire stream. As long as you track the top K elements, you can determine the Kth largest element.
2. **You want to manage the top K elements efficiently**: A Min-Heap is suitable because it performs both insertion and extraction of the minimum in O(log n). The root of a Min-Heap always holds the minimum value within the heap, so if you keep the heap size at K, the root becomes the Kth largest element.
3. **You limit the heap size to K**: After adding a new element, if the heap size exceeds K, you remove the root (minimum value) using `poll()`. This automatically eliminates values smaller than the Kth largest element, ensuring that only the top K elements remain.
4. **You retrieve the Kth largest element**: When the heap size is exactly K, the root value is the Kth largest element. You retrieve it in O(1) using `peek()`.
5. **You reuse `add` during initialization**: The constructor calls `add` for each element in the initial list, which builds the heap using the same logic. This approach shares code between initialization and addition.

## Prerequisites

### What Is a Min-Heap?

A heap is a data structure based on a complete binary tree. In a Min-Heap, the system maintains the property that every parent node's value is less than or equal to its children's values. Therefore, the root always holds the minimum value in the heap. Both insertion and extraction of the minimum run in O(log n).

### What Is PriorityQueue?

PriorityQueue is Java's implementation class for a Min-Heap. By default, it prioritizes elements in ascending order (smallest first).

```java
PriorityQueue<Integer> heap = new PriorityQueue<>();  // Create an empty Min-Heap
heap.offer(5);        // Add element 5 to the heap
heap.offer(3);        // Add element 3 to the heap
heap.offer(8);        // Add element 8 to the heap
heap.peek();          // Return the root (minimum value) without removing it → 3
heap.poll();          // Remove and return the root (minimum value) → 3
heap.size();          // Return the number of elements in the heap → 2
```

### Why a Min-Heap Reveals the Kth Largest Element

A Min-Heap of size K contains the top K largest elements. The root is the smallest value among them, meaning "the minimum of the top K" equals "the Kth largest element overall."
Example: When k=3 and the heap contains [4, 5, 8], the root is 4. This is the 3rd largest element overall.

## Complexity

| | Value |
|---|---|
| Time | O(log k) — Each call to the `add` method performs one insertion and one deletion on a heap of size K, each costing O(log k) |
| Space | O(k) — The heap holds at most K elements at all times |

## Code

```java
// Input: an integer k, an initial integer array nums, and an integer val passed to the add method
// Output: the add method returns the Kth largest element across the entire stream as an int
class KthLargest {
    // Store k as a field because it serves as the heap size limit throughout the lifetime of the object
    int k;
    // PriorityQueue operates as a Min-Heap (minimum value at the root) by default
    PriorityQueue<Integer> heap;

    // Constructor: receive k and the initial array, then build the heap
    KthLargest(int k, int[] nums) {
        this.k = k;
        heap = new PriorityQueue<>();
        // The add method handles the heap size limit, so no separate initialization logic is needed
        for (int n : nums) {
            add(n);
        }
    }

    // Add a new value and return the Kth largest element
    int add(int val) {
        // Insert the element at the end of the heap and sift it up toward the root to maintain the heap property (O(log k))
        heap.offer(val);

        // If the size exceeds K, one extra element smaller than the Kth largest exists
        if (heap.size() > k) {
            // The root of a Min-Heap is always the minimum value, so the removed element is smaller than the Kth largest
            heap.poll();
        }

        // When the heap size is exactly K, the root is the minimum value in the heap = the Kth largest element overall
        return heap.peek();
    }
}
```
