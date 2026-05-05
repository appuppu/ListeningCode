# Searching for a Target in a Rotated Sorted Array — 在旋转排序数组中搜索目标值

## 问题的本质

一个升序排列的整数数组在某个未知的枢轴处进行了旋转。需要在该数组中查找给定的 `target` 值，并返回其索引。如果 `target` 不存在，则返回 `-1`。所有元素均唯一。

## 核心思路

将旋转排序数组从中间分割后，左半部分和右半部分中必定有一半是有序的。通过范围检查判断 `target` 是否在有序的那一半中，如果不在则搜索另一半，从而每次将搜索范围缩小一半。

## 思考过程

1. **因为是排序数组，所以希望使用Binary Search**：对于普通的排序数组，可以用Binary Search在 O(log n) 内完成搜索。即使存在旋转，也要考虑如何维持这一效率
2. **将旋转数组从中间分割后，必定有一半是有序的**：将数组 `[4,5,6,7,0,1,2]` 在 `mid=3`（值为7）处分割，左半部分 `[4,5,6,7]` 是有序的，右半部分 `[0,1,2]` 也是有序的。由于旋转的枢轴只会包含在其中一半，因此另一半必定保持升序
3. **如何判断哪一半是有序的**：如果 `nums[left] <= nums[mid]` 成立，则左半部分是有序的。如果不成立，则右半部分是有序的。之所以包含等号，是为了正确处理 `left == mid` 的情况（即元素数量不超过2个时）
4. **判断target是否在有序的那一半中**：由于有序的那一半的最小值和最大值已知，因此可以通过不等式判断 `target` 是否在该范围内。例如，如果左半部分是有序的，则通过 `target >= nums[left] && target < nums[mid]` 来判断
5. **搜索包含target的那一半**：如果 `target` 在有序那一半的范围内，则将搜索范围缩小到该半部分。如果在范围之外，则 `target` 应该存在于另一半中，因此搜索另一半
6. **循环结束时的处理**：如果搜索到 `left > right` 仍未找到 `target`，则说明数组中不存在 `target`，返回 `-1`

## 前置知识

### Binary Search（二分查找）

在排序数组中，通过检查搜索范围的中间元素并将搜索范围缩小一半的操作反复进行的搜索方法。由于每次范围缩小一半，因此可以在 O(log n) 的时间复杂度内完成搜索。

```java
int left = 0;
int right = nums.length - 1;
while (left <= right) {                    // 在搜索范围有效时持续循环
    int mid = left + (right - left) / 2;   // 防止溢出的中间值计算
    // 将 nums[mid] 与 target 进行比较，更新 left 或 right
}
```

### 旋转排序数组

将一个升序排列的数组在某个位置切开，把后半部分移到前面形成的数组。例如，将 `[0,1,2,4,5,6,7]` 在索引4处旋转后变为 `[4,5,6,7,0,1,2]`。虽然整个数组不是有序的，但枢轴左右两部分各自是有序的。

```
原始数组:   [0, 1, 2, 4, 5, 6, 7]
旋转后:     [4, 5, 6, 7, 0, 1, 2]
             有序↑      ↑有序
```

## 复杂度

| | 值 |
|---|---|
| Time | O(log n) — 由于每次将搜索范围缩小一半，最多只需 log n 次比较 |
| Space | O(1) — 仅使用 left、right、mid 三个变量，不需要额外的数据结构 |

## 代码

```java
// 输入: 旋转排序整数数组 nums 和整数 target
// 输出: 以 int 类型返回 target 的索引。如果不存在则返回 -1
public int search(int[] nums, int target) {
    // 初始化搜索范围的两端。这两个变量表示搜索范围的左右边界
    int left = 0;
    int right = nums.length - 1;

    // 当 left > right 时，表示搜索范围已经为空
    while (left <= right) {
        // 使用此公式而非 (left + right) / 2，是为了防止 left + right 的整数溢出
        int mid = left + (right - left) / 2;

        // 如果中间元素与target相等，则返回该索引
        if (nums[mid] == target) {
            return mid;
        }

        // 判断左半部分是否有序
        // 包含等号是为了在 left == mid（搜索范围不超过2个元素）时，能正确判定左半部分为有序
        if (nums[left] <= nums[mid]) {
            // 判断target是否在左半部分的范围内
            if (target >= nums[left] && target < nums[mid]) {
                right = mid - 1;  // target在左半部分的范围内，因此缩小到左半部分
            } else {
                left = mid + 1;   // target在左半部分的范围外，因此缩小到右半部分
            }
        // 右半部分有序的情况
        } else {
            // 判断target是否在右半部分的范围内
            if (target > nums[mid] && target <= nums[right]) {
                left = mid + 1;   // target在右半部分的范围内，因此缩小到右半部分
            } else {
                right = mid - 1;  // target在右半部分的范围外，因此缩小到左半部分
            }
        }
    }

    // 搜索范围已为空，因此target不存在于数组中
    return -1;
}
```
