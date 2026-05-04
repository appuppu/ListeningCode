# Mapping Phone Number Digits to Letter Combinations — Generate All Letter Combinations from Phone Number Digits

## Problem

You are given a string `digits` consisting of digits from 2 to 9. Each digit maps to a set of letters on a phone keypad (e.g., 2→"abc", 3→"def"). You must return a list of **all possible letter combinations** formed by picking one letter from each digit's corresponding characters and concatenating them.

## Key Insight

Each digit position has 3 to 4 possible letters, and you need to enumerate all combinations. You can pick one letter at a time and append it to the end, record the result once you have selected letters for all digit positions, then undo the last choice and try a different letter. This "backtracking" approach exhaustively explores every pattern without missing any.

## Thought Process

1. **Each digit position has multiple choices**: Each digit corresponds to 3 or 4 letters, and you pick one letter per position. The answer consists of all combinations across every position, so you need a systematic way to enumerate every pattern.
2. **Process one digit at a time using recursion**: Starting from the first digit, you pick one letter and delegate the next digit's processing to a recursive call. This way, each recursion depth corresponds to one digit position, keeping the structure simple.
3. **The base case is when you have processed all digits**: When the recursion depth reaches the length of `digits`, the string you are currently building becomes one complete combination. You add it to the result list.
4. **Backtracking lets you try alternative choices**: After returning from a recursive call, you remove the last appended character from the `StringBuilder`. This prepares you to try another letter at the same position.
5. **Use a mapping array to convert digits to letters**: You prepare a string array with indices 0 through 9 and convert a digit character to an integer via `digits.charAt(idx) - '0'` for index access. This retrieves the corresponding letter group in O(1).
6. **Handle empty input**: If `digits` is empty, no combinations exist, so you return the empty list as is.

## Prerequisites

### What Is Backtracking

Backtracking is a search technique that builds solution candidates one step at a time, records each completed solution, then undoes the last choice and tries a different option. It is used in problems that require enumerating all combinations or permutations. The cycle of "choose → advance → undo → try another" is implemented via recursion.

```java
// Basic backtracking pattern
void backtrack(state, resultList) {
    if (terminationCondition) {
        resultList.add(currentState);
        return;
    }
    for (option : currentOptions) {
        add option to state;            // Choose
        backtrack(nextState, resultList); // Advance
        remove option from state;        // Undo (backtrack)
    }
}
```

### What Is StringBuilder

`StringBuilder` is a class for efficiently building strings. `String` is immutable (a new object is created every time you modify it), but `StringBuilder` modifies its internal buffer directly, so appending and deleting characters run in O(1). This makes it well suited for building strings during backtracking.

```java
StringBuilder sb = new StringBuilder();  // Create an empty StringBuilder
sb.append('a');           // Append character 'a' to the end → "a"
sb.append('b');           // Append character 'b' to the end → "ab"
sb.deleteCharAt(sb.length() - 1);  // Delete the last character → "a"
sb.toString();            // Convert to a String and return → "a"
```

### Phone Keypad Mapping

You represent the digit-to-letter mapping as an array. Each array index corresponds to a digit, and the value is the string of letters assigned to that digit.

```java
String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};
// phone[2] → "abc",  phone[7] → "pqrs",  phone[9] → "wxyz"
// Convert character '3' to integer 3: '3' - '0' → 3
```

## Complexity

| | Value |
|---|---|
| Time | O(4^n) — Each digit has up to 4 letter choices, and you enumerate all combinations across n digits |
| Space | O(n) — The maximum recursion depth is n, and the StringBuilder length is also at most n (excluding the result list) |

## Code

```java
// Input: a string digits consisting of digits 2 through 9
// Output: return a List<String> containing all letter combinations

// Use backtracking to pick one letter per digit and enumerate all combinations
void backtrack(String digits, String[] phone, int idx, StringBuilder path, List<String> result) {
    // Base case: if idx equals the length of digits, you have picked letters for all digit positions
    // Convert the StringBuilder contents to a String and add it to the result
    if (idx == digits.length()) {
        result.add(path.toString());
        return;
    }

    // Convert the digit character to an integer via digits.charAt(idx) - '0' and retrieve the corresponding letters from the phone array
    String letters = phone[digits.charAt(idx) - '0'];

    // Try each letter corresponding to the current digit one by one
    for (char c : letters.toCharArray()) {
        path.append(c);                            // Choose: pick the letter and append it to the end
        backtrack(digits, phone, idx + 1, path, result);  // Recurse: proceed to process the next digit
        path.deleteCharAt(path.length() - 1);      // Restore: delete the last character to revert the state (backtrack)
    }
}

List<String> letterCombinations(String digits) {
    // Create an empty list to store the results
    List<String> result = new ArrayList<>();

    // If the input is an empty string, no combinations exist, so return the empty list
    if (digits.isEmpty()) return result;

    // Define the mapping array where each index corresponds to a digit
    // Indices 0 and 1 have no letters assigned on the phone keypad, so they are empty strings
    String[] phone = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    // Start backtracking from position 0 with an empty StringBuilder
    backtrack(digits, phone, 0, new StringBuilder(), result);

    // All recursive calls have completed, and result contains every combination, so return it
    return result;
}
```
