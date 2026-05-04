# Determining if a String Can Be Segmented Into Dictionary Words

## Problem

You are given a string `s` and a list of dictionary words `wordDict`. You must determine whether you can segment `s` into a concatenation of words contained in the dictionary, and return the result as a **boolean**. You can reuse each dictionary word any number of times.

## Key Insight

If you record whether each substring from the beginning of the string to position `i` is segmentable, then the decision at position `i` reduces to checking whether there exists some split point `j` such that the substring up to `j` is segmentable and the substring from `j` to `i` exists in the dictionary.

## Thought Process

1. **You can decompose this into subproblems**: To determine whether the first `i` characters of string `s` are segmentable, you split at some position `j` and check whether the first `j` characters are segmentable and whether the substring from `j` to `i` is a dictionary word. This structure is well-suited for dynamic programming.
2. **Define the DP state**: Let `dp[i]` be a boolean representing whether the first `i` characters of string `s` can be segmented using only dictionary words. The final answer is `dp[n]`, where `n` is the length of the string.
3. **Set the base case**: The empty string is always segmentable, so you set `dp[0] = true`. This base case enables the detection of dictionary words that start at the beginning of the string.
4. **Formulate the transition**: The condition for `dp[i]` to be `true` is that for some `j` where `0 ≤ j < i`, both `dp[j]` is `true` and `s.substring(j, i)` exists in the dictionary. You can determine this by trying all values of `j`.
5. **Speed up dictionary lookups**: Converting the word list into a HashSet allows you to check whether a substring is in the dictionary in O(1) using `contains`. This is more efficient than performing a linear search through the list.
6. **Eliminate unnecessary work with early termination**: Once some `j` confirms that `dp[i] = true`, you do not need to try any more values of `j`. You use `break` to exit the inner loop and move on to the next `i`.

## Prerequisites

### What Is a HashSet

A HashSet is a data structure that stores unique elements without duplicates. It can determine whether an element is contained in O(1) time. You use it to enable fast lookups against the dictionary word list.

```java
Set<String> set = new HashSet<>();       // Create an empty HashSet
set.add("apple");                        // Add an element
set.contains("apple");                   // Return a boolean indicating whether the element exists → true
```

### Converting a List to a Set via Constructor

Passing a List to the `HashSet` constructor converts all elements of the List into a Set. You use this to convert the dictionary into a HashSet in a single line.

```java
List<String> list = Arrays.asList("a", "b", "c");
Set<String> set = new HashSet<>(list);   // Convert all elements of the List into a Set
```

### What Is substring

The `substring` method extracts a portion of a string. `s.substring(j, i)` returns the characters from index `j` to index `i - 1`. You use it in the DP transition to obtain the substring from position `j` to position `i`.

```java
String s = "leetcode";
s.substring(0, 4);                       // Returns "leet" (indices 0 through 3)
s.substring(4, 8);                       // Returns "code" (indices 4 through 7)
```

### What Is a DP Array (Boolean Array)

A DP array stores the results of subproblems in dynamic programming. Creating it with `boolean[] dp = new boolean[n + 1]` initializes all elements to `false`. You assign `true` to `dp[i]` to record the result that the first `i` characters are segmentable.

```java
boolean[] dp = new boolean[5];           // Initialized to [false, false, false, false, false]
dp[0] = true;                           // Set the base case
```

## Complexity

| | Value |
|---|---|
| Time | O(n^2) — The outer loop runs n times, and the inner loop runs up to n times. If each step incurs O(n) for substring generation, the strict complexity is O(n^3), but it is typically treated as O(n^2) on average. |
| Space | O(n) — The algorithm uses a DP array of size n+1 and a HashSet that stores the dictionary words. |

## Code

```java
// Input: a string s and a list of dictionary words wordDict
// Output: return true if s can be segmented using only dictionary words, false otherwise
public boolean wordBreak(String s, List<String> wordDict) {
    // Convert the dictionary word list into a HashSet to enable O(1) lookups
    Set<String> set = new HashSet<>(wordDict);
    // Store the length of the string in a variable
    int n = s.length();

    // dp[i] = whether the first i characters can be segmented using only dictionary words
    // The size is n+1 because dp[n] represents the segmentability of the entire string
    boolean[] dp = new boolean[n + 1];

    // The empty string is always segmentable (base case)
    // Without this setting, the algorithm cannot detect dictionary words starting at the beginning of the string
    dp[0] = true;

    // Outer loop: i represents how many characters from the beginning the algorithm considers
    for (int i = 1; i <= n; i++) {
        // Inner loop: j is a candidate split point that divides the string into "first j characters" and "substring from j to i"
        for (int j = 0; j < i; j++) {
            // If the first j characters are segmentable AND the substring from j to i is a dictionary word, then the first i characters are segmentable
            // Both conditions holding simultaneously means the string can be divided into "a segmentable part + a dictionary word"
            if (dp[j] && set.contains(s.substring(j, i))) {
                dp[i] = true;
                break;  // Segmentability is confirmed, so there is no need to try other values of j
            }
        }
    }

    // dp[n] represents whether the entire string s is segmentable
    return dp[n];
}
```
