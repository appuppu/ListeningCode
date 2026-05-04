# Generating All Unique Subsets With Duplicates

## Problem

Given an integer array `nums` that may contain duplicate values, return all possible unique subsets. The result must not contain duplicate subsets, and the order of elements within each subset can be arbitrary.

## Key Insight

If you sort the array beforehand, you can fundamentally prevent the generation of duplicate subsets by simply skipping an element when it has the same value as the previous element at the same recursion level.

## Thought Process

1. **Subset generation is a classic backtracking problem**: You can enumerate all subsets by recursively deciding whether to include or exclude each element. Adding the current subset to the result at each stage of the recursion yields all subsets.
2. **Identify the cause of duplicates**: When the array contains multiple elements with the same value — for example, `[1,2,2]` — choosing the first `2` versus choosing the second `2` produces identical subsets. Duplicates occur when you select the same value multiple times at the same recursion level.
3. **Sort the array to make duplicate elements adjacent**: Sorting the array places elements with the same value next to each other. This allows you to determine whether an element has the same value as the previous element through a simple comparison.
4. **Skip duplicates at the same recursion level**: Inside the for-loop, skip the current element when the condition `i > start && nums[i] == nums[i-1]` is met. The condition `i > start` means "this is not the first choice at this recursion level," which allows you to select the same value at different recursion levels (including the same value multiple times in a subset is permitted).
5. **Add to the result at each stage of the recursion**: Add the current subset `curr` to the result list at the beginning of the recursive function. This ensures that all subsets — from the empty set to the set containing all elements — are included in the result.
6. **Restore the original state through backtracking**: Removing the last element from `curr` after the recursive call restores the previous state, enabling correct exploration of the next choice.

## Prerequisites

### What Is Backtracking

Backtracking is a search technique that recursively builds solution candidates and, when a candidate fails to satisfy the constraints, undoes the most recent choice and tries a different one. It is used to enumerate subsets, permutations, and combinations.

```java
// Basic structure of backtracking
void backtrack(state, choiceList) {
    add current state to result;
    for (each choice) {
        apply choice;
        backtrack(nextState, remainingChoices);
        undo choice;  // ← backtrack
    }
}
```

### What Is Arrays.sort

`Arrays.sort` is a method that sorts an array in ascending order. By making duplicate elements adjacent, it simplifies duplicate detection.

```java
int[] nums = {4, 1, 4, 2};
Arrays.sort(nums);  // nums becomes {1, 2, 4, 4}
```

### Copying an ArrayList

`new ArrayList<>(list)` creates a shallow copy of an existing list. When adding a subset to the result, you must add a copy rather than a reference; otherwise, subsequent backtracking will overwrite its contents.

```java
List<Integer> curr = new ArrayList<>();
curr.add(1);
curr.add(2);
List<Integer> copy = new ArrayList<>(curr);  // Create a copy of [1, 2]
curr.remove(curr.size() - 1);               // curr reverts to [1], but copy remains [1, 2]
```

### Removing the Last Element From a List

`list.remove(list.size() - 1)` removes the last element from a list. This is used in backtracking to undo the most recently added element.

```java
List<Integer> curr = new ArrayList<>();
curr.add(5);        // curr = [5]
curr.add(3);        // curr = [5, 3]
curr.remove(curr.size() - 1);  // curr reverts to [5]
```

## Complexity

| | Value |
|---|---|
| Time | O(n × 2^n) — There are at most 2^n subsets, and copying each subset takes up to O(n). |
| Space | O(n) — The maximum recursion depth is n, and the working list `curr` has a maximum length of n (excluding the result list). |

## Code

```java
// Input: an integer array nums that may contain duplicates
// Output: return a List<List<Integer>> containing all unique subsets
void backtrack(int[] nums, int start, List<Integer> curr, List<List<Integer>> result) {
    // Add a copy of the current subset to the result
    // Use new ArrayList<>(curr) to create a copy because curr changes during subsequent recursion, so you need to save its state at this point rather than a reference
    result.add(new ArrayList<>(curr));

    // Scanning from start ensures that elements before the current position are not selected, maintaining element order within each subset
    for (int i = start; i < nums.length; i++) {
        // Skip this element if it has the same value as the previous element at the same recursion level, preventing duplicates
        // i > start: this is not the first choice at this level (selecting the same value at a different level is allowed)
        // nums[i] == nums[i-1]: this element has the same value as the previous element
        // When both conditions hold simultaneously, selecting the same value twice at the same level would produce a duplicate subset
        if (i > start && nums[i] == nums[i - 1]) continue;

        // Add the current element to the subset and proceed to the next level
        // Passing i + 1 ensures that the next recursion level only considers elements after the current element
        curr.add(nums[i]);
        backtrack(nums, i + 1, curr, result);

        // Backtrack: remove the last element to restore the previous state, allowing a different element to be selected in the next iteration
        curr.remove(curr.size() - 1);
    }
}

public List<List<Integer>> subsetsWithDup(int[] nums) {
    // Sort to make elements with the same value adjacent, enabling duplicate detection through a simple nums[i] == nums[i-1] comparison
    Arrays.sort(nums);
    List<List<Integer>> result = new ArrayList<>();
    // 0 means "start the search from the beginning of the array"
    backtrack(nums, 0, new ArrayList<>(), result);
    // All recursion is complete, and result contains all unique subsets
    return result;
}
```
