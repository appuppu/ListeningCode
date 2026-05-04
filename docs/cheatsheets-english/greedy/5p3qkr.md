# Partitioning a String Into Maximum Parts — Partition a string into the maximum number of parts so that each character appears in at most one part

## Problem

You are given a string `s` consisting of lowercase English letters. You must partition the string into as many parts as possible such that each character appears in at most one part. Return a list of the **lengths** of each part.

## Key Insight

If a character appears in the current part, you must extend that part at least to the last occurrence of that character. By precomputing the last occurrence index of each character, you can greedily determine part boundaries in a single scan.

## Thought Process

1. **Understand the partition constraint**: The same character must not span two different parts. This means any part that contains a given character must extend at least to the last occurrence of that character.
2. **Precompute the last occurrence of each character**: Scan the string once and record the last index at which each character appears in an array. Since there are only 26 lowercase English letters, an array of size 26 is sufficient.
3. **Greedily extend the end of each part**: Scan the string from the beginning and track `end`, the maximum last-occurrence index among all characters in the current part. Each time you encounter a new character, update `end` by comparing it with that character's last occurrence index.
4. **Determine when to finalize a part**: When the current index `i` reaches `end`, all characters within the current part are guaranteed to fall within this part's range. At this point, finalize the current part and start a new one.
5. **Calculate the length of each part**: Each time you finalize a part, compute its length as `end - start + 1` and append it to the result list. Then update the start position `start` to `i + 1` for the next part.

## Prerequisites

### Character-to-Index Conversion

In Java, the `char` type can be treated as an integer. The expression `s.charAt(i) - 'a'` converts lowercase `'a'` to `0`, `'b'` to `1`, ..., and `'z'` to `25`. This allows you to manage all lowercase letters using an array of size 26.

```java
char c = 'c';
int index = c - 'a';    // 2 ('c' is 2 positions after 'a')
int[] arr = new int[26]; // Array for 26 letters
arr[c - 'a'] = 5;       // Store value 5 at the position corresponding to 'c'
```

### What Is Math.max

`Math.max` is a method that returns the larger of two values. When extending the end of a part, you use it to compare the current `end` with the last occurrence index of a new character and adopt whichever is farther.

```java
Math.max(3, 7);   // Returns 7
Math.max(10, 2);  // Returns 10
```

### What Is ArrayList

`ArrayList` is a dynamically sized list. Since you do not know the number of parts in advance, it is well suited for appending each part's length one by one.

```java
List<Integer> res = new ArrayList<>();  // Create an empty list
res.add(9);    // Append 9 to the end → [9]
res.add(7);    // Append 7 to the end → [9, 7]
```

## Complexity

| | Value |
|---|---|
| Time | O(n) — The algorithm only requires two passes over the string (one to record last positions, one to partition) |
| Space | O(1) — The algorithm uses only a fixed-size array of 26 elements, independent of the input size |

## Code

```java
// Input: a string s consisting of lowercase English letters
// Output: return a List<Integer> containing the length of each part
List<Integer> partitionLabels(String s) {
    // An integer array of size 26 to store the last occurrence index of each character ('a'–'z')
    // Size 26 is fixed because there are only 26 lowercase English letters
    int[] last = new int[26];

    // First pass: record the last occurrence index of each character
    // If a character appears multiple times, later indices overwrite earlier ones, so the last position remains
    for (int i = 0; i < s.length(); i++) {
        last[s.charAt(i) - 'a'] = i;
    }

    // Use a dynamically sized list because the number of parts is not known in advance
    List<Integer> res = new ArrayList<>();
    // start: the start position of the current part, end: the end position of the current part
    int start = 0, end = 0;

    // Second pass: greedily finalize each part
    for (int i = 0; i < s.length(); i++) {
        // If the last occurrence of the current character is beyond end, extend the part's end to that position
        // This ensures that end always holds the maximum last-occurrence index among all characters in the part
        end = Math.max(end,
            last[s.charAt(i) - 'a']);

        // When i reaches end → all characters in the part are guaranteed to fall within this range
        // This holds because no character in the part appears after end
        if (i == end) {
            // Calculate the part's length as end - start + 1 and append it to the result list
            res.add(end - start + 1);
            // Update the start position for the next part
            start = i + 1;
        }
    }
    // Return the list containing the lengths of all parts
    return res;
}
```
