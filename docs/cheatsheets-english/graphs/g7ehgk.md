# Finding the Shortest Word Transformation Sequence

## Problem

You are given a start word `beginWord`, an end word `endWord`, and a dictionary of valid words `wordList`. You must find the shortest transformation sequence from `beginWord` to `endWord`, where each step changes **exactly one character** and every intermediate word exists in the dictionary. The function returns the **length of the shortest sequence**. If no such sequence exists, the function returns 0.

## Key Insight

If you treat each one-character transformation between words as an edge in a graph, finding the shortest transformation sequence becomes a shortest path problem. By running BFS simultaneously from both the start and end points and always expanding the smaller frontier, you can dramatically reduce the search space.

## Thought Process

1. **Model the problem as a graph**: Consider each word as a node and connect words that differ by exactly one character with an edge. The length of the shortest transformation sequence corresponds to the shortest path from `beginWord` to `endWord` in this graph.
2. **Use BFS for shortest path**: Since this is a shortest path problem on an unweighted graph, BFS (Breadth-First Search) is the appropriate algorithm. Each BFS level corresponds to one transformation step.
3. **Unidirectional BFS is inefficient**: If you run BFS only from the start point, the number of candidates grows exponentially at each level. The search space explodes as depth increases.
4. **Bidirectional BFS reduces the search space**: By running BFS simultaneously from both the start and end points, you find the shortest path when the two searches meet. Each search only needs to reach a depth of d/2, which significantly reduces the search space.
5. **Expand the smaller frontier first**: At each step, compare the sizes of the start-side and end-side frontiers (the set of words at the current level) and expand the smaller one. This strategy keeps the frontier size from growing too large.
6. **Generate adjacent words efficiently**: Instead of comparing against every word in the dictionary, generate adjacent words by trying all 26 letters (a–z) at each position in the word. This approach is more efficient when the word length m is much smaller than the dictionary size n.
7. **Detect convergence with the other frontier**: If a generated adjacent word exists in the other side's frontier, the two searches have met. At that point, the function returns the current level + 1.

## Prerequisites

### What Is BFS (Breadth-First Search)?

BFS is an algorithm that explores nodes in a graph in order of increasing distance from the start node. Because the distance increases by 1 at each level, the distance at which BFS first reaches a node is the shortest distance to that node. BFS is used to solve shortest path problems on unweighted graphs.

### What Is a HashSet?

A HashSet is a data structure that maintains a collection of unique elements. It supports add, lookup, and delete operations in O(1) time. It automatically eliminates duplicates.

```java
Set<String> set = new HashSet<>();   // Create an empty HashSet
set.add("hot");                      // Add an element
set.contains("hot");                 // Check whether an element exists, returns boolean → true
set.size();                          // Return the number of elements → 1
```

### What Is Bidirectional BFS?

Standard BFS explores only from the start point, whereas bidirectional BFS explores simultaneously from both the start and end points. The algorithm finds the shortest path when the two frontiers overlap. The search space is reduced from O(b^d) to O(b^(d/2)), where b is the branching factor and d is the shortest distance.

### What Are toCharArray / String.valueOf?

These are methods for converting a String to a character array so that you can manipulate individual characters.

```java
char[] ch = "hot".toCharArray();     // Convert String to char[] → ['h','o','t']
ch[0] = 'b';                        // Directly replace one character → ['b','o','t']
String next = String.valueOf(ch);    // Convert char[] back to String → "bot"
```

## Complexity

| | Value |
|---|---|
| Time | O(n × m) — n is the number of words in the dictionary, m is the word length. The algorithm tries 26 characters at each position of each word. |
| Space | O(n × m) — The visited set and frontiers store up to n words, each of length m. |

## Code

```java
// Input: start word beginWord, end word endWord, dictionary of valid words wordList
// Output: return the length of the shortest transformation sequence as int. Return 0 if no sequence exists.
int ladderLength(String beginWord, String endWord, List<String> wordList) {
    // Convert the dictionary to a HashSet for O(1) word existence checks
    Set<String> wordSet = new HashSet<>(wordList);
    // If endWord is not in the dictionary, no transformation sequence exists, so return 0
    if (!wordSet.contains(endWord)) return 0;

    // Create three HashSets: start-side frontier, end-side frontier, and visited set
    Set<String> start = new HashSet<>();
    Set<String> end = new HashSet<>();
    Set<String> visited = new HashSet<>();
    start.add(beginWord);
    end.add(endWord);
    // Mark both frontier words as visited
    visited.add(beginWord);
    visited.add(endWord);
    // level represents the transformation sequence length (counting beginWord itself as 1)
    int level = 1;

    // If either frontier becomes empty, the target is unreachable, so exit the loop
    while (!start.isEmpty() && !end.isEmpty()) {
        // Always expand the smaller frontier to limit search space growth
        if (start.size() > end.size()) {
            Set<String> temp = start;
            start = end;
            end = temp;
        }

        // Set to hold the next level's candidates
        Set<String> nextLevel = new HashSet<>();

        for (String word : start) {
            // Convert the word to char[] and replace each position one character at a time to generate adjacent words
            char[] ch = word.toCharArray();
            for (int j = 0; j < ch.length; j++) {
                // Save the original character so it can be restored after exploration
                char orig = ch[j];
                // Try all 26 letters a–z at each position to generate adjacent words
                for (char c = 'a'; c <= 'z'; c++) {
                    ch[j] = c;
                    String next = String.valueOf(ch);
                    // If the other frontier contains this word, the two searches have met
                    if (end.contains(next)) return level + 1;
                    // If the word is in the dictionary and has not been visited, add it to the next frontier
                    // Adding it to visited prevents revisiting the same word
                    if (wordSet.contains(next) && !visited.contains(next)) {
                        nextLevel.add(next);
                        visited.add(next);
                    }
                }
                // Restore the original character before exploring the next position
                ch[j] = orig;
            }
        }
        // Replace the frontier with the next level and increment level for the next iteration
        start = nextLevel;
        level++;
    }
    // If either frontier becomes empty, no transformation sequence exists
    return 0;
}
```
