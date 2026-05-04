# Finding the Median of Two Sorted Arrays — Find the median when merging two sorted arrays

## Problem

The algorithm receives two sorted integer arrays `n1` and `n2`. It must compute the **median** of the merged array. The solution must run in logarithmic time relative to the total number of elements.

## Key Insight

Finding the median of two sorted arrays is equivalent to finding the boundary that correctly partitions all elements into a "left half" and a "right half." Performing binary search on the shorter array to determine the partition position automatically determines the partition position in the other array.

## Thought Process

1. **The median is determined by the "maximum of the left half" and the "minimum of the right half"**: If the algorithm can split the merged array into two equal halves while maintaining sorted order, the median equals the maximum of the left half (when the total count is odd), or the average of the maximum of the left half and the minimum of the right half (when the total count is even). In other words, the algorithm does not need to sort all elements — it only needs to find the correct partition position.
2. **Choosing the partition in one array automatically determines the partition in the other**: When the algorithm decides to place a total of `half = (m + n + 1) / 2` elements in the left half, taking `cut1` elements from `n1` means it must take `cut2 = half - cut1` elements from `n2`. Therefore, the algorithm only needs to search for `cut1`.
3. **The algorithm validates a correct partition using "cross comparison"**: A correct partition means every element in the left half is less than or equal to every element in the right half. Since each individual array is already sorted, the algorithm only needs to check the crossing boundaries. Specifically, the partition is correct when the last element of `n1`'s left portion `l1` ≤ the first element of `n2`'s right portion `r2`, and the last element of `n2`'s left portion `l2` ≤ the first element of `n1`'s right portion `r1`.
4. **Binary search finds `cut1` efficiently**: The range of `cut1` spans from `0` to `m`. If `l1 > r2`, the algorithm is taking too many elements from `n1`, so it decreases `cut1`. If `l2 > r1`, the algorithm is taking too few elements from `n1`, so it increases `cut1`. This condition enables binary search.
5. **The algorithm searches the shorter array for efficiency**: The binary search range spans from `0` to `m` (the array length), so choosing the shorter array minimizes the search range and achieves `O(log(min(m, n)))` time complexity.
6. **Sentinel values handle boundary cases**: When `cut1 = 0` (taking no elements from `n1`) or `cut1 = m` (taking all elements from `n1`), the algorithm would access elements that do not exist. Using `Integer.MIN_VALUE` and `Integer.MAX_VALUE` as sentinel values ensures the comparison conditions always work correctly.

## Prerequisites

### Median

The median is the value at the center position in a sorted sequence. When the element count is odd, the median is the single middle element. When the element count is even, the median is the average of the two middle elements.

```java
// Odd count: [1, 3, 5] → the median is 3
// Even count: [1, 3, 5, 7] → the median is (3 + 5) / 2.0 = 4.0
```

### Binary Search

Binary search is a technique that finds a target value in O(log n) time by halving the search range at each step on sorted data. It manages the search range with `lo` and `hi`, and narrows the range based on the middle value.

```java
int lo = 0, hi = n;
while (lo <= hi) {
    int mid = (lo + hi) / 2;       // Calculate the middle of the search range
    if (condition is met) { /* answer */ }
    else if (mid is too large) { hi = mid - 1; }  // Narrow to the left half
    else { lo = mid + 1; }                         // Narrow to the right half
}
```

### Sentinel Value

A sentinel value is a special value used to avoid out-of-bounds access on arrays. Using `Integer.MIN_VALUE` (the minimum integer value) and `Integer.MAX_VALUE` (the maximum integer value) ensures that comparison conditions remain valid even in boundary cases.

```java
Integer.MIN_VALUE;  // -2147483648 — used as a value smaller than any element
Integer.MAX_VALUE;  //  2147483647 — used as a value larger than any element
```

## Complexity

| | Value |
|---|---|
| Time | O(log(min(m, n))) — The algorithm performs binary search on the shorter array |
| Space | O(1) — The algorithm uses only variables and creates no additional data structures |

## Code

```java
// Input: two sorted integer arrays n1 and n2
// Output: the median of the merged arrays, returned as a double
public double findMedian(int[] n1, int[] n2) {
    // Swap and recurse if n1 is longer, so binary search runs on the shorter array.
    // This minimizes the search range and achieves O(log(min(m, n)))
    if (n1.length > n2.length)
        return findMedian(n2, n1);

    int m = n1.length, n = n2.length;
    // Number of elements in the left half. Adding 1 makes the left half one element
    // larger when the total is odd, so the maximum of the left half becomes the median
    int half = (m + n + 1) / 2;
    // Search range for cut1: 0 (take nothing from n1) to m (take all of n1)
    int lo = 0, hi = m;

    while (lo <= hi) {
        // Determine how many elements to take from n1 using the binary search midpoint
        int cut1 = (lo + hi) / 2;
        // Determine how many elements to take from n2 (auto-determined so the left half totals half)
        int cut2 = half - cut1;

        // Last element of n1's left portion (when cut1=0 the left portion is empty,
        // so use a sentinel value smaller than any element to keep the comparison valid)
        int l1 = cut1 == 0 ?
            Integer.MIN_VALUE :
            n1[cut1 - 1];
        // Last element of n2's left portion (use sentinel value when cut2=0)
        int l2 = cut2 == 0 ?
            Integer.MIN_VALUE :
            n2[cut2 - 1];
        // First element of n1's right portion (when cut1=m the right portion is empty,
        // so use a sentinel value larger than any element to keep the comparison valid)
        int r1 = cut1 == m ?
            Integer.MAX_VALUE :
            n1[cut1];
        // First element of n2's right portion (use sentinel value when cut2=n)
        int r2 = cut2 == n ?
            Integer.MAX_VALUE :
            n2[cut2];

        // Cross comparison: the partition is correct when every left element ≤ every right element
        if (l1 <= r2 && l2 <= r1) {
            // Found the correct partition
            if ((m + n) % 2 == 1)
                // Odd total: the maximum of the left half is the median
                return Math.max(l1, l2);
            // Even total: the median is the average of the left-half max and the right-half min
            return (Math.max(l1, l2)
                + Math.min(r1, r2))
                / 2.0;
        } else if (l1 > r2) {
            // n1's left-end exceeds n2's right-start → taking too many from n1 → decrease cut1
            hi = cut1 - 1;
        } else {
            // l2 > r1: taking too few from n1 → increase cut1
            lo = cut1 + 1;
        }
    }
    // The problem constraints guarantee a correct partition exists, so this line is unreachable
    return -1;
}
```
