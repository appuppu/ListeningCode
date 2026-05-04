# Finding the Minimum Edits to Transform One String Into Another — Finding the Minimum Edit Distance Between Two Strings

## Problem

You are given two strings `word1` and `word2`. You return the **minimum number of operations** required to convert `word1` into `word2`. The allowed operations are "insert," "delete," and "replace," and each operation counts as one step.

## Key Insight

When you compare two strings from their ends, you can skip the current characters with no operation if they match. If they do not match, you choose the minimum-cost option among "insert," "delete," and "replace." A DP table eliminates the overlap of these subproblems, and because each cell depends only on the current row and the previous row, you can optimize space to a single row.

## Thought Process

1. **Each position has exactly three choices**: When you compare `word1[i]` with `word2[j]`, you advance to `(i+1, j+1)` with no operation if the characters match. If they do not match, you choose the minimum cost among "insert (advance j)," "delete (advance i)," and "replace (advance both)." This recursive structure suggests a DP approach
2. **Define the DP table**: You define `dp[i][j]` as "the minimum number of operations to convert `word1[i:]` into `word2[j:]`." The final answer is `dp[0][0]`
3. **Determine the base cases**: If the remainder of `word1` is empty (`i == m`), you need insertions equal to the remaining length of `word2[j:]`, so `dp[m][j] = n - j`. If the remainder of `word2` is empty (`j == n`), you need deletions equal to the remaining length of `word1[i:]`, so `dp[i][n] = m - i`
4. **Determine the bottom-up fill direction**: Because `dp[i][j]` depends on `dp[i+1][j+1]`, `dp[i][j+1]`, and `dp[i+1][j]`, you fill `i` from `m-1` down to `0` and `j` from `n-1` down to `0`
5. **Optimize the space**: Computing each row `i` requires only "the previous row (`i+1`)" and "the current row (`i`)." Therefore, you do not need a two-dimensional array; two one-dimensional arrays `prev` (previous row) and `curr` (current row) are sufficient. After computing each row, you swap them with `prev = curr`
6. **Return the final result**: After processing all rows, `prev[0]` corresponds to the value of `dp[0][0]`, which is the minimum number of operations to convert the entire `word1` into the entire `word2`

## Prerequisites

### What Is Edit Distance?

Edit distance is a metric that measures the "similarity" between two strings by counting the minimum number of operations required to transform one string into the other. It is also called the Levenshtein distance. The three permitted operations each have a cost of 1:

- **Insert**: You add one character to the string
- **Delete**: You remove one character from the string
- **Replace**: You change one character in the string to a different character

### What Is Bottom-Up DP (Dynamic Programming)?

Bottom-up DP is a technique that solves recursive subproblems by recording results in a table, starting from the smallest subproblems. Unlike memoized recursion (top-down), bottom-up DP has no recursion overhead and is easier to apply space optimization to.

```java
// 1D DP example: compute the Fibonacci sequence using two variables
int a = 0, b = 1;
for (int i = 2; i <= n; i++) {
    int temp = a + b;  // The current value depends only on the two previous values
    a = b;             // Discard the old value and update
    b = temp;
}
```

### What Is Math.min()?

Math.min() is a standard Java method that returns the smaller of two integers. When comparing three or more values, you nest the calls.

```java
Math.min(3, 5);                    // → 3
Math.min(3, Math.min(5, 1));       // → 1 (minimum of three values)
```

### What Is String.charAt(int index)?

charAt() is a method that returns the character at the specified position in a string. The index starts at 0.

```java
String s = "abc";
s.charAt(0);  // → 'a'
s.charAt(2);  // → 'c'
```

## Complexity

| | Value |
|---|---|
| Time | O(m × n) — For each position in `word1`, you scan all positions in `word2` |
| Space | O(n) — You keep only one row instead of a two-dimensional table |

## Code

```java
// Input: two strings word1 (length m) and word2 (length n)
// Output: return the minimum number of operations to convert word1 into word2 as an int
public int minDistance(String w1, String w2) {
    int m = w1.length();  // Get the length of word1
    int n = w2.length();  // Get the length of word2

    // prev array: corresponds to the row below (i+1) in the DP table
    // Initialize prev[j] = n - j: when word1 is empty, you insert all remaining n-j characters of word2[j:]
    int[] prev = new int[n + 1];
    for (int j = 0; j <= n; j++)
        prev[j] = n - j;

    // Scan word1 in reverse from the end to the beginning (i is the current position in word1)
    for (int i = m - 1; i >= 0; i--) {
        // curr array: corresponds to the current row (i) in the DP table
        int[] curr = new int[n + 1];
        // When word2 is empty, you delete all remaining m-i characters of word1[i:]
        curr[n] = m - i;

        // Scan word2 in reverse from the end to the beginning (j is the current position in word2)
        for (int j = n - 1; j >= 0; j--) {
            if (w1.charAt(i) == w2.charAt(j)) {
                // Characters match, so no operation is needed. prev[j+1] is the answer for subproblem dp[i+1][j+1]
                curr[j] = prev[j + 1];
            } else {
                // Characters do not match, so choose the minimum cost among three operations and add 1 for this operation
                curr[j] = 1 + Math.min(
                    curr[j + 1],           // Insert: advance one character on the word2 side (dp[i][j+1])
                    Math.min(prev[j],      // Delete: advance one character on the word1 side (dp[i+1][j])
                        prev[j + 1]));     // Replace: advance one character on both sides (dp[i+1][j+1])
            }
        }
        // Save the current row as the previous row for the next iteration (i-1)
        prev = curr;
    }

    // prev[0] corresponds to dp[0][0], the minimum number of operations to convert all of word1 into all of word2
    return prev[0];
}
```
