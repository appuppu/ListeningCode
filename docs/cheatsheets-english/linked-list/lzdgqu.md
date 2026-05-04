# Deep Copying a Linked List With Random Pointers — Creating a Complete Clone of a Linked List With Random Pointers

## Problem

You are given a linked list where each node has a `next` pointer and a `random` pointer that points to any node in the list (or null). You need to create and return a **deep copy** (a completely independent clone) of this linked list. The `random` pointer of each copied node must point to the corresponding node in the copied list, not in the original list.

## Key Insight

If you insert each copied node immediately after its original node (interleaving), then the "next node" of any original node's `random` target becomes the corresponding copy node. You can leverage this structural relationship to correctly set the random pointers in O(1) space without using a HashMap.

## Thought Process

1. **The difficult part is mapping the random pointers**: If the list only had `next` pointers, you could simply copy nodes in order. However, because `random` can point to any node, you need a way to know the mapping between original nodes and copy nodes.
2. **A HashMap solves this in O(n) space, but can you achieve O(1)?**: You could store the original-to-copy mapping in a HashMap, but you should consider whether you can express this mapping using the list structure itself without any additional data structures.
3. **Insert each copy node immediately after its original node**: If you insert copy A' right after original A, you get an interleaved structure: `A → A' → B → B' → C → C'`. This embeds the mapping directly into the list structure, so for any original node `X`, `X.next` is always its copy `X'`.
4. **Set random pointers using the interleaved structure**: If an original node `curr` has its `random` pointing to another original node `R`, then the copy node `curr.next` should have its `random` set to the copy of `R`, which is `R.next`. This means you can set all random pointers with the single formula `curr.next.random = curr.random.next`.
5. **Separate the two lists**: After setting the random pointers, you extract the original list and the copy list by alternately unlinking nodes from the interleaved structure. You must also restore the original list to its initial state.
6. **Three passes complete the task**: The first pass inserts copy nodes, the second pass sets random pointers, and the third pass separates the lists. Each pass runs in O(n), and because you use no additional data structures, the space complexity is O(1).

## Prerequisites

### Linked List Node Structure (with random)

This is a special node that has a `random` pointer in addition to the usual `next` pointer. The `random` pointer can point to any node in the list or be `null`.

```java
class Node {
    int val;
    Node next;      // Points to the next node (standard linked list)
    Node random;    // Points to any node in the list or null

    Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
```

### What Deep Copy Means

A deep copy creates a completely independent clone of the original object. No copied node may reference any node in the original list. All pointers (`next` and `random`) must point only to nodes within the copied list.

```java
// Shallow copy (WRONG): copy.random points to a node in the original list
copy.random = original.random;

// Deep copy (CORRECT): copy.random points to the corresponding node in the copied list
copy.random = originalToCopyMapping(original.random);
```

### What Interleaving Means

Interleaving arranges elements from two sequences in alternating order. In this problem, you insert copy nodes between the original nodes to form the structure `A → A' → B → B' → C → C'`. This allows you to access the copy of any original node `X` by simply referencing `X.next`.

```java
// Original list:      A → B → C → null
// After interleaving: A → A' → B → B' → C → C' → null
// The copy of A is A.next, the copy of B is B.next
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm traverses the list 3 times. Each pass is O(n), so the total is O(3n) = O(n) |
| Space | O(1) — The algorithm uses no additional data structures beyond the copy nodes required for the output |

## Code

```java
// Input: head node of a linked list with random pointers
// Output: head node of a deep copy of the input list
public Node copyRandomList(Node head) {
    // An empty list has nothing to copy
    if (head == null) return null;

    // === Pass 1: Insert a copy node immediately after each original node ===
    // After this pass, the list becomes an interleaved structure: A → A' → B → B' → C → C'
    Node curr = head;
    while (curr != null) {
        // Create a new copy node with the same value as the original node
        Node copy = new Node(curr.val);
        copy.next = curr.next;       // Set the copy's next to the original's next
        curr.next = copy;            // Set the original's next to the copy, inserting it right after curr
        curr = copy.next;            // copy.next is the next original node. Advance to the next original node
    }

    // === Pass 2: Set random pointers using the interleaved structure ===
    curr = head;
    while (curr != null) {
        // curr.next is the copy node, curr.random.next is the copy of the random target
        // If curr.random is null, the copy's random remains null
        curr.next.random =
            curr.random != null
            ? curr.random.next : null;
        curr = curr.next.next;       // Skip the copy node and advance to the next original node
    }

    // === Pass 3: Separate the interleaved list into the original list and the copy list ===
    // The original list must also be restored to its initial state
    curr = head;
    Node copyHead = head.next;       // Save the head of the copy list. This will be the final return value
    while (curr != null) {
        Node copy = curr.next;       // Get the copy node
        curr.next = copy.next;       // Restore the original list's next (skip the copy to reach the next original node)
        copy.next = copy.next != null
            ? copy.next.next : null;  // Link the copy list's next (skip the original node to reach the next copy)
        curr = curr.next;            // Advance to the restored next original node
    }

    // copyHead is the head of the deep-copied list
    return copyHead;
}
```
