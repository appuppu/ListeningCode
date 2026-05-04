# Counting Ways to Decode a Numeric String — Find the total number of ways to convert a numeric string into alphabetic characters

## Problem

You are given a string `s` consisting only of digits. Based on the mapping A=1, B=2, ..., Z=26, return the number of ways to decode the string into a sequence of alphabetic characters. For example, "226" can be decoded in 3 ways: "BZ" (2,26), "VF" (22,6), and "BBF" (2,2,6).

## Key Insight

The number of decoding ways at each position equals the sum of "the number of ways for the remainder after decoding one digit" and "the number of ways for the remainder after decoding two digits." This dependency is limited to only the two immediately preceding results, so two variables are sufficient.

## Thought Process

1. **Each position has at most two choices**: When looking at the digit at position `i`, there are at most two options: decode it as a single digit (1–9) into one character, or decode two digits (10–26) into one character. Because this choice occurs recursively, we need a systematic way to compute the number of decoding ways at each position.
2. **'0' cannot be decoded on its own**: No alphabet letter corresponds to '0'. If the digit at position `i` is '0', a single-digit decode starting at that position is impossible, so the number of ways is 0. The digit '0' can only be decoded by combining it with the preceding digit as 10 or 20.
3. **Formulate the DP recurrence**: Define `dp[i]` as "the number of decoding ways from position `i` to the end." If the digit at position `i` is not '0', add `dp[i+1]` (the remainder after a single-digit decode). Furthermore, if the two digits at positions `i` and `i+1` form a number in the range 10–26, also add `dp[i+2]` (the remainder after a two-digit decode). That is, `dp[i] = dp[i+1] + dp[i+2]` (conditionally).
4. **The dependency is limited to the next two positions only**: `dp[i]` depends only on `dp[i+1]` and `dp[i+2]`. Therefore, there is no need to maintain the entire array — two variables (`next1` = `dp[i+1]`, `next2` = `dp[i+2]`) are sufficient. This achieves O(1) space.
5. **Traverse from the end to the beginning**: Because `dp[i]` depends on `dp[i+1]` and `dp[i+2]`, the values on the right side must be finalized first. Therefore, we loop from the end of the string toward the beginning, computing the number of ways at each position.
6. **What to return at the end**: After the loop completes, `next1` contains `dp[0]` (the number of decoding ways for the entire string). Return this value.

## Prerequisites

### What is Dynamic Programming (DP)?

Dynamic programming is a technique that divides a large problem into smaller subproblems and reuses the results of subproblems to compute the overall answer. To avoid recomputing the same subproblems multiple times, it either stores previously computed results (memoization) or computes them in order (bottom-up).

```java
// Typical bottom-up DP pattern: Fibonacci sequence
int prev2 = 0, prev1 = 1;
for (int i = 2; i <= n; i++) {
    int current = prev1 + prev2;  // Compute the current value using only the two preceding results
    prev2 = prev1;                // Slide the variables forward to prepare for the next iteration
    prev1 = current;
}
// prev1 contains the final result
```

### What is Integer.parseInt?

A method that converts a string to an integer. It is used to evaluate a substring as a numeric value.

```java
Integer.parseInt("26");          // Converts the string "26" to the integer 26 → 26
Integer.parseInt("09");          // Converts the string "09" to the integer 9 → 9
```

### What is String.substring?

A method that extracts a substring from a string within the specified range. The arguments are the start index (inclusive) and end index (exclusive).

```java
String s = "226";
s.substring(0, 2);   // Returns the substring from index 0 to 1 → "22"
s.substring(1, 3);   // Returns the substring from index 1 to 2 → "26"
```

### What is String.charAt?

A method that returns the single character at the specified position in a string. Because it returns a char type, you can compare it with the character '0' to check for a specific digit.

```java
String s = "206";
s.charAt(0);          // Returns the character at index 0 → '2'
s.charAt(1);          // Returns the character at index 1 → '0'
s.charAt(1) == '0';   // Checks whether the character is '0' → true
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm only needs to traverse the string once from end to beginning |
| Space | O(1) — The algorithm uses only two variables (next1, next2) and does not require an array |

## Code

```java
// Input: a string s consisting only of digits
// Output: return the total number of ways to decode string s into alphabetic characters as an int
public int numDecodings(String s) {
    // next1 = number of ways from one position to the right (dp[i+1]), next2 = number of ways from two positions to the right (dp[i+2])
    // Positions beyond the end of the string are defined as "1 way to decode an empty string", so both initial values are 1
    int next1 = 1, next2 = 1;

    // dp[i] depends on dp[i+1] and dp[i+2], so traverse from end to beginning to finalize the right side first
    for (int i = s.length() - 1; i >= 0; i--) {
        int current;

        if (s.charAt(i) == '0') {
            // '0' does not correspond to any alphabet letter, so there are 0 ways to decode starting at this position
            // '0' can only be decoded by combining it with the preceding digit as 10 or 20
            current = 0;
        } else {
            // Single-digit decode: treat the digit at position i (1–9) as one character; the remaining i+1 onward has next1 ways
            current = next1;

            // Check whether a two-digit decode is possible (i+1 must be within the string bounds to extract two digits)
            if (i + 1 < s.length()) {
                // Extract the two-digit substring using s.substring(i, i+2) and convert it to an integer
                int two = Integer.parseInt(
                    s.substring(i, i + 2));
                // If the two digits are in the range 10–26, decode them as one character and add next2 ways for the remainder from i+2 onward
                if (two >= 10 && two <= 26)
                    current += next2;
            }
        }

        // Slide variables one position to the left: the current value becomes next1 (one position to the right) in the next iteration
        next2 = next1;
        next1 = current;
    }

    // After the loop completes, next1 contains the last computed current value (= dp[0])
    // This is the total number of decoding ways for the entire string
    return next1;
}
```
