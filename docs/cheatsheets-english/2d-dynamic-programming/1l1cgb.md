# Finding the Longest Common Subsequence — Find the Length of the Longest Subsequence Common to Two Strings

## Problem

The problem gives you two strings `text1` and `text2`. You must return the **length** of the longest **subsequence** that is common to both strings. A subsequence is a sequence of characters selected from the original string while preserving their relative order; the characters do not need to be contiguous.

## Key Insight

If the last characters of the two strings match, that character belongs to the LCS, and the remaining subproblem becomes both strings shortened by one character. If the last characters do not match, you take the longer result from two subproblems: one where you shorten `text1` by one character and one where you shorten `text2` by one character. You can fill a two-dimensional table bottom-up based on this recursive structure to obtain the optimal solution without redundant computation.

## Thought Process

1. **Define the subproblem**: Define `dp[i][j]` as the LCS length for the first `i` characters of `text1` and the first `j` characters of `text2`. The final answer you want is `dp[m][n]` (where `m` = length of text1, `n` = length of text2).
2. **Transition when the last characters match**: When `text1[i-1] == text2[j-1]`, this character becomes part of the LCS. Therefore `dp[i][j] = dp[i-1][j-1] + 1`. You add 1 to the answer of the subproblem where both strings are shortened by one character.
3. **Transition when the last characters do not match**: When `text1[i-1] != text2[j-1]`, at least one of the last characters is not part of the LCS. You take the larger of the case where you shorten `text1` by one character (`dp[i-1][j]`) and the case where you shorten `text2` by one character (`dp[i][j-1]`). That is, `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`.
4. **Base case**: When either string is empty (length 0), no common subsequence exists, so `dp[0][j] = 0` and `dp[i][0] = 0`. Since Java initializes all elements of `int[][]` to 0, you do not need to set these values explicitly.
5. **Table filling order**: `dp[i][j]` depends on `dp[i-1][j-1]`, `dp[i-1][j]`, and `dp[i][j-1]`. Therefore, if you fill `i` from 1 to m and `j` from 1 to n in ascending order, the referenced cells are always already computed.
6. **Return value**: After filling the entire table, `dp[m][n]` represents the LCS length for the full two strings, and you return this value.

## Prerequisites

### What Is a Subsequence

A subsequence is a sequence obtained by deleting zero or more characters from a string while preserving the relative order of the remaining characters. Unlike a substring, the characters do not need to be contiguous.

```
String: "abcde"
Subsequence example: "ace" (select a, c, e; delete b, d)
Not a subsequence: "aec" (violates the original order a → c → e)
```

### Creating and Initializing a 2D Array

When you declare `new int[m+1][n+1]` in Java, Java creates a two-dimensional array of size `(m+1) × (n+1)` and initializes all elements to 0.

```java
int[][] dp = new int[m + 1][n + 1];  // Create an array of (m+1) rows × (n+1) columns, all elements initialized to 0
dp[i][j] = 5;                         // Assign the value 5 to row i, column j
int val = dp[i][j];                    // Retrieve the value at row i, column j → 5
```

### What Is Math.max

`Math.max` is a method that returns the larger of two integers. You use it to compare the solutions of two subproblems and select the better one.

```java
Math.max(3, 7);    // Return the larger of the two values → 7
Math.max(dp[i-1][j], dp[i][j-1]);  // Compare the values of two cells and return the larger one
```

### What Is charAt

`charAt` is a method that returns the character at a specified position in a string. The index is zero-based.

```java
String s = "abc";
s.charAt(0);    // Return the character at index 0 → 'a'
s.charAt(2);    // Return the character at index 2 → 'c'
```

## Complexity

| | Value |
|---|---|
| Time | O(m × n) — You fill each cell in the m × n table exactly once |
| Space | O(m × n) — You use a two-dimensional array of size (m+1) × (n+1) |

## Code

```java
// Input: two strings text1 and text2
// Output: return the length of the longest common subsequence of the two strings as an int
public int longestCommonSubsequence(String text1, String text2) {
    // Assign the length of text1 to m and the length of text2 to n. Use these for the table size and loop bounds
    int m = text1.length();
    int n = text2.length();

    // dp[i][j] = LCS length for the first i characters of text1 and the first j characters of text2
    // The size is (m+1) × (n+1) to represent the case where either string is empty (base case)
    // Java initializes all elements of int[][] to 0, so the base cases dp[0][j]=0 and dp[i][0]=0 are automatically satisfied
    int[][] dp = new int[m + 1][n + 1];

    // i represents how many characters from the beginning of text1 you are considering
    for (int i = 1; i <= m; i++) {
        // j represents how many characters from the beginning of text2 you are considering
        for (int j = 1; j <= n; j++) {
            // The dp index is 1-based, but the string index is 0-based, so access characters using i-1 and j-1
            if (text1.charAt(i - 1) == text2.charAt(j - 1)) {
                // When the characters match, the matched character joins the LCS, so add 1 to the answer of the subproblem with both strings shortened by one character
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                // When the characters do not match, take the longer LCS from shortening text1 by one character versus shortening text2 by one character
                dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }

    // The bottom-right cell of the table holds the LCS length for the entirety of text1 and text2
    return dp[m][n];
}
```
