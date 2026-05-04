# Generating All Subsets of a Set

## Problem

Given an array `nums` of distinct integers, return a list of all possible subsets (the power set). The solution must not contain duplicate subsets, and you may return the subsets in any order.

## Key Insight

A set with `n` elements has `2^n` subsets. By enumerating integers from `0` to `2^n - 1` using `n` bits, each bit represents whether to include or exclude the corresponding element. This approach generates all subsets without omission or duplication.

## Thought Process

1. **The number of subsets is determined by 2^n**: Each element has two choices — "include" or "exclude" — so a set with `n` elements has `2^n` subsets. To enumerate all subsets, we need a mechanism that expresses all `2^n` selection patterns.
2. **We can represent binary choices using bits**: By mapping "include = 1, exclude = 0," we can express the selection pattern of `n` elements as an `n`-bit integer. For example, when `nums = [a, b, c]`, the bit string `101` means "include a, exclude b, include c," which represents the subset `[a, c]`.
3. **Integers from 0 to 2^n-1 cover all patterns**: The integers representable with `n` bits range from `0` (all bits 0 = empty set) to `2^n - 1` (all bits 1 = full set), totaling `2^n` values. Enumerating these integers in order generates all subsets without omission or duplication.
4. **How to construct a subset from each integer**: We can check whether the `i`-th bit of integer `mask` is `1` using `(mask & (1 << i)) != 0`. If the bit is `1`, we add `nums[i]` to the subset. By scanning `i` from `0` to `n-1`, we complete the subset corresponding to `mask`.
5. **Compute 2^n using 1 << n**: In Java, we can use the bit shift operator `<<` to compute `2^n` as `1 << n`. By setting the loop condition to `mask < (1 << n)`, we enumerate all values from `0` to `2^n - 1` without omission.
6. **What to return**: We add the subset corresponding to each `mask` to a list, and after processing all values of `mask`, we return the list of subsets `result`.

## Prerequisites

### Bitmask

A bitmask is a technique that uses each bit (0 or 1) of an integer as a "flag." It can represent all "include/exclude" combinations for `n` elements using a single integer.

```java
int mask = 5;            // 101 in binary
// Bit 0: 1 (include), Bit 1: 0 (exclude), Bit 2: 1 (include)
```

### Bitwise Operators

We combine `&` (AND) and `<<` (left shift) to check whether a specific bit is set.

```java
1 << 0;                  // 1 (binary: 001) — creates a mask with only bit 0 set to 1
1 << 1;                  // 2 (binary: 010) — creates a mask with only bit 1 set to 1
1 << 2;                  // 4 (binary: 100) — creates a mask with only bit 2 set to 1

int mask = 5;            // binary: 101
(mask & (1 << 0)) != 0;  // true  — bit 0 is 1
(mask & (1 << 1)) != 0;  // false — bit 1 is 0
(mask & (1 << 2)) != 0;  // true  — bit 2 is 1
```

### Computing 2^n Using 1 << n

The bit shift `1 << n` shifts `1` to the left by `n` bits, producing `2^n`. We use this operation to calculate the total number of subsets.

```java
1 << 3;                  // 8 (= 2^3) — 3 elements yield 8 subsets
```

## Complexity

| | Value |
|---|---|
| Time | O(n × 2^n) — We scan n bits for each of the 2^n masks |
| Space | O(n × 2^n) — We store 2^n subsets, and each subset contains n/2 elements on average |

## Code

```java
// Input: an array nums of distinct integers
// Output: return a List<List<Integer>> containing all subsets
List<List<Integer>> subsets(int[] nums) {
    // The number of elements in nums. Used both as the bit count for bitmasks and the array scan range
    int n = nums.length;
    // A list to store all subsets. We add the subset generated from each mask here
    List<List<Integer>> result = new ArrayList<>();

    // Enumerate mask from 0 to 2^n-1, where each value corresponds to one subset
    // Compute 2^n using 1 << n and use it as the loop condition to enumerate all 2^n patterns
    for (int mask = 0; mask < (1 << n); mask++) {
        // Create an empty subset to which we add elements corresponding to the current mask
        List<Integer> subset = new ArrayList<>();

        // i is the index into nums and also determines which bit of mask to examine
        for (int i = 0; i < n; i++) {
            // Create a mask with only bit i set to 1 using 1 << i, then AND with mask to extract bit i
            // If the bit is 1, include this element; if 0, skip to the next i
            if ((mask & (1 << i)) != 0) {
                subset.add(nums[i]);
            }
        }

        // After the inner loop finishes, add the completed subset to the result list
        result.add(subset);
    }
    // After processing all masks, return result containing all 2^n subsets
    return result;
}
```
