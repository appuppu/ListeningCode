# Finding the Minimum Meeting Rooms Required — Find the minimum number of meeting rooms required to hold all meetings without conflicts

## Problem

You are given an array of meeting time intervals (start time and end time). Return the **minimum number of meeting rooms** required to hold all meetings without conflicts. Meetings that overlap in time must use separate meeting rooms.

## Key Insight

If you process meeting starts and ends as separate events in chronological order, you can determine the maximum number of meetings occurring simultaneously at any moment. That maximum number is the required number of meeting rooms.

## Thought Process

1. **The number of concurrent meetings is the answer**: The maximum number of meetings in progress at any moment = the required number of meeting rooms. The problem reduces to efficiently finding the maximum number of concurrent meetings.
2. **Treat starts and ends as separate events**: A meeting start requires one room, and a meeting end frees one room. By separating starts and ends and sorting each independently, you can process events in chronological order.
3. **Sweep through two sorted arrays**: Sort the starts array and the ends array separately, then iterate through the starts array from the beginning. For each start time, determine whether it occurs before the earliest end time to decide whether a room is needed or freed.
4. **Track the number of concurrent meetings with two pointers**: Prepare a pointer `i` for the starts array and a pointer `endPtr` for the ends array. If `starts[i] < ends[endPtr]`, the new meeting overlaps with an existing meeting, so add a room. Otherwise, one meeting has ended and a room is freed, so advance `endPtr`.
5. **Record the maximum value**: Throughout the sweep, continuously record the maximum value of `rooms` in `maxRooms`. Return `maxRooms` after the sweep completes.

## Prerequisites

### What is Arrays.sort

Arrays.sort is a standard Java method that sorts an array in ascending order. For primitive type arrays, it uses dual-pivot quicksort (O(n log n)).

```java
int[] arr = {5, 2, 8, 1};
Arrays.sort(arr);        // arr becomes {1, 2, 5, 8}
```

### What is Two Pointer

Two Pointer is a technique that uses two index variables to traverse arrays independently. By applying it to sorted arrays, you can efficiently compare and merge elements from two arrays.

```java
int i = 0;          // Pointer for the first array
int endPtr = 0;     // Pointer for the second array
// Decide which pointer to advance based on the condition
```

### What is Event Sweep

Event Sweep is a technique that processes events (starts and ends) on a timeline in chronological order and tracks the state at any given point (such as the number of concurrent activities). By incrementing a counter at start events and decrementing it at end events, you can determine the number of concurrent activities at any moment.

## Complexity

| | Value |
|---|---|
| Time | O(n log n) — Sorting the two arrays dominates the runtime |
| Space | O(n) — The algorithm creates two arrays to store start times and end times |

## Code

```java
// Input: A 2D integer array intervals representing meeting time intervals (each element is [start, end])
// Output: Return an int representing the minimum number of meeting rooms required to hold all meetings without conflicts
public int minMeetingRooms(int[][] intervals) {
    // If the input is null or empty, no meetings exist, so return 0
    if (intervals == null || intervals.length == 0)
        return 0;

    int n = intervals.length;
    // Separate starts and ends so that each can be sorted independently
    int[] starts = new int[n];  // Array to store start times
    int[] ends = new int[n];    // Array to store end times

    // Iterate through intervals and store start times and end times in separate arrays
    for (int i = 0; i < n; i++) {
        starts[i] = intervals[i][0];
        ends[i] = intervals[i][1];
    }

    // Sort both arrays in ascending order to prepare for processing events in chronological order
    Arrays.sort(starts);
    Arrays.sort(ends);

    int rooms = 0, maxRooms = 0;
    // Pointer for the ends array, pointing to the earliest ending meeting
    int endPtr = 0;

    // Iterate through the starts array from the beginning. Each iteration represents a "new meeting starts" event
    for (int i = 0; i < n; i++) {
        if (starts[i] < ends[endPtr]) {
            // The start time of the current meeting is before the end time of the earliest ending meeting → overlap occurs, so allocate a new room
            rooms++;
        } else {
            // The earliest ending meeting has already finished, so its room can be reused. Do not increase the room count; advance endPtr to point to the next earliest ending meeting
            endPtr++;
        }
        // Update the maximum number of rooms used simultaneously
        maxRooms = Math.max(maxRooms, rooms);
    }
    // maxRooms is the maximum number of rooms used simultaneously, which is the minimum number of meeting rooms required
    return maxRooms;
}
```
