# Finding the Longest Palindromic Substring

## Problem

Given a string `s`, find and return the **longest substring that reads the same forwards and backwards (palindrome)**. If multiple palindromes of the same length exist, you may return any one of them.

## Key Insight

Every palindrome has a "center." By expanding outward from each position in the string and continuing as long as characters match, you can discover all palindromes without missing any. You need to try two types of centers: a single character (odd-length) and the gap between two adjacent characters (even-length).

## Thought Process

1. **A palindrome has a symmetric structure that expands from its center**: The palindrome `"racecar"` expands symmetrically from the center character `e` outward as `c→a→r`. By fixing a center and expanding left and right, you can detect palindromes using this property.
2. **There are two types of center candidates**: An odd-length palindrome (e.g., `"aba"`) has a single character as its center, and an even-length palindrome (e.g., `"abba"`) has the gap between two adjacent characters as its center. You must try both types of centers to detect all palindromes.
3. **Define the expansion procedure**: Place pointers `left` and `right` at the center, and expand `left` one step to the left and `right` one step to the right as long as `s.charAt(left) == s.charAt(right)`. Stop expanding when the characters no longer match or you reach the boundary of the string.
4. **Calculate the palindrome length from the expansion result**: When expansion terminates, `left` and `right` have each moved one position beyond the palindrome boundary. Therefore, you can calculate the palindrome length as `right - left - 1`.
5. **Record the start and end positions of the longest palindrome**: If the palindrome length obtained from each center exceeds the current longest, update the start position `start` and end position `end`. Given center position `i` and palindrome length `len`, you can calculate `start = i - (len - 1) / 2` and `end = i + len / 2`.
6. **Return the substring at the end**: After trying all centers, extract and return the longest palindromic substring using `s.substring(start, end + 1)`.

## Prerequisites

### What Is a Palindrome?

A palindrome is a string that reads the same forwards and backwards. `"aba"`, `"abba"`, and `"racecar"` are palindromes. A single-character string is also a palindrome.

### What Is the Expand Around Center Technique?

The expand around center technique fixes the center of a palindrome and expands one character at a time in both directions to determine whether the substring is a palindrome. Because it compares characters from the center outward, it detects palindromes efficiently.

```java
// When left=right, it detects an odd-length palindrome (single-character center)
// When left=i and right=i+1, it detects an even-length palindrome (two-character center)
expand(s, 2, 2);    // Search for an odd-length palindrome centered at index 2
expand(s, 2, 3);    // Search for an even-length palindrome centered between index 2 and 3
```

### What Is String.substring(int, int)?

This method extracts a substring from a string. The first argument is the start index (inclusive), and the second argument is the end index (exclusive).

```java
String s = "babad";
s.substring(0, 3);   // Returns "bab" (characters at index 0, 1, 2)
s.substring(1, 4);   // Returns "aba" (characters at index 1, 2, 3)
```

### What Is String.charAt(int)?

This method returns the character at the specified index in a string.

```java
String s = "babad";
s.charAt(0);   // Returns 'b'
s.charAt(2);   // Returns 'b'
```

## Complexity

| | Value |
|---|---|
| Time | O(n²) — Each index serves as a center with up to O(n) expansion, and there are n centers |
| Space | O(1) — The algorithm uses only variables to store pointers and lengths, requiring no additional data structures |

## Code

```java
// Input: String s
// Output: Return the longest palindromic substring in s as a String

// Helper method that expands from the center and returns the palindrome length
private int expand(String s, int left, int right) {
    // Continue expanding as long as the left and right characters match and stay within bounds
    while (left >= 0
            && right < s.length()
            && s.charAt(left)
            == s.charAt(right)) {
        left--;  // Expand one step to the left
        right++; // Expand one step to the right
    }
    // When expansion ends, left and right have each moved one position beyond the palindrome boundary
    // Therefore, the palindrome length is right - left - 1
    return right - left - 1;
}

public String longestPalindrome(String s) {
    // Variables to record the start and end indices of the longest palindrome
    // The initial value 0 corresponds to the fact that at minimum, the first character itself is a palindrome of length 1
    int start = 0, end = 0;

    // Scan each index i as a candidate center of a palindrome
    for (int i = 0; i < s.length(); i++) {
        // Expand an odd-length palindrome (single-character center) and get its length
        int odd = expand(s, i, i);
        // Expand an even-length palindrome (two-character center) and get its length
        int even = expand(s, i, i + 1);
        // Take the larger of the odd-length and even-length results
        int len = Math.max(odd, even);

        // If the length exceeds the current longest palindrome length (end - start + 1), update the start and end positions
        if (len > end - start + 1) {
            // (len - 1) / 2 is the distance from the center to the left side
            start = i - (len - 1) / 2;
            // len / 2 is the distance from the center to the right side
            end = i + len / 2;
        }
    }
    // The second argument of substring is exclusive, so specify end + 1 to include the character at end
    return s.substring(start, end + 1);
}
```
