# Searching for a Target in a Sorted Array — 在排序数组中查找目标值的位置

## 问题的本质

给定一个排序的整数数组 `nums` 和一个整数 `target`。在数组中找到与 `target` 匹配的元素，并返回该元素的**索引**。如果 `target` 不存在于数组中，则返回 `-1`。

## 核心思路

由于数组已排序，只需将中间元素与目标值进行比较，就能每次将搜索范围缩小一半。因此，搜索不需要检查所有元素的O(n)时间，而是以O(log n)时间完成。

## 思考过程

1. **利用数组已排序这一条件**: 由于数组已排序，查看任意位置的元素就能判断目标值在该位置的左侧还是右侧。利用这一性质，可以每次将搜索范围缩小一半
2. **用两个指针管理搜索范围**: 用两个指针 `left`（数组左端）和 `right`（数组右端）来表示搜索范围。初始状态下，整个数组都是搜索范围
3. **将中间元素与目标值进行比较**: 计算搜索范围的中间索引 `mid`，并将 `nums[mid]` 与 `target` 进行比较。如果匹配，则 `mid` 就是答案
4. **根据比较结果将搜索范围缩小一半**: 如果 `nums[mid] < target`，说明目标值在中间位置的右侧，因此通过 `left = mid + 1` 缩小左端。如果 `nums[mid] > target`，说明目标值在中间位置的左侧，因此通过 `right = mid - 1` 缩小右端
5. **重复直到搜索范围为空**: 只要 `left <= right`，就继续搜索。当 `left > right` 时，表示搜索范围已为空，目标值不存在于数组中，因此返回 `-1`
6. **防止计算中间索引时发生溢出**: `mid = (left + right) / 2` 可能导致 `left + right` 超过整数最大值。通过写成 `mid = left + (right - left) / 2` 来避免溢出

## 前置知识

### Binary Search（二分查找）的定义

二分查找是一种针对排序数组，通过每次将搜索范围缩小一半来高效查找目标元素的算法。将搜索范围的中间元素与目标值进行比较，如果不匹配，则丢弃左半部分或右半部分。通过重复此过程，搜索次数降为O(log n)。

```java
// 数组长度为8时的搜索次数
// 第1次: 8 → 4（缩小一半）
// 第2次: 4 → 2（缩小一半）
// 第3次: 2 → 1（缩小一半）
// 最多3次 = log₂(8) = 3
```

### 中间索引的计算

求两个指针 `left` 和 `right` 的中间位置。使用 `left + (right - left) / 2` 而非 `(left + right) / 2`，以防止 `left + right` 相加时发生整数溢出。

```java
int left = 0;
int right = 10;
int mid = left + (right - left) / 2;  // mid = 0 + (10 - 0) / 2 = 5
```

### while 循环条件 `left <= right`

`left <= right` 表示搜索范围中至少还剩一个元素。当 `left == right` 时，搜索范围中仅剩一个元素，由于仍需检查该元素，因此使用 `<=` 而非 `<`。

```java
// 当 left=3, right=3 时，nums[3] 尚未被检查
// left <= right 为 true，因此可以检查 nums[3]
// 如果使用 left < right 则为 false，会在未检查 nums[3] 的情况下结束
```

## 复杂度

| | 值 |
|---|---|
| Time | O(log n) — 由于每次将搜索范围缩小一半，最多只需 log₂(n) 次比较 |
| Space | O(1) — 仅使用指针变量，不需要额外的数据结构 |

## 代码

```java
// 输入: 排序的整数数组 nums 和整数 target
// 输出: 以 int 类型返回与 target 匹配的元素的索引。如果不存在则返回 -1
public int binarySearch(int[] nums, int target) {
    // 初始化搜索范围的左端和右端。用这两个变量管理搜索范围
    int left = 0;
    int right = nums.length - 1;

    // left <= right: 当搜索范围中至少还剩一个元素时，继续循环
    // 当 left > right 时，搜索范围为空，退出循环
    while (left <= right) {
        // 注意: (left + right) / 2 可能导致 left + right 相加时发生整数溢出
        // 通过写成 left + (right - left) / 2 来防止溢出
        int mid = left
            + (right - left) / 2;

        // 如果中间元素与目标值匹配，则返回该索引
        if (nums[mid] == target) {
            return mid;
        }

        // 如果目标值大于中间元素，则将搜索范围缩小到右半部分
        // 由于 mid 本身已经被检查过，因此设为 mid + 1
        if (nums[mid] < target) {
            left = mid + 1;
        }
        // 如果目标值小于中间元素，则将搜索范围缩小到左半部分
        // 由于 mid 本身已经被检查过，因此设为 mid - 1
        else {
            right = mid - 1;
        }
    }

    // 搜索范围已为空，因此目标值不存在于数组中
    return -1;
}
```
