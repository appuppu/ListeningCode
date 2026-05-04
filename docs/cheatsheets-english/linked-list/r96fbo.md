# Reversing a Linked List — Reverse a Singly Linked List

## Problem

You are given the head node `head` of a singly linked list. You reverse the direction of all links (pointers) in the list so that the original tail node becomes the new head, and you return that new head node.

## Key Insight

If you reassign each node's `next` pointer from "the next node" to "the previous node," the entire list becomes reversed. You use three pointers (prev, curr, next) to safely reassign the links one by one in a single traversal.

## Thought Process

1. **Reversing means flipping the direction of links**: The order of a linked list is determined by each node's `next` pointer. If you change every node's `next` from "the next node" to "the previous node," the entire list becomes reversed.
2. **Reassigning a link loses the reference to the next node**: The moment you write `curr.next = prev`, the reference to the original next node disappears. Therefore, you need to save `curr.next` into a separate variable `next` before overwriting it.
3. **Three pointers manage the state**: With `prev` (the previous node that becomes the new link target), `curr` (the node currently being processed), and `next` (the saved reference to the original next node), you can reassign links and traverse the list simultaneously.
4. **Set the initial state**: After reversal, the tail node (originally the head) should have its `next` set to `null`, so you initialize `prev` to `null`. You initialize `curr` to `head` (the first node).
5. **Loop termination and return value**: When `curr` becomes `null`, all nodes have been processed. At that point, `prev` points to the last processed node (the original tail node), so you return `prev` as the new head.

## Prerequisites

### ListNode (Linked List Node)

A ListNode is an element that makes up a linked list. Each node holds a "value (val)" and a "pointer to the next node (next)." The last node's `next` is `null`.

```java
class ListNode {
    int val;          // The value stored in this node
    ListNode next;    // Reference to the next node (null if this is the tail)

    ListNode(int val) {
        this.val = val;
        this.next = null;
    }
}
```

### Pointer Reassignment

Pointer reassignment means changing the direction of a link by assigning a different node to a node's `next` field.

```java
// Original state: A → B → C
// A.next points to B

A.next = null;   // A → null (the link between A and B is severed)
B.next = A;      // B → A (a reverse link from B to A is created)
// Result: C → null, B → A → null
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm requires only a single traversal of the list |
| Space | O(1) — The algorithm uses only three pointer variables and requires no additional data structures |

## Code

```java
// Input: head node of a singly linked list
// Output: the new head node (ListNode) of the reversed list
ListNode reverseList(ListNode head) {
    // prev: the target of the reassigned link (the "previous node" in the reversed list)
    // The first node (original head) becomes the tail after reversal, so its next should be null. Hence prev starts as null
    ListNode prev = null;
    // curr: the node whose link we are about to reassign. Processing starts from the head node
    ListNode curr = head;

    // When curr becomes null, all nodes have been processed
    while (curr != null) {
        // Save the original next node (we are about to overwrite curr.next, so we preserve the reference)
        ListNode next = curr.next;

        // Reverse the link: point to the previous node instead of the next node. This is the core reversal operation
        curr.next = prev;

        // Advance prev to the current node (it will serve as the reassignment target for the next node in the next iteration)
        prev = curr;
        // Advance curr to the saved original next node (this continues the traversal through the list)
        curr = next;
    }

    // After the last iteration, prev holds the last processed node (the original tail node)
    // This node is the new head of the reversed list
    return prev;
}
```
