# Counting All Palindromic Substrings — Count the total number of palindromic substrings in a string

## Problem

The algorithm receives a string `s` as input. It returns the **total count** of all substrings of `s` that are palindromes (strings that read the same forwards and backwards). The algorithm counts every single-character substring as a palindrome.

## Key Insight

Every palindrome has a "center." By fixing the center and expanding outward in both directions, the algorithm can enumerate all palindromes originating from that center. The total number of center candidates is only 2n−1 — one for each character (odd-length) and one for each gap between adjacent characters (even-length) — so an exhaustive search is feasible.

## Thought Process

1. **Focus on the structural property of palindromes**: Every palindrome is symmetric around its center. An odd-length palindrome has a single character as its center, and an even-length palindrome has a pair of adjacent characters as its center. The algorithm leverages this property to discover palindromes efficiently starting from each center.
2. **Expand outward from the center**: For a given center, the algorithm sets two pointers `left` and `right` and expands outward as long as `s.charAt(left) == s.charAt(right)` holds. Each successful expansion discovers one new palindrome, so the algorithm increments the count by 1.
3. **Handle odd-length and even-length cases separately**: For each index `i`, the algorithm calls `expand(s, i, i)` to count odd-length palindromes and `expand(s, i, i+1)` to count even-length palindromes. These two calls together cover all palindromes centered at `i`.
4. **Define the stopping condition for expansion**: The algorithm stops expanding when `left` drops below 0, when `right` reaches or exceeds the string length, or when the characters at the left and right positions no longer match. This prevents out-of-bounds access while maximizing the expansion.
5. **Sum the results from all centers**: The algorithm adds up the palindrome counts for both odd-length and even-length cases across all indices. The total gives the number of palindromic substrings in the entire string.
6. **Return the final result**: The algorithm returns the total palindrome count accumulated from all centers as the integer `result`.

## Prerequisites

### Palindrome

A palindrome is a string that reads the same forwards and backwards. `"aba"`, `"abba"`, and `"a"` are all palindromes. Palindromes come in two types: odd-length (center is a single character) and even-length (center lies between two characters).

```
Odd-length example:  "aba"  → center is 'b'
Even-length example: "abba" → center is between the two 'b's
```

### Expand Around Center

Expand Around Center is a technique that fixes the center of a palindrome and checks one character at a time in both directions. The algorithm continues expanding outward as long as the characters match and stops as soon as they differ.

```
String: "abacd"
Expand from center i=1 ('b'):
  left=1, right=1 → 'b'=='b' → found palindrome "b", count=1
  left=0, right=2 → 'a'=='a' → found palindrome "aba", count=2
  left=-1 → out of bounds, stop
```

### String.charAt(int index)

This method returns the character at the specified index in a string. The index starts at 0.

```java
String s = "abc";
s.charAt(0);    // returns 'a'
s.charAt(2);    // returns 'c'
s.length();     // returns the length of the string → 3
```

## Complexity

| | Value |
|---|---|
| Time | O(n²) — The algorithm performs up to O(n) expansion for each of the n centers |
| Space | O(1) — The algorithm uses only pointers and a counter, with no additional data structures |

## Code

```java
// Input: string s
// Output: the total number of palindromic substrings in s, returned as an integer

// Expand outward from the given center and return the number of palindromes found
// When left and right are the same value, the method searches for odd-length palindromes;
// when they are adjacent values, it searches for even-length palindromes
int expand(String s, int left, int right) {
    int count = 0;
    // Expand while all 3 conditions hold: left is in bounds, right is in bounds, characters match
    while (left >= 0 && right < s.length()
            && s.charAt(left) == s.charAt(right)) {
        count++;   // s.substring(left, right+1) is a new palindrome, so increment the count
        left--;    // expand one position to the left
        right++;   // expand one position to the right
    }
    // Return the total number of palindromes found from this center
    return count;
}

int countSubstrings(String s) {
    // Variable to accumulate the number of palindromes found from all centers
    int result = 0;

    // Iterate over each index as a candidate center
    for (int i = 0; i < s.length(); i++) {
        // Odd-length palindromes: start expanding from a single-character center at left=i, right=i
        result += expand(s, i, i);
        // Even-length palindromes: start expanding from an adjacent-character center at left=i, right=i+1
        result += expand(s, i, i + 1);
    }
    // Return the total palindrome count accumulated from all centers
    return result;
}
```
