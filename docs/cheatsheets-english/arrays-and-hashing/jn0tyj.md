# Encoding and Decoding a List of Strings — Encode and decode a list of strings into a single string

## Problem

The system receives a list of strings `strs`. The `encode` method converts the list into a single string, and the `decode` method restores that string back to the original list. Both encoding and decoding must be stateless (maintaining no state between calls), and the solution must correctly handle all inputs, including empty strings, special characters, and strings that contain the delimiter itself.

## Key Insight

Prepending the length of each string before the string itself enables the system to extract each string accurately, regardless of what characters the string contains. When the length is known in advance, the collision problem with delimiters cannot occur by design.

## Thought Process

1. **Recognize the problem with a naive delimiter approach**: Joining the list with a delimiter such as a comma or newline fails when a string itself contains that delimiter. Introducing escape processing adds further complexity, because the escape character itself then requires escaping.
2. **Prepending the string length eliminates collisions**: Recording the length of each string (in characters, not bytes) before the string allows the decoder to know in advance how many characters to read. The decoder extracts each string without interpreting its contents, so any character within the string causes no issues.
3. **Use `#` as the separator between the length and the string body**: Because the length is a variable-digit integer, the system needs a symbol to mark the end of the length portion. Using `#` as the separator creates the format `length#stringBody`. During decoding, the decoder reads the length from the portion before the first `#`, then extracts the specified number of characters starting immediately after `#`.
4. **Encoding**: The encoder concatenates `string length + "#" + string body` for each string to build a single string. For example, `["hello", "a#b"]` becomes `5#hello3#a#b`.
5. **Decoding**: The decoder searches for `#` from the current position to read the length, then extracts that many characters starting immediately after `#`. The decoder uses the extraction end position as the next start position and repeats. Even if the string body contains `#`, the known length determines the exact range, so the decoder makes no misidentification.
6. **Return values**: The `encode` method returns a single concatenated `String`, and the `decode` method returns a `List<String>` restored from that `String`.

## Prerequisites

### What StringBuilder Is

`StringBuilder` is a class for efficiently concatenating strings. String concatenation using the `+` operator on `String` creates a new `String` object every time, but `StringBuilder` appends to an internal buffer in O(1) time.

```java
StringBuilder sb = new StringBuilder();  // Create an empty StringBuilder
sb.append("hello");                      // Append "hello" to the end
sb.append(5);                            // Append the integer 5 as a string to the end
sb.toString();                           // Return the resulting string "hello5"
```

### What String.indexOf(char, int) Is

`String.indexOf(char, int)` is a method that searches forward for a specified character starting from a specified position and returns the position (index) of the first occurrence. The method returns -1 if the character is not found.

```java
String str = "12#hello";
str.indexOf('#', 0);    // Search for '#' from position 0 → returns 2
str.indexOf('#', 3);    // Search for '#' from position 3 → returns -1 if not found
```

### What String.substring(int, int) Is

`String.substring(int, int)` is a method that extracts a specified range from a string. The first argument is the start position (inclusive), and the second argument is the end position (exclusive).

```java
String str = "5#hello";
str.substring(0, 1);    // From position 0 to just before position 1 → "5"
str.substring(2, 7);    // From position 2 to just before position 7 → "hello"
```

### What Integer.parseInt(String) Is

`Integer.parseInt(String)` is a static method that converts a string to an integer. The solution uses this method to read the numeric portion of the length prefix as an integer.

```java
Integer.parseInt("5");    // Convert the string "5" to the integer 5
Integer.parseInt("123");  // Convert the string "123" to the integer 123
```

## Complexity

| | Value |
|---|---|
| Time | O(n × k) — n is the number of strings and k is the average length of each string. The algorithm processes every string exactly once. |
| Space | O(n × k) — The algorithm uses space proportional to all strings for either the encoded result or the decoded result. |

## Code

```java
// === encode ===
// Input: a list of strings strs (List<String>)
// Output: returns a single String that combines all strings
public String encode(List<String> strs) {
    // Use StringBuilder for efficient string concatenation inside the loop
    StringBuilder sb = new StringBuilder();
    // Iterate through each string in the list from the beginning
    for (String str : strs) {
        // Prepend "length#" before each string and append the result
        // Recording the length first allows the decoder to determine the exact range of the string body
        sb.append(str.length() + "#" + str);
    }
    // Return the contents of the StringBuilder as a String
    return sb.toString();
}

// === decode ===
// Input: a single encoded string str (String)
// Output: returns the restored list of strings as List<String>
public List<String> decode(String str) {
    List<String> result = new ArrayList<>();
    // Variable indicating the current read position; start from the beginning
    int i = 0;
    while (i < str.length()) {
        // Search for the first '#' from the current position i to locate the separator between the length and the string body
        int separatorIndex = str.indexOf('#', i);
        // Read the portion before '#' as an integer to obtain the length of the string body
        int textLength = Integer.parseInt(str.substring(i, separatorIndex));
        // The string body starts immediately after '#'
        int textStart = separatorIndex + 1;
        // The end position is the start position plus the length; because the range is determined by length, the decoder extracts correctly even if the string body contains '#'
        int textEnd = textStart + textLength;
        // Extract the string body and add it to the result list
        result.add(str.substring(textStart, textEnd));
        // Move the read position to the beginning of the next string's length portion
        i = textEnd;
    }
    return result;
}
```
