# Finding the Starting Gas Station for a Circular Route

## Problem

You are given two integer arrays `gas` and `cost`, each of length `n`. `gas[i]` represents the amount of fuel you gain at station `i`, and `cost[i]` represents the amount of fuel required to travel from station `i` to the next station. Return the index of the starting station from which you can complete one full loop of the circular route. If no such station exists, return `-1`. There is at most one valid solution.

## Key Insight

If the total fuel balance across all stations is non-negative, a valid solution always exists. Any station up to the point where the current fuel balance drops below zero cannot serve as a valid starting point, so you reset at the next station as a new starting candidate. This approach finds the answer in a single pass.

## Thought Process

1. **Consider the fuel balance at each station**: At station `i`, you gain `gas[i]` fuel and consume `cost[i]` fuel, so the net fuel change is `net = gas[i] - cost[i]`. A positive `net` means the station produces a fuel surplus, while a negative `net` means the station causes a fuel deficit.
2. **Determine whether completing the loop is possible**: If the sum of `net` across all stations (`totalBalance`) is non-negative, the total fuel gained across the route is at least as much as the total fuel consumed, so a valid starting point must exist. Conversely, if `totalBalance` is negative, no starting point can provide enough fuel to complete the loop.
3. **Efficiently narrow down starting candidates**: Suppose you depart from station `start` and at some station `i`, the cumulative fuel balance (`currentBalance`) drops below zero. No station between `start` and `i` can be a valid starting point either. This is because the cumulative balance from `start` to any intermediate station `j` was non-negative, so starting from `j` would reach station `i` with even less fuel. Therefore, you can eliminate all stations from `start` through `i` at once and set `i + 1` as the new starting candidate.
4. **Reset currentBalance and continue scanning**: To track the fuel balance from the new starting candidate `i + 1`, you reset `currentBalance` to `0` and update `start` to `i + 1`. The scan itself only needs to run once from beginning to end.
5. **Make the final decision using totalBalance after the scan**: After the scan completes, if `totalBalance >= 0`, a valid solution exists, so you return `start`. If `totalBalance < 0`, completing the loop is impossible, so you return `-1`.

## Prerequisites

### Net Fuel Change

The net fuel change represents the fuel balance at each station. You calculate it as `net = gas[i] - cost[i]`. A positive value means the station yields surplus fuel, and a negative value means the station creates a fuel deficit.

```java
int net = gas[i] - cost[i];  // Calculate the fuel balance at station i
// Example: gas[i]=3, cost[i]=5 → net=-2 (fuel deficit of 2)
// Example: gas[i]=4, cost[i]=1 → net=3 (fuel surplus of 3)
```

### Roles of totalBalance and currentBalance

`totalBalance` is the cumulative fuel balance across the entire route, used to determine whether completing the loop is possible. `currentBalance` is the cumulative fuel remaining from the current starting candidate to the current station, used to determine when to update the starting candidate.

```java
int totalBalance = 0;    // Cumulative fuel balance for the entire route (used to check if completing the loop is possible)
int currentBalance = 0;  // Cumulative fuel remaining from the current starting candidate (used to check if the candidate needs updating)
totalBalance += net;     // Always accumulate for every station
currentBalance += net;   // Reset to 0 each time the starting candidate is updated
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm requires only a single pass through the array |
| Space | O(1) — The algorithm uses only three variables, independent of the input size |

## Code

```java
// Input: integer array gas (fuel gained at each station) and integer array cost (fuel required to travel from each station to the next)
// Output: return the index of the starting station from which you can complete the circular route as an int, or -1 if completing the loop is impossible
public int canCompleteCircuit(int[] gas, int[] cost) {
    // Cumulative fuel balance for the entire route (used for the final check on whether completing the loop is possible)
    int totalBalance = 0;
    // Cumulative fuel remaining from the current starting candidate (used to determine when to reset the candidate)
    int currentBalance = 0;
    // Index of the starting candidate (initialized to 0 and updated on each reset)
    int start = 0;

    // Scan through the array from index 0 to the end, one station at a time
    for (int i = 0; i < gas.length; i++) {
        // Calculate the net fuel change at station i
        int net = gas[i] - cost[i];
        // Always add to the total route fuel balance (used for the final check on whether completing the loop is possible)
        totalBalance += net;
        // Add to the cumulative fuel remaining from the current starting candidate (represents the fuel level upon arriving at station i)
        currentBalance += net;

        // If the cumulative fuel drops below zero, no station from start through i can be a valid starting point
        if (currentBalance < 0) {
            // Reset the cumulative fuel and set the next station as the new starting candidate
            currentBalance = 0;
            start = i + 1;
        }
    }
    // If the total route fuel balance is non-negative, completing the loop is possible so return start; otherwise return -1
    return totalBalance >= 0 ? start : -1;
}
```
