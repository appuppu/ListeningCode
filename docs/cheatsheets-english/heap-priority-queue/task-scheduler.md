# Scheduling Tasks With Cooldown Intervals — Finding the Minimum Execution Time for Tasks With Cooldown

## Problem

You are given an array of tasks (represented as characters) and a non-negative integer `n` (the cooldown interval). The same task cannot be re-executed unless at least `n` intervals have passed since its last execution. During cooldown, the CPU remains idle. Return the **minimum number of time units** required to complete all tasks.

## Key Insight

The most frequent task determines the overall structure of the schedule. Whether the total time equals the "formula-based calculation" or the "total number of tasks" depends on whether other tasks can fill the cooldown gaps between the most frequent task. The answer is the larger of the two values.

## Thought Process

1. **The most frequent task becomes the bottleneck**: The cooldown constraint is most restrictive for the task with the highest occurrence count. This task dominates the overall schedule length.
2. **Placing the most frequent task creates gaps**: Let `maxFreq` be the occurrence count of the most frequent task. When you place this task with `n` intervals of spacing, `(maxFreq - 1)` blocks are created between executions. Each block has a length of `(n + 1)` (one task + `n` cooldown slots).
3. **Other tasks fill the gaps**: You place other tasks into the cooldown slots within each block to reduce idle time. If all gaps are filled, no idle time occurs.
4. **The last block requires special handling**: The final execution does not need a cooldown period, so the last block contains only the most frequent task (and any tasks tied with the same frequency). If `maxCount` is the number of tasks that share the maximum frequency, the length of the last block is `maxCount`.
5. **The formula calculates the overall schedule length**: `(maxFreq - 1) * (n + 1) + maxCount` gives the schedule length based on the most frequent task as the axis.
6. **Comparison with the total number of tasks is necessary**: If all gaps are filled and tasks still remain, no idle time is needed at all, and the total number of tasks becomes the answer directly. Therefore, the final answer is `Math.max(formulaResult, tasks.length)`.

## Prerequisites

### Frequency Array

A frequency array is a technique that uses a fixed-size array to count the occurrences of each character. When the input contains only uppercase English letters, an array of size 26 covers all characters. A frequency array is faster and more memory-efficient than a HashMap.

```java
int[] freq = new int[26];            // Initialize 26 counters (A–Z) to 0
freq['B' - 'A']++;                   // Increment the occurrence count of 'B' (index 1)
freq['B' - 'A'];                     // Retrieve the occurrence count of 'B' → 1
```

### Math.max

`Math.max` is a method that returns the larger of two values. You use it when selecting the answer from two candidates.

```java
Math.max(10, 7);    // → 10 (returns the larger value)
Math.max(5, 12);    // → 12
```

### Block Structure in This Problem

Suppose the most frequent task is `A` (occurring 3 times) and `n = 2`. The schedule forms the following block structure:

```
[A _ _] [A _ _] [A]
 Block1   Block2  Last
```

Each `_` represents a cooldown slot, which is filled by another task or remains idle. The last block does not require cooldown, so it contains only `A`.

## Complexity

| | Value |
|---|---|
| Time | O(k) — The algorithm scans the task array once and iterates over the fixed-length array of size 26 a constant number of times (k is the number of tasks) |
| Space | O(1) — The algorithm uses only a fixed-length array of size 26 |

## Code

```java
// Input: char array tasks (each character represents a task) and non-negative integer n (cooldown interval)
// Output: Return the minimum number of time units required to complete all tasks as an int
public int leastInterval(char[] tasks, int n) {
    // Frequency array to count occurrences of each task (A–Z). freq[0] corresponds to 'A', freq[1] to 'B'
    int[] freq = new int[26];
    // Scan the tasks array and convert each character to an index (0–25) using t - 'A', then increment the count
    for (char t : tasks)
        freq[t - 'A']++;

    // Find the maximum occurrence count. This value determines the number of blocks in the schedule
    int maxFreq = 0;
    for (int f : freq)
        maxFreq = Math.max(maxFreq, f);

    // Count how many tasks share the maximum occurrence count. This value becomes the number of tasks in the last block
    int maxCount = 0;
    for (int f : freq)
        if (f == maxFreq) maxCount++;

    // Calculate the schedule length using the formula based on the block structure
    // (maxFreq - 1): the number of blocks that require cooldown
    // (n + 1): the length of each block (one task + n cooldown slots)
    // maxCount: the length of the last block (contains only tasks tied for the maximum frequency)
    int formulaResult =
        (maxFreq - 1) * (n + 1)
        + maxCount;

    // formulaResult: the schedule length when idle time due to cooldown occurs
    // tasks.length: the schedule length when no idle time is needed (all gaps are filled and tasks remain)
    // The larger of the two values is the correct answer
    return Math.max(formulaResult,
        tasks.length);
}
```
