# Checking if a String is a Palindrome

## Problem

You are given a string `s`. You need to determine whether the string is a palindrome (reads the same forward and backward), considering only alphanumeric characters and ignoring differences between uppercase and lowercase letters. Return `true` if it is a palindrome, otherwise return `false`.

## Key Insight

You can advance two pointers inward from both ends of the string, skipping non-alphanumeric characters and comparing one character at a time. This approach determines whether the string is a palindrome in O(1) space without generating any extra strings.

## Thought Process

1. **Confirm the definition of a palindrome**: A palindrome is a string that reads the same forward and backward. In other words, if the first and last characters match, and the inner characters also match in the same manner, then the string is a palindrome.
2. **Comparing from both ends completes the check in a single pass**: You place a pointer `left` at the beginning and a pointer `right` at the end, then advance them inward until they meet. This approach examines each character only once to complete the determination.
3. **You need to skip non-alphanumeric characters**: The problem considers only alphanumeric characters, so when a pointer points to a non-alphanumeric character, you skip it and move to the next position. You can use `Character.isLetterOrDigit` to determine whether a character is alphanumeric.
4. **You convert characters to the same case before comparing**: The problem ignores case differences, so you convert both characters to lowercase using `Character.toLowerCase` before checking for a match.
5. **You return `false` immediately upon finding a mismatch**: If even one pair of characters differs, the string is not a palindrome, so you can return early.
6. **If no mismatch occurs before the pointers cross, the string is a palindrome**: When the loop terminates normally, all corresponding character pairs have matched, so you return `true`.

## Prerequisites

### Two Pointers

The two pointers technique places pointers at both ends of an array or string and moves them inward based on certain conditions. This technique is effective for problems that exploit symmetry (such as palindrome checking and pair searching). It solves problems in a single pass, achieving O(n) time and O(1) space.

```java
int left = 0;                    // Pointer to the beginning
int right = s.length() - 1;     // Pointer to the end
// Continue the loop until left and right cross each other
while (left < right) {
    // Perform comparison or processing
    left++;    // Advance the left pointer to the right
    right--;   // Advance the right pointer to the left
}
```

### Character.isLetterOrDigit

This method determines whether a character is a letter (a-z, A-Z) or a digit (0-9). You use it when you want to exclude non-alphanumeric characters such as spaces and symbols.

```java
Character.isLetterOrDigit('A');   // true (letter)
Character.isLetterOrDigit('3');   // true (digit)
Character.isLetterOrDigit(' ');   // false (space)
Character.isLetterOrDigit(',');   // false (symbol)
```

### Character.toLowerCase

This method converts a letter to its lowercase form. You use it when you want to compare characters without distinguishing between uppercase and lowercase. If the character is already lowercase or is a digit, the method returns it unchanged.

```java
Character.toLowerCase('A');   // 'a'
Character.toLowerCase('a');   // 'a' (no change)
Character.toLowerCase('3');   // '3' (digits remain unchanged)
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — Each pointer traverses the string at most once |
| Space | O(1) — The algorithm uses only two pointers and no additional strings or data structures |

## Code

```java
// Input: String s
// Output: Return true if s is a palindrome, otherwise return false
public boolean isPalindrome(String s) {
    // Place pointers at the beginning and end. These two pointers advance inward from both ends of the string
    int left = 0;
    int right = s.length() - 1;

    // Repeat until the two pointers cross. Once they cross, all comparisons are complete
    while (left < right) {
        // Skip left to the right if it does not point to an alphanumeric character
        // Note: Maintain the left < right condition during skipping to prevent the pointers from crossing
        while (left < right && !Character.isLetterOrDigit(s.charAt(left))) {
            left++;
        }
        // Skip right to the left if it does not point to an alphanumeric character. Maintain left < right similarly
        while (left < right && !Character.isLetterOrDigit(s.charAt(right))) {
            right--;
        }
        // Convert both characters to lowercase before comparing to ignore case differences
        // If they do not match, the string is not a palindrome. Return immediately since even one mismatch breaks the palindrome condition
        if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right))) {
            return false;
        }
        // The two characters match, so advance both pointers inward to compare the next pair of characters
        left++;
        right--;
    }
    // The loop terminated normally (all corresponding character pairs matched), so the string is a palindrome
    return true;
}
```
