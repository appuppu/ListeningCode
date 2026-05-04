# Merging K Sorted Linked Lists — Merge K sorted linked lists into one

## Problem

The system provides an array of K sorted linked lists. The algorithm merges all of them into **one sorted linked list** and returns the head node. Each list is individually sorted, and the merged list must maintain ascending order.

## Key Insight

Instead of merging all K lists at once, the algorithm pairs them up and repeats the merge process. Each round halves the number of lists, so the process converges into one list in log k rounds, achieving O(N log k) efficiency for all N elements.

## Thought Process

1. **The fundamental operation is "merging two sorted lists"**: The problem of merging K lists can be decomposed into combinations of the fundamental operation "merge two sorted lists into one." Merging two lists runs in O(n) by repeatedly comparing the heads and choosing the smaller one.
2. **How to apply this fundamental operation to K lists**: A naive approach — merging the 1st and 2nd lists, then merging the result with the 3rd, and so on — results in O(Nk). The merge result grows longer each time, making later merges increasingly expensive.
3. **Pairwise merging distributes the cost evenly**: Pairing lists and merging them two at a time processes all elements exactly once per round. The number of lists halves each round, so the total number of rounds is log k, achieving O(N log k) overall.
4. **Managing pairs with array indices**: The algorithm doubles an `interval` variable as 1, 2, 4, 8… and merges `lists[i]` with `lists[i + interval]`, storing the result in `lists[i]`. This approach realizes pairwise merging in-place without using an additional array.
5. **After all rounds, lists[0] holds the final result**: Each round consolidates merge results into even-indexed positions — `lists[0]`, `lists[2]`, `lists[4]`… — and ultimately all elements converge into `lists[0]`.

## Prerequisites

### ListNode (Linked List Node)

A ListNode is a class that represents each element of a linked list. The field `val` holds the value, and `next` holds a reference to the next node. A node whose `next` is `null` marks the end of the list.

```java
class ListNode {
    int val;              // The value this node holds
    ListNode next;        // Reference to the next node (null if this is the tail)
    ListNode(int val) {   // Constructor: creates a node with the specified value
        this.val = val;
    }
}
```

### Dummy Node (Sentinel Node)

A dummy node is a technique that simplifies list construction. The algorithm places a dummy node with value 0 at the head and appends actual nodes after it. Returning `dummy.next` at the end eliminates the need for special handling of the head node.

```java
ListNode dummy = new ListNode(0);  // Create a dummy node
ListNode tail = dummy;             // tail is a pointer that tracks the end
tail.next = someNode;              // Append a node after the dummy
tail = tail.next;                  // Advance tail to the end
return dummy.next;                 // Return the node after dummy, i.e., the actual head
```

### Divide and Conquer

Divide and conquer is a technique that splits a problem into smaller subproblems, solves each subproblem, and then combines the results. Merge sort is a classic example: it splits an array in half, then merges the sorted subarrays. This problem applies the same idea by repeatedly merging K lists in pairs.

```java
// interval doubles as 1, 2, 4, 8..., widening the gap between pairs
for (int interval = 1; interval < n; interval *= 2) {
    // Each round merges pairs in order
    for (int i = 0; i < n - interval; i += 2 * interval) {
        lists[i] = merge(lists[i], lists[i + interval]);
    }
}
```

## Complexity

| | Value |
|---|---|
| Time | O(N log k) — The algorithm processes all N elements once per round, and the number of rounds is log k |
| Space | O(log k) — The algorithm does not use recursion, but it uses stack space corresponding to the number of merge rounds |

## Code

```java
// Input: an array of sorted linked lists ListNode[] lists (K elements)
// Output: returns the head ListNode of a single sorted linked list that merges all lists

// Helper method that merges two sorted lists into one
private ListNode mergeTwoLists(ListNode a, ListNode b) {
    // Create a dummy node to serve as a marker for the head of the merged result list (actual data starts at dummy.next)
    ListNode dummy = new ListNode(0);
    // tail always tracks the end of the merged result and indicates where to append the next node
    ListNode tail = dummy;

    // While both lists have remaining nodes, choose the smaller one and append it (to maintain sorted order)
    while (a != null && b != null) {
        if (a.val <= b.val) {
            tail.next = a;  // Append the current node of a to the merged result
            a = a.next;     // Advance a to the next node
        } else {
            tail.next = b;  // Append the current node of b to the merged result
            b = b.next;     // Advance b to the next node
        }
        tail = tail.next;   // Advance tail to the end, preparing to append the next node
    }

    // After the while loop ends, either a or b has remaining nodes. Since both are sorted, the algorithm appends the remainder directly
    tail.next = (a != null) ? a : b;

    // dummy itself is a placeholder, so the next node is the actual head of the merged result
    return dummy.next;
}

public ListNode mergeKLists(ListNode[] lists) {
    // If the input is null or empty, there are no lists to merge, so the method returns null
    if (lists == null || lists.length == 0) return null;

    // Store the number of lists K in n
    int n = lists.length;

    // Double interval as 1, 2, 4, 8... — interval represents the distance between paired lists, and each round halves the number of lists
    for (int interval = 1; interval < n; interval *= 2) {
        // The condition i < n - interval guarantees that the right side of the pair lists[i + interval] exists within the array bounds
        for (int i = 0; i < n - interval; i += 2 * interval) {
            // Store the merge result in lists[i]. The right-side list is no longer needed, so overwriting the left side is safe
            lists[i] = mergeTwoLists(lists[i], lists[i + interval]);
        }
    }

    // After all rounds complete, the merged result of all lists is consolidated in lists[0]
    return lists[0];
}
```
