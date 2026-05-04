# Adding Two Numbers Represented as Linked Lists

## Problem

The function receives two non-empty linked lists. Each linked list represents a non-negative integer in **reverse order** (the ones digit comes first), and each node stores a single digit. The function adds the two numbers together and returns the sum as a **reverse-order linked list**.

## Key Insight

Because the linked lists store digits in reverse order (ones digit first), the function can add digits from the head nodes forward, naturally processing the ones place, then the tens place, then the hundreds place, and so on — exactly like long addition on paper. The function carries over the carry value in a variable and links each resulting digit as a new node.

## Thought Process

1. **Reverse order works in our favor**: Numerical addition starts from the ones digit. Since the linked lists are in reverse order, processing from the head node naturally adds from the ones digit onward. The function does not need to reverse the digit order.
2. **Manage per-digit addition and carry**: At each digit position, the function computes `l1's value + l2's value + carry`. If the total is 10 or greater, a carry occurs. `sum % 10` gives the result for that digit, and `sum / 10` gives the carry to the next digit. This follows the exact rules of long addition.
3. **Handle lists of different lengths**: Even if one list ends first, the function must continue processing as long as the other list or the carry remains. Setting the while loop condition to `l1 != null || l2 != null || carry != 0` handles all cases uniformly.
4. **Use a dummy head to simplify result list construction**: To avoid special-casing the first node of the result list, the function places a dummy node with value 0 at the front. The function appends every digit result to `curr.next`, and at the end, `dummy.next` gives the correct result list.
5. **Unify processing inside the loop**: In each iteration, if `l1` and `l2` are not null, the function adds their respective values to the sum and advances the pointer. If either is null, the function skips it. This conditional logic naturally absorbs differences in list lengths.
6. **What to return**: The node after the dummy head, `dummy.next`, is the head of the result list. The function returns this node.

## Prerequisites

### What is a ListNode?

A ListNode is a class that represents a node in a singly linked list. Each node holds an integer value `val` and a reference `next` to the next node. A node whose `next` is `null` marks the end of the list.

```java
public class ListNode {
    int val;              // The single-digit value this node holds
    ListNode next;        // Reference to the next node (null if this is the tail)
    ListNode(int val) {   // Constructor: creates a node with the specified value
        this.val = val;
    }
}
```

### What is a Dummy Head?

A dummy head is a placeholder node placed at the front of a list that holds no meaningful value. This technique eliminates the need to special-case the first node when building a result list. The function adds every node uniformly via `curr.next = new ListNode(...)`, and at the end, `dummy.next` retrieves the actual head node.

```java
ListNode dummy = new ListNode(0);  // Create the dummy head
ListNode curr = dummy;             // curr is a pointer that tracks the tail of the list
curr.next = new ListNode(5);       // Append a node with value 5 after the dummy
curr = curr.next;                  // Advance curr to the tail
// dummy.next points to the actual head of the list (the node with value 5)
```

### What is a Carry?

A carry is the value carried over to the next digit when the sum of two single digits is 10 or greater. The function computes the carry as `sum / 10` (integer division yields either 0 or 1). The value remaining at the current digit is `sum % 10`.
Example: 7 + 8 = 15, so carry = 15 / 10 = 1, and the current digit's value = 15 % 10 = 5.

## Complexity

| | Value |
|---|---|
| Time | O(max(n, m)) — The function traverses both lists up to the length of the longer one |
| Space | O(max(n, m)) — The result list contains at most max(n, m) + 1 nodes |

## Code

```java
// Input: reverse-order linked lists l1 and l2 (each node holds a single non-negative digit)
// Output: the sum of the two numbers as a reverse-order linked list
public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
    // Create a dummy head to avoid special-casing the first node of the result list
    // The dummy head is not included in the final result; dummy.next becomes the actual head
    ListNode dummy = new ListNode(0);
    // curr is a pointer that tracks the tail of the result list
    ListNode curr = dummy;
    // Variable to hold the carry; when a per-digit sum is 10 or greater, this carries over to the next digit (0 or 1)
    int carry = 0;

    // Continue looping as long as either list has remaining nodes or a carry exists
    // The carry != 0 condition handles cases like 999 + 1 = 1000 where the result has more digits
    while (l1 != null || l2 != null || carry != 0) {
        // Initialize sum with the carry from the previous digit
        int sum = carry;

        // If l1 has remaining nodes, add its value to sum and advance the pointer
        // If l1 is null, skip this step so processing continues even after l1 is exhausted
        if (l1 != null) {
            sum += l1.val;
            l1 = l1.next;
        }

        // If l2 has remaining nodes, add its value to sum and advance the pointer
        // If l2 is null, skip this step so processing continues even after l2 is exhausted
        if (l2 != null) {
            sum += l2.val;
            l2 = l2.next;
        }

        // Compute the carry: 1 if sum is 10 or greater, 0 otherwise
        carry = sum / 10;
        // Create a new node with the current digit's value (sum % 10) and append it to the tail of the result list
        curr.next = new ListNode(sum % 10);
        // Advance curr to the tail so the next iteration can append a new node
        curr = curr.next;
    }

    // The node after the dummy head is the head of the result list
    return dummy.next;
}
```
