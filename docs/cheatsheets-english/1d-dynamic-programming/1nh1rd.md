# Finding the Longest Increasing Subsequence

## Problem

You are given an integer array `nums`. Return the length of the **longest strictly increasing subsequence** that can be formed by deleting elements from the original array without changing their relative order. The subsequence does not need to be contiguous, but it must preserve the relative order of elements in the original array.

## Key Insight

"The smaller the last element of an increasing subsequence of length `k` is, the more likely it is that subsequent elements can extend it." If you maintain an array `tails` that tracks the minimum possible last element for each subsequence length, you can determine the insertion position of each new element via binary search in O(log n), solving the entire problem in O(n log n).

## Thought Process

1. **A smaller tail element is more advantageous for extending an increasing subsequence**: When multiple increasing subsequences share the same length, the one with the smallest last element has the widest range of values that can follow it. Therefore, it is sufficient to record only the minimum last element for each length.
2. **The tails array manages the minimum last element for each length**: Prepare an array `tails` where `tails[i]` stores the minimum possible last element of an increasing subsequence of length `i+1`. This array always remains sorted in ascending order, because a longer subsequence necessarily has a larger last element.
3. **Processing each new element falls into two cases**: For each element `num` in the array, use binary search to find the smallest element in `tails` that is greater than or equal to `num`. If the found position exceeds the end of `tails`, then `num` is larger than all elements in the longest existing subsequence, so append `num` to the end of `tails`. If the position does not exceed the end, replace the value at that position with `num` to update the minimum last element.
4. **Binary search works because the tails array is always sorted**: Since `tails` is always sorted in ascending order, you can determine the insertion position of `num` using `Collections.binarySearch` in O(log n). This makes each element's processing O(log n), achieving O(n log n) overall.
5. **The length of the tails array is the answer**: During processing, each element either triggers an append or a replacement in `tails`. An append means the length of the longest subsequence has increased by one. After all elements have been processed, `tails.size()` equals the length of the longest increasing subsequence.

## Prerequisites

### What is an ArrayList

An ArrayList is a dynamically-sized array. It supports adding, retrieving, and updating elements in O(1). Unlike a regular array, you do not need to specify its size in advance.

```java
List<Integer> list = new ArrayList<>();  // Create an empty ArrayList
list.add(10);          // Append 10 to the end → [10]
list.add(20);          // Append 20 to the end → [10, 20]
list.get(0);           // Retrieve the element at index 0 → 10
list.set(0, 5);        // Replace the element at index 0 with 5 → [5, 20]
list.size();           // Return the number of elements → 2
```

### What is Collections.binarySearch

`Collections.binarySearch` is a method that performs binary search on a sorted list and returns the position of the specified value. If the value is found, it returns its index. If the value is not found, it returns a negative value of the form `-(insertion point) - 1`. The insertion point is the position at which the value could be inserted into the list while maintaining sorted order.

```java
List<Integer> list = Arrays.asList(2, 5, 8, 12);
Collections.binarySearch(list, 5);   // 5 is at index 1 → returns 1
Collections.binarySearch(list, 6);   // 6 does not exist. Insertion point is 2 → returns -(2)-1 = -3
Collections.binarySearch(list, 1);   // 1 does not exist. Insertion point is 0 → returns -(0)-1 = -1
Collections.binarySearch(list, 15);  // 15 does not exist. Insertion point is 4 → returns -(4)-1 = -5
```

To recover the insertion point from a negative return value, compute `-(return value + 1)`. For example: if the return value is -3, then `-(-3 + 1) = 2` is the insertion point.

### Concept of the tails Array

The `tails` array records the minimum last element of increasing subsequences for each length. `tails[i]` represents the minimum possible last element of an increasing subsequence of length `i+1`. This array always maintains ascending sorted order.

Example: processing nums = [3, 1, 4, 1, 5]:
- Process 3 → tails = [3] (the minimum last element for a subsequence of length 1 is 3)
- Process 1 → tails = [1] (update the minimum last element for length 1 to 1, since 1 is smaller and more advantageous than 3)
- Process 4 → tails = [1, 4] (4 is greater than 1, so append it to the end; a subsequence of length 2 now exists)
- Process 1 → tails = [1, 4] (the insertion point for 1 is index 0, which already holds 1, so no change occurs)
- Process 5 → tails = [1, 4, 5] (5 is greater than 4, so append it to the end; a subsequence of length 3 now exists)

The final `tails.size()` = 3 is the answer.

## Complexity

| | Value |
|---|---|
| Time | O(n log n) — the algorithm performs an O(log n) binary search for each of the n elements |
| Space | O(n) — the tails array stores at most n elements |

## Code

```java
// Input: integer array nums
// Output: return the length of the longest strictly increasing subsequence as an int
public int lengthOfLIS(int[] nums) {
    // Array that maintains the minimum last element of increasing subsequences for each length in ascending order
    // tails[i] represents the minimum possible last element of an increasing subsequence of length i+1
    List<Integer> tails = new ArrayList<>();

    // Iterate through each element of the array nums from start to end
    for (int num : nums) {
        // Use binary search to find the position where num should be placed in the tails array
        // Binary search works because tails is always sorted
        int pos = Collections.binarySearch(tails, num);

        // A negative value means "not found", so convert it to the insertion point
        // If pos is 0 or greater, a value equal to num already exists at tails[pos], so use it as is
        if (pos < 0)
            pos = -(pos + 1);

        if (pos == tails.size()) {
            // num is greater than all elements in tails, so append it to the end
            // This means the length of the longest increasing subsequence has increased by 1
            tails.add(num);
        } else {
            // Replace the minimum last element at the corresponding position with num
            // This makes the minimum last element for a subsequence of length pos+1 smaller,
            // increasing the chance of extending the subsequence in the future
            tails.set(pos, num);
        }
    }

    // The number of elements in tails equals the number of times an append occurred during processing,
    // which is the length of the longest increasing subsequence
    return tails.size();
}
```
