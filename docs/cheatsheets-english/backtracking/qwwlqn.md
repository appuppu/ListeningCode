# Finding Combinations That Sum to a Target Without Reuse — Find All Unique Combinations from an Array with Duplicates That Sum to a Target

## Problem

The system receives an integer array `candidates` (which may contain duplicate elements) and an integer `target`. The algorithm finds all combinations of numbers from the array that sum to `target`. Each number can be used **only once** in a combination, and the result **must not contain duplicate combinations**.

## Key Insight

Sorting the array places elements with the same value adjacent to each other, which enables the skip condition `i > start && cands[i] == cands[i-1]` at the same recursion level. This condition fundamentally prevents the generation of duplicate combinations while ensuring the algorithm explores all unique combinations without omission.

## Thought Process

1. **The problem requires enumerating all combinations**: The problem asks for "all combinations that satisfy the condition," so the algorithm must explore the entire solution space rather than finding a single optimal solution. Backtracking is well-suited for this type of "enumerate all" problem.
2. **The algorithm branches on "include/exclude" for each element**: For each element in the array, the algorithm recursively decides whether to include or exclude it from the current combination. To ensure each element is used only once, the recursive call advances the start index to `i + 1`.
3. **The algorithm must eliminate duplicate combinations**: When the array contains duplicate elements, selecting the same value at different indices can produce identical combinations. For example, given `[1,1,2]` with target=3, combining the first 1 with 2 and combining the second 1 with 2 both produce `[1,2]`.
4. **Sorting and skipping duplicates**: Sorting the array places identical values next to each other. At the same recursion level (within the same for loop), skipping elements that have the same value as the previous element prevents the generation of duplicate combinations. The skip condition is `i > start && cands[i] == cands[i-1]`. The `i > start` condition allows the algorithm to use the first occurrence while skipping subsequent occurrences of the same value.
5. **Pruning optimizes the search**: Since the array is sorted, when the current element exceeds the remaining sum `remain`, all subsequent elements also exceed it. The statement `if (cands[i] > remain) break` terminates the loop early and eliminates unnecessary exploration.
6. **Base case evaluation**: When `remain` reaches 0, the sum of elements in the current `path` equals exactly `target`, so the algorithm adds a copy of `path` to the result list.

## Prerequisites

### What Is Backtracking

Backtracking is a search technique that incrementally builds solution candidates and reverts to the previous state (backtracks) to try alternative candidates when the current path is determined to violate the constraints. The implementation follows the pattern of "choose → recurse → undo the choice."

```java
path.add(element);          // Choose: add the element to the combination
backtrack(next_state);      // Recurse: continue exploring with the next element
path.remove(path.size()-1); // Undo: remove the element from the combination to restore the previous state
```

### What Is Arrays.sort

`Arrays.sort` is a standard Java method that sorts an array in ascending order. Sorting places elements with the same value adjacent to each other, which makes detecting and skipping duplicates straightforward.

```java
int[] arr = {2, 1, 2, 3};
Arrays.sort(arr);           // arr becomes {1, 2, 2, 3}
```

### Copy Constructor of ArrayList

`new ArrayList<>(path)` creates a new list by copying the contents of `path`. In backtracking, `path` continues to change during recursion, so the algorithm must take a copy at the point of adding it to the result.

```java
List<Integer> path = new ArrayList<>(Arrays.asList(1, 2));
List<Integer> copy = new ArrayList<>(path);  // Create a copy of [1, 2]
path.add(3);        // path becomes [1, 2, 3]
// copy remains [1, 2] unchanged
```

## Complexity

| | Value |
|---|---|
| Time | O(2^n) — Each element has two choices ("include" or "exclude"), so the algorithm explores up to 2^n combinations in the worst case |
| Space | O(n) — The maximum recursion depth is n, and the path holds at most n elements |

## Code

```java
// Input: an integer array candidates (which may contain duplicates) and an integer target
// Output: return a List<List<Integer>> containing all unique combinations that sum to target
private void backtrack(int[] cands, int start, int remain,
        List<Integer> path, List<List<Integer>> result) {
    // If remain is 0, the algorithm has found a combination whose sum equals exactly target
    if (remain == 0) {
        // path continues to change in subsequent recursion, so the algorithm creates a copy and adds it to the result
        result.add(new ArrayList<>(path));
        return;
    }

    // Starting from start prevents re-selecting elements before start that have already been used
    for (int i = start; i < cands.length; i++) {
        // Skip if this is not the first element at the same recursion level and it has the same value as the previous element, to prevent duplicate combinations
        // i > start means "this is not the first element at the same recursion level"
        if (i > start && cands[i] == cands[i - 1]) continue;

        // Since the array is sorted, if the current value exceeds remain, all subsequent elements also exceed it (pruning)
        if (cands[i] > remain) break;

        path.add(cands[i]);                  // Choose: add the element to the combination
        backtrack(cands, i + 1,              // Recurse: use i+1 to prevent using the same element twice
            remain - cands[i], path, result); // Subtract the current element from remain to update the remaining sum
        path.remove(path.size() - 1);        // Undo: remove the element to restore state for trying other elements
    }
}

public List<List<Integer>> combinationSum2(
        int[] candidates, int target) {
    // Sorting places duplicate elements with the same value adjacent to each other, enabling the skip condition
    Arrays.sort(candidates);
    // Create an empty result list and an empty path to record the current combination
    List<List<Integer>> result = new ArrayList<>();
    // Start the recursive search from index 0 with the remaining sum set to target
    backtrack(candidates, 0, target, new ArrayList<>(), result);
    // After all recursion completes, return all stored unique combinations
    return result;
}
```
