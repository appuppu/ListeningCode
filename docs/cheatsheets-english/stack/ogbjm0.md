# Counting Car Fleets Arriving at a Destination

## Problem

Given an integer `target` (the destination position), an integer array `position` (each car's current position), and an integer array `speed` (each car's speed), all cars are driving toward the same destination. When a faster car catches up to a slower car ahead, it matches the slower car's speed and they travel together as one fleet. Return the **number of fleets** that arrive at the destination as an integer.

## Key Insight

If you process cars in order from closest to the destination and manage each car's "arrival time at the destination" using a stack, then a car behind whose arrival time is less than or equal to the car ahead merges into that fleet, while a car with a greater arrival time forms a new fleet. The final size of the stack equals the number of fleets.

## Thought Process

1. **Determine fleet formation by comparing arrival times**: Whether a car behind catches up to the car ahead depends on their arrival times at the destination. If the behind car's arrival time is less than or equal to the ahead car's arrival time, the behind car catches up midway and joins the same fleet. You can calculate arrival time as `(target - position[i]) / speed[i]`
2. **Process cars from closest to the destination first**: Fleet merging depends on whether the car ahead (closer to the destination) acts as a wall. Sorting and processing cars in order of proximity to the destination allows you to evaluate each behind car against the ahead car's arrival time as the reference
3. **Sort an index array instead of the original arrays**: Since position and speed are separate arrays, create an index array and sort it in descending order of `position` (closest to destination first). This preserves the original arrays while allowing you to reference the corresponding position and speed values
4. **Use a stack to manage fleets**: The top of the stack holds the arrival time of the most recent fleet (i.e., the arrival time of that fleet's leading car). If a new car's arrival time is less than or equal to the stack's top, that car merges into the preceding fleet, so you do not push it onto the stack. If the arrival time is greater than the top, a new fleet forms, so you push it onto the stack
5. **The stack size is the answer**: Merged cars are not added to the stack, and only cars that form new fleets are pushed. Therefore, the final number of elements in the stack directly equals the number of fleets

## Prerequisites

### Calculating Arrival Time

When a car's current position is `pos`, its speed is `speed`, and the destination is `target`, the arrival time is `(target - pos) / speed`. A smaller value means the car arrives earlier.

```
Example: target=12, pos=10, speed=2
Arrival time = (12 - 10) / 2 = 1.0
```

### Custom Sorting with Integer[]

Since a primitive `int[]` cannot be sorted with a lambda expression, you create an `Integer[]` index array and pass a Comparator to `Arrays.sort` for custom sorting.

```java
Integer[] idx = new Integer[n];
for (int i = 0; i < n; i++) idx[i] = i;
// Sort indices in descending order of pos (closest to destination first)
Arrays.sort(idx, (a, b) -> pos[b] - pos[a]);
```

### What is a Stack

A stack is a last-in, first-out (LIFO) data structure. You use `push` to add elements onto the top, `peek` to view the top element without removing it, and `pop` to remove and return it. Here, the stack's top holds the "arrival time of the most recent fleet" and serves as the reference for merge decisions.

```java
Stack<Double> stack = new Stack<>();  // Create an empty stack
stack.push(3.0);    // Push element 3.0 onto the top of the stack
stack.peek();        // View the top element without removing it → 3.0
stack.isEmpty();     // Check whether the stack is empty → false
stack.size();        // Return the number of elements in the stack → 1
```

## Complexity

| | Value |
|---|---|
| Time | O(n log n) — Sorting the index array takes O(n log n), and the subsequent traversal takes O(n) |
| Space | O(n) — The index array and the stack each store up to n elements |

## Code

```java
// Input: integer target (destination position), integer array pos (each car's position), integer array speed (each car's speed)
// Output: return the number of fleets arriving at the destination as an integer
public int carFleet(int target, int[] pos, int[] speed) {
    // Get the number of cars
    int n = pos.length;

    // Create an Integer[] index array and initialize it with values from 0 to n-1
    // Sorting the index array allows you to change the processing order while preserving the original arrays
    Integer[] idx = new Integer[n];
    for (int i = 0; i < n; i++) {
        idx[i] = i;
    }

    // Sort the index array in descending order of position (closest to destination first)
    // Processing cars closest to the destination first enables merge decisions based on the car ahead
    Arrays.sort(idx, (a, b) -> pos[b] - pos[a]);

    // Stack to store the arrival time of each fleet
    // The top of the stack represents the arrival time of the most recently confirmed fleet
    Stack<Double> stack = new Stack<>();

    for (int i : idx) {
        // Calculate this car's arrival time at the destination
        // Cast to double to avoid integer division, which would discard the fractional part
        double time = (double) (target - pos[i]) / speed[i];

        // If the arrival time is less than or equal to the stack's top, this car catches up to the fleet ahead and merges
        // Use continue to skip pushing onto the stack and proceed to the next car
        if (!stack.isEmpty() && time <= stack.peek()) {
            continue;
        }

        // If the stack is empty or time is greater than the top, this car cannot catch the fleet ahead
        // It forms a new fleet, so push its arrival time onto the stack
        stack.push(time);
    }

    // The stack contains one arrival time per fleet, so its size equals the number of fleets
    return stack.size();
}
```
