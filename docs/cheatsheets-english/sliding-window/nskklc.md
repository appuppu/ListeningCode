# Finding the Smallest Window Containing All Characters

## Problem

You are given two strings `s` and `t`. You need to find and return the **shortest substring** of `s` that contains all characters of `t` (including duplicates). If no such substring exists, you return an empty string.

## Key Insight

You expand the window by moving the right pointer to satisfy the condition, then you shrink the window by moving the left pointer to minimize its length. You manage the "number of character types that satisfy the condition" with a single variable, which allows you to determine the window's validity in O(1).

## Thought Process

1. **Count the required frequency of each character in advance**: You record the frequency of each character in `t` using a HashMap. This defines the condition that the window must satisfy. For example, if `t = "ABC"`, the map becomes `{A:1, B:1, C:1}`.
2. **Expand the window to the right to satisfy the condition**: You advance the right pointer `r` one step at a time to add characters to the window, and you track the character frequencies within the window using a separate HashMap. Each time a character type in the window reaches its required frequency, you increment the counter `have`.
3. **Determine condition satisfaction in O(1)**: You set `required` to the size of `need` (the number of distinct character types required), and when `have == required` holds, the window contains all characters of `t`. By managing the count at the character-type level, you eliminate the need to compare all characters each time.
4. **Shrink the window from the left to minimize it**: While `have == required` holds, you advance the left pointer `left` to shrink the window. After each shrink, you compare the window length against the current minimum and update it if the new window is shorter.
5. **Handle the removal of the leftmost character**: When you remove the leftmost character `s.charAt(left)` from the window, if that character exists in `need` and the window's frequency drops below the required frequency, you decrement `have`. This causes the `while` loop to terminate, and execution returns to expanding the right pointer.
6. **Return the final result**: After the traversal completes, if you found a minimum window, you return `s.substring(resStart, resStart + resLen)`. If you did not find one, you return an empty string.

## Prerequisites

### What is a HashMap

A HashMap is a data structure that stores key-value pairs. You can search for and retrieve a value by specifying a key in O(1). In this problem, you use a HashMap to manage the frequency of each character.

```java
HashMap<Character, Integer> map = new HashMap<>();  // Create an empty HashMap
map.put('A', 1);                    // Store value 1 with key 'A'
map.getOrDefault('A', 0);           // Return the value for key 'A'. Return 0 if it does not exist → 1
map.containsKey('A');               // Return a boolean indicating whether key 'A' exists → true
map.get('A').equals(map.get('B'));  // Use equals to compare Integer objects
```

### What is a Sliding Window

A sliding window is a technique that manages a contiguous range (window) over an array or string using two pointers, `left` and `right`. You expand the window with the right pointer and shrink it with the left pointer, which optimizes the O(n²) process of examining all substrings down to O(n).

```java
int left = 0;
for (int r = 0; r < s.length(); r++) {
    // Expand the window with the right pointer
    while (conditionIsSatisfied) {
        // Shrink the window with the left pointer
        left++;
    }
}
```

### What is the have / required Pattern

The have/required pattern is a technique for determining whether the window satisfies the condition in O(1). `required` represents the total number of distinct character types that must be satisfied, and `have` represents the number of character types that have currently reached the required frequency. When `have == required`, the window satisfies all conditions.

```java
int required = need.size();  // Number of required character types (e.g., need={A:1,B:1,C:1} → 3)
int have = 0;                // Number of character types that satisfy the condition (initial value 0)
// When the count of 'A' in the window reaches need's count of 'A', have++ → have==required means all conditions are satisfied
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The right pointer and the left pointer each traverse `s` at most once |
| Space | O(n) — The HashMaps `need` and `window` store at most as many entries as the number of distinct characters in `s` and `t` |

## Code

```java
// Input: String s and String t
// Output: Return the shortest substring of s that contains all characters of t as a String. Return an empty string if none exists
String minWindow(String s, String t) {
    // If s is shorter than t, no window can contain all characters
    if (s.length() < t.length())
        return "";

    // HashMap that records the required frequency of each character in t. This defines the condition the window must satisfy
    Map<Character, Integer> need = new HashMap<>();
    for (char c : t.toCharArray()) {
        need.put(c, need.getOrDefault(c, 0) + 1);
    }

    // HashMap that manages the frequency of each character within the window
    Map<Character, Integer> window = new HashMap<>();
    int have = 0;              // Number of character types that satisfy the condition
    int required = need.size(); // Total number of character types that must be satisfied (number of keys in need)
    int resLen = Integer.MAX_VALUE; // Length of the minimum window (initial value representing undiscovered state)
    int resStart = 0;          // Start position of the minimum window
    int left = 0;              // Left pointer

    // Expand the window to the right using the right pointer
    for (int r = 0; r < s.length(); r++) {
        char c = s.charAt(r);
        // Increment the frequency of character c in the window (the window expands by one character to the right)
        window.put(c, window.getOrDefault(c, 0) + 1);

        // If character c is required in t and its frequency in the window has just reached the required count, increment have
        // Note: Use equals instead of == to compare Integer objects
        if (need.containsKey(c)
            && window.get(c).equals(need.get(c))) {
            have++;
        }

        // While the window satisfies all conditions (have == required), shrink it from the left to minimize
        while (have == required) {
            int wLen = r - left + 1;
            // If you find a shorter window, update the result
            if (wLen < resLen) {
                resLen = wLen;
                resStart = left;
            }
            // Remove the leftmost character from the window
            char lc = s.charAt(left);
            window.put(lc, window.get(lc) - 1);
            // If the removal causes the frequency to drop below the required count, the condition breaks so decrement have
            if (need.containsKey(lc)
                && window.get(lc) < need.get(lc)) {
                have--;
            }
            // Advance the left pointer to shrink the window
            left++;
        }
    }

    // If resLen remains at its initial value, no window satisfying the condition was found so return an empty string
    if (resLen == Integer.MAX_VALUE)
        return "";
    // Extract and return the substring from the start position of the minimum window for its length
    return s.substring(resStart, resStart + resLen);
}
```
