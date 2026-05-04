# Finding the Minimum Jumps to Reach the End

## Problem

The system gives you an integer array `nums`, where each element `nums[i]` represents the maximum number of positions you can jump forward from that position. You start at index 0 and must return the **minimum number of jumps** required to reach the last index. The problem guarantees that you can always reach the end.

## Key Insight

The algorithm treats each jump as a "window of reachable positions from one jump." It increments the jump count by 1 each time you reach the window's boundary. By scanning through the current window and recording the farthest reachable point for the next window, the algorithm achieves the same effect as BFS level-order traversal in O(1) space.

## Thought Process

1. **BFS solves minimum-count problems**: If you treat each position as a node and the jumpable range as edges, the problem becomes a shortest-path problem from index 0 to the last index. BFS explores level by level, so the first level that reaches the end gives the minimum number of jumps.
2. **Windows represent BFS levels**: Standard BFS uses a queue and consumes O(n) space. However, in an array jump problem, the reachable range at each level forms a contiguous interval, so the variable `currentEnd` alone can represent the current level.
3. **The algorithm tracks the farthest reachable point within the window**: While scanning the current window (from the previous `currentEnd` to the current `currentEnd`), the algorithm records the maximum of `i + nums[i]` for each position `i` in the variable `farthest`. This value becomes the end of the next window.
4. **The algorithm finalizes a jump at the window boundary**: When index `i` reaches `currentEnd`, the current window is exhausted. At this point, the algorithm increments the jump count by 1 and updates `currentEnd` to `farthest` to transition to the next window.
5. **The loop runs up to the second-to-last index**: By iterating with `i < nums.length - 1`, the algorithm prevents counting an extra jump when it reaches the last index. Since the problem guarantees that the end is reachable, no explicit reachability check is needed.
6. **The method returns the result**: After the loop finishes, the method returns the minimum jump count accumulated in the variable `jumps`.

## Prerequisites

### Greedy BFS (Greedy Breadth-First Search)

BFS (Breadth-First Search) is an algorithm that finds the shortest path from a starting node to every other node in a graph. It normally uses a queue, but in array jump problems, the reachable range forms a contiguous interval, so a greedy approach that only manages interval boundaries produces the same result. By greedily selecting the farthest reachable point at each level (one jump), the algorithm determines the minimum number of jumps.

### Math.max

`Math.max` is a standard Java method that returns the larger of two integers. The algorithm uses it to compare the current farthest reachable point with a newly computed reachable point and to keep the farther one.

```java
Math.max(3, 7);       // Returns the larger of the two values → 7
Math.max(farthest, i + nums[i]);  // Compares the current farthest point with the new reachable point
```

### Window (Jump Range)

A window is the contiguous range of indices reachable by one jump. The variable `currentEnd` represents the right boundary of the window. When `i` reaches `currentEnd`, the current window is exhausted, and the next jump is required.
Example: For `nums = [2,3,1,1,4]`, the first window is `[1,2]` (up to 2 positions ahead from index 0), and the next window is `[3,4]` (up to the farthest reachable point 4 within the previous window).

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm scans the array only once |
| Space | O(1) — The algorithm uses only 3 variables and requires no additional data structures |

## Code

```java
// Input: integer array nums (each element represents the max jump length from that position)
// Output: returns an int representing the minimum number of jumps to reach the last index
public int jump(int[] nums) {
    // Variable to record the number of jumps. Incremented by 1 each time the window boundary is reached
    int jumps = 0;
    // Right boundary of the current jump window. Initialized to 0 because the starting position is index 0
    int currentEnd = 0;
    // Farthest index reachable from within the window. Used to determine the right boundary of the next window
    int farthest = 0;

    // Scan up to the second-to-last index. Once the end is reached, the goal is achieved and no further jump is needed
    for (int i = 0; i < nums.length - 1; i++) {
        // i + nums[i] is the destination index when making the maximum jump from position i
        // Update farthest if this value exceeds the current farthest
        farthest = Math.max(farthest, i + nums[i]);

        // When the right boundary of the current window is reached, the next jump is needed
        if (i == currentEnd) {
            // Increment the jump count by 1
            jumps++;
            // Set the right boundary of the next window to farthest. The next window spans from currentEnd+1 to the new currentEnd
            currentEnd = farthest;
        }
    }
    // Return the accumulated minimum number of jumps
    return jumps;
}
```
