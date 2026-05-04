# Finding How Many Days Until a Warmer Temperature

## Problem

The system receives an integer array `temperatures`. For each day, the system calculates how many days in the **future** until a warmer temperature occurs and returns the results as an array. If no warmer day exists in the future, the answer for that day is `0`.

## Key Insight

When the system pushes indices onto a monotonically decreasing stack, the stack retains only the days that have not yet found a warmer day. When a new day's temperature exceeds the temperature of the day on top of the stack, the difference in indices directly gives the number of waiting days.

## Thought Process

1. **The system needs to find the "next warmer day" for each day**: A naive approach would linearly scan rightward from each day, but that results in O(n²). The system needs a mechanism to efficiently manage the "unresolved state" of each day.
2. **The system should track "days whose answer has not been determined yet"**: When scanning the array from left to right, the system can hold days that have not yet found a warmer future day as "unresolved days" and resolve them in bulk when a new warmer day arrives.
3. **The system manages unresolved days with a stack**: The system pushes indices onto the stack. When a new day's temperature exceeds the temperature of the day on top of the stack, the answer for that unresolved day is determined. The stack always maintains monotonically decreasing temperatures from bottom to top (lower temperatures sit on top).
4. **The system computes the answer as the difference in indices**: When current day `i` resolves unresolved day `j`, the number of waiting days is `i - j`. The system stores this difference at position `j` in the result array.
5. **Each element undergoes at most one push and one pop**: The system pushes each element onto the stack once and pops it at most once, so the total number of operations including the while loop stays at O(n).

## Prerequisites

### Stack

A stack is a last-in, first-out (LIFO) data structure. The system removes the most recently added element first. In Java, the `Stack<Integer>` class provides this functionality.

```java
Stack<Integer> stack = new Stack<>();  // Create an empty stack
stack.push(5);          // Push 5 onto the top of the stack
stack.peek();           // Return the top element without removing it → 5
stack.pop();            // Remove and return the top element → 5
stack.isEmpty();        // Return whether the stack is empty as a boolean → true
```

### Monotonic Stack

A monotonic stack is a stack that maintains its elements in either monotonically increasing or monotonically decreasing order. This problem uses a **monotonically decreasing stack**. Before adding a new element, the system pops all elements that would violate the monotonic order, thereby preserving monotonicity. This pattern applies to "finding the next greater (or smaller) element" problems.

```java
// Basic pattern of a monotonically decreasing stack
// Temperatures in the stack decrease from bottom to top
// Example: stack bottom [75, 71, 69] top ← temperatures are decreasing
// When 72 arrives, the system pops 69 and 71 to resolve them, resulting in [75, 72]
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — Each element undergoes at most one push and one pop on the stack, so the overall operations total O(n) |
| Space | O(n) — The stack stores at most n indices |

## Code

```java
// Input: integer array temperatures (the temperature for each day)
// Output: return an int[] storing the number of days until the next warmer day for each day
public int[] dailyTemperatures(int[] temperatures) {
    // Create the result array (Java initializes int[] values to 0, so days with no future warmer day default to 0)
    int[] result = new int[temperatures.length];
    // Stack to store indices of days that have not yet found a warmer day
    // The system stores indices rather than temperature values because computing waiting days requires index differences, and the system can look up temperatures via temperatures[index]
    Stack<Integer> indexStack = new Stack<>();

    // Scan the array from index i = 0 to the end, one element at a time
    for (int i = 0; i < temperatures.length; i++) {
        // While the current temperature exceeds the temperature of the day on top of the stack, resolve unresolved days
        // Condition: the stack is not empty AND the current temperature > the temperature at the index on top of the stack
        while (!indexStack.isEmpty() && temperatures[i] > temperatures[indexStack.peek()]) {
            // Pop the index from the top of the stack
            int stackTopIndex = indexStack.pop();
            // Waiting days = current index - the index of the waiting day
            result[stackTopIndex] = i - stackTopIndex;
        }
        // After the while loop ends (the stack is empty, or the temperature on top of the stack is greater than or equal to the current temperature), push the current index onto the stack
        // At this point, the stack maintains its monotonically decreasing order
        indexStack.push(i);
    }

    // Indices remaining in the stack represent days that had no warmer day in the future
    // The results for these days remain at their initial value of 0, so no additional processing is needed
    return result;
}
```
