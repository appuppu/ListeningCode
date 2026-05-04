# Scheduling Tasks With Cooldown Intervals — Finding the Minimum Execution Time for Tasks With Cooldown

## Problem

You are given an array of tasks (represented as characters) and a non-negative integer `n` (the cooldown interval). The same task cannot be re-executed unless at least `n` intervals have passed since its last execution. The CPU remains idle during the cooldown period. Return the **minimum number of time units** required to complete all tasks.

## Key Insight

The most frequent task determines the backbone of the entire schedule. Whether the total time equals the "formula-based calculation" or the "total number of tasks" depends on whether other tasks can fill the cooldown gaps between the most frequent task. The answer is the larger of the two values.

## Thought Process

1. **The most frequent task becomes the bottleneck**: The cooldown constraint is most restrictive for the task with the highest occurrence count. This task dictates the overall schedule length.
2. **Placing the most frequent task creates gaps**: Let `maxFreq` be the occurrence count of the most frequent task. When you place this task with `n` intervals between each occurrence, `(maxFreq - 1)` blocks are created between executions. Each block has a length of `(n + 1)` (one task + `n` cooldown slots).
3. **Other tasks fill the gaps**: You place other tasks into the cooldown slots within each block to reduce idle time. If all gaps are filled, no idle time occurs.
4. **The last block requires special handling**: The last execution does not need a cooldown, so the last block contains only the most frequent task (and any tasks tied with it). If `maxCount` is the number of tasks that share the maximum frequency, then the last block has a length of `maxCount`.
5. **The formula calculates the total schedule length**: `(maxFreq - 1) * (n + 1) + maxCount` gives the schedule length based on the most frequent task.
6. **You must compare the formula result with the total number of tasks**: If all gaps are filled and tasks still remain, no idle time is needed and the total number of tasks becomes the answer. Therefore, the final answer is `Math.max(formulaResult, tasks.length)`.

## Prerequisites

### Frequency Array

A frequency array is a technique that uses a fixed-size array to count the occurrences of each character. When the input contains only uppercase English letters, an array of size 26 covers all characters. A frequency array is faster and more memory-efficient than a HashMap.

```java
int[] freq = new int[26];            // Initialize 26 counters (A–Z) to 0
freq['B' - 'A']++;                   // Increment the occurrence count of 'B' (index 1)
freq['B' - 'A'];                     // Retrieve the occurrence count of 'B' → 1
```

### Math.max

`Math.max` is a method that returns the larger of two values. You use it to select the answer from two candidates.

```java
Math.max(10, 7);    // → 10 (returns the larger value)
Math.max(5, 12);    // → 12
```

### Block Structure in This Problem

If the most frequent task is `A` (with 3 occurrences) and `n = 2`, the schedule forms the following block structure:

```
[A _ _] [A _ _] [A]
 Block1   Block2  Last
```

Each `_` is a cooldown slot that holds either another task or an idle unit. The last block does not require a cooldown, so it contains only `A`.

## Complexity

| | Value |
|---|---|
| Time | O(k) — The algorithm scans the task array once and iterates over the fixed-size array of 26 elements a constant number of times (k is the number of tasks) |
| Space | O(1) — The algorithm uses only a fixed-size array of 26 elements |

## Code

```java
// Input: char array tasks (each task is an uppercase letter 'A'–'Z') and non-negative integer n (cooldown interval)
// Output: return the minimum number of time units required to complete all tasks as an int
public int leastInterval(char[] tasks, int n) {
    // Create a frequency array of size 26. freq[0] corresponds to 'A', freq[1] to 'B', and so on
    int[] freq = new int[26];
    // Scan tasks and convert each character to an index 0–25 using t - 'A', then increment the count
    for (char t : tasks)
        freq[t - 'A']++;

    // Scan the freq array to find the maximum occurrence count. maxFreq determines the number of blocks in the schedule
    int maxFreq = 0;
    for (int f : freq)
        maxFreq = Math.max(maxFreq, f);

    // Count the number of tasks whose occurrence count equals maxFreq. maxCount is the number of tasks in the last block
    int maxCount = 0;
    for (int f : freq)
        if (f == maxFreq) maxCount++;

    // (maxFreq - 1): the number of blocks that require a cooldown
    // (n + 1): the length of each block (one task + n cooldown slots)
    // maxCount: the length of the last block (contains only the tasks tied for the highest frequency)
    int formulaResult =
        (maxFreq - 1) * (n + 1)
        + maxCount;

    // formulaResult is the length when idle time occurs due to cooldowns
    // tasks.length is the length when no idle time is needed (all gaps are filled and tasks remain)
    // The larger of the two values is the correct answer
    return Math.max(formulaResult,
        tasks.length);
}
```
