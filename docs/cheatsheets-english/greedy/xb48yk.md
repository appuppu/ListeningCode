# Dividing Cards Into Consecutive Groups — Determine Whether Cards Can Be Divided Into Consecutive Groups of a Specified Size

## Problem

The function receives an integer array `hand` (card values) and an integer `groupSize`. It returns a `boolean` indicating whether all cards can be divided into groups where each group consists of `groupSize` **consecutive values**. The function must use every card exactly once with none left over.

## Key Insight

Processing cards greedily from the smallest value uniquely determines which group each card belongs to. The algorithm repeatedly forms a consecutive group starting from the smallest card and removes the used cards. If it successfully uses all cards, the division is possible.

## Thought Process

1. **Check the precondition**: Since the algorithm divides cards into groups of `groupSize`, division is impossible if the total number of cards is not divisible by `groupSize`. Performing this check first eliminates unnecessary processing
2. **Why processing from the smallest card is correct**: The smallest card can only belong to a consecutive group that starts with itself. For example, if the smallest value is 3 and `groupSize` is 3, that card must be in the group [3, 4, 5]. Therefore, the greedy strategy of processing from the smallest value is correct
3. **The algorithm needs to track the occurrence count of each card**: Because the same value can appear multiple times, the algorithm requires a data structure that records the frequency of each value. Additionally, since the algorithm needs to efficiently retrieve the smallest value, a TreeMap with sorted keys is suitable
4. **Group construction procedure**: The algorithm retrieves the smallest key `first` from the TreeMap and checks whether all consecutive values from `first` to `first + groupSize - 1` exist in the TreeMap. If they exist, the algorithm decrements each value's frequency by 1 and removes any value whose frequency reaches 0
5. **When a consecutive value is missing**: If a required value does not exist in the TreeMap during group construction, the algorithm determines that division is impossible and returns `false`
6. **Success after processing all cards**: The algorithm repeats group construction until the TreeMap becomes empty. If all constructions succeed, the algorithm returns `true`

## Prerequisites

### TreeMap

A TreeMap is a Map data structure that always maintains keys in sorted order. Like a HashMap, it stores key-value pairs, but it supports order-based operations (such as retrieving the smallest key) in O(log n) time. Its internal implementation uses a red-black tree (a self-balancing binary search tree).

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();  // Create an empty TreeMap
tm.put(5, 2);           // Store value 2 with key 5
tm.put(3, 1);           // Store value 1 with key 3
tm.firstKey();           // Return the smallest key → 3
tm.containsKey(5);       // Return whether key 5 exists as a boolean → true
tm.get(5);               // Return the value associated with key 5 → 2
tm.remove(3);            // Remove key 3 and its value
```

### getOrDefault

The `getOrDefault` method retrieves a value from a Map and returns a specified default value if the key does not exist. It eliminates the need for `null` checks when counting frequencies.

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();
tm.getOrDefault(10, 0);  // Key 10 does not exist, so it returns the default value 0 → 0
tm.put(10, 3);
tm.getOrDefault(10, 0);  // Key 10 exists, so it returns its value → 3
```

### Greedy Algorithm

A greedy algorithm makes the locally optimal choice at each step to find the overall optimal solution. In this problem, the greedy choice of "forming groups starting from the smallest card" leads to a correct overall division. Because the smallest card cannot be placed in the middle of any other group, the greedy choice coincides with the optimal solution.

## Complexity

| | Value |
|---|---|
| Time | O(n log n) — Each insertion and deletion in the TreeMap takes O(log n), and the algorithm processes all n cards |
| Space | O(n) — The TreeMap stores at most n entries |

## Code

```java
// Input: integer array hand (card values) and integer groupSize (size of each group)
// Output: return true if all cards can be divided into consecutive-value groups, false otherwise
public boolean isNStraightHand(int[] hand, int groupSize) {
    // Division into equal groups is impossible if the total number of cards is not divisible by groupSize
    if (hand.length % groupSize != 0)
        return false;

    // TreeMap where key = card value, value = remaining count (frequency)
    // Reason for using TreeMap: it retrieves the smallest card value in O(log n)
    TreeMap<Integer, Integer> tm = new TreeMap<>();
    // Count the occurrence of each card, using getOrDefault to add 1 to the existing frequency
    for (int card : hand) {
        tm.put(card, tm.getOrDefault(card, 0) + 1);
    }

    // Construct groups until the TreeMap becomes empty (an empty TreeMap means all cards have been divided)
    while (!tm.isEmpty()) {
        // Retrieve the current smallest card value and use it as the start of a group
        // The smallest value cannot be placed in the middle of another group, so it must start a new group
        int first = tm.firstKey();

        // Form a group of groupSize consecutive values starting from first
        for (int i = 0; i < groupSize; i++) {
            int cur = first + i;

            // If a consecutive value does not exist, the group cannot be formed, so division is impossible
            if (!tm.containsKey(cur))
                return false;

            // If the frequency is 1, this is the last card of that value so remove it; otherwise decrement the frequency by 1
            if (tm.get(cur) == 1) {
                tm.remove(cur);
            } else {
                tm.put(cur, tm.get(cur) - 1);
            }
        }
    }

    // All cards have been successfully divided into consecutive groups
    return true;
}
```
