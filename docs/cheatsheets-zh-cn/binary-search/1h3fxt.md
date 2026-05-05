# Searching for a Value in a Sorted Matrix — 在排序矩阵中搜索目标值

## 问题的本质

给定一个 m×n 的矩阵。每行按升序排序，且每行的首元素大于前一行的末尾元素。判定给定的 `target` 是否存在于该矩阵中，并返回 `boolean`。

## 核心思路

将整个矩阵从左上到右下排成一列，可以视为一个排序数组。利用一维索引 `mid` 到矩阵坐标 `[mid / n][mid % n]` 的转换，无需将矩阵展平，即可通过一次二分查找以 O(log(m * n)) 的时间复杂度完成搜索。

## 思考过程

1. **整个矩阵是一个排序数组**：每行按升序排列，且下一行的首元素大于上一行的末尾元素，因此从左上到右下依次读取矩阵元素，整体构成一个升序排序数组
2. **排序数组可以使用二分查找**：总元素数为 `m * n` 个，因此在 0 到 `m * n - 1` 的范围内进行二分查找即可。设搜索范围的下界 `lo = 0`，上界 `hi = m * n - 1`
3. **需要将一维索引转换为二维坐标**：二分查找的中间点 `mid` 是一维索引。要从矩阵中获取值，需要二维坐标，因此将行索引转换为 `mid / n`（除以列数的商），列索引转换为 `mid % n`（除以列数的余数）
4. **应用标准的二分查找逻辑**：如果通过 `matrix[mid / n][mid % n]` 获取的值等于 `target`，则返回 `true`。如果该值较小，则令 `lo = mid + 1` 将搜索范围缩小到右半部分；如果该值较大，则令 `hi = mid - 1` 将搜索范围缩小到左半部分
5. **搜索范围耗尽则 target 不存在**：如果在 `lo > hi` 之前未匹配到，则 `target` 不存在于矩阵中，返回 `false`

## 前置知识

### 二分查找（Binary Search）

对排序数组每次将搜索范围缩小一半，从而快速找到目标值的算法。对于 n 个元素，最多进行 log₂(n) 次比较即可得到结果。

```java
int lo = 0, hi = array.length - 1;  // 设置搜索范围的下界和上界
while (lo <= hi) {                    // 在搜索范围存在时循环
    int mid = lo + (hi - lo) / 2;    // 在防止溢出的同时计算中间点
    if (array[mid] == target)         // 判断中间点的值是否与target一致
        return true;
    else if (array[mid] < target)
        lo = mid + 1;                // target在右半部分，因此提升下界
    else
        hi = mid - 1;                // target在左半部分，因此降低上界
}
return false;                         // 未找到的情况
```

### 一维索引与二维坐标的转换

在列数为 `n` 的矩阵中，将一维索引 `idx` 转换为二维坐标通过除法和取余来实现。通过此转换，可以将矩阵作为虚拟的一维数组来处理。

```java
int n = matrix[0].length;        // 获取列数
int row = idx / n;               // 商为行索引（例：idx=7, n=4 → row=1）
int col = idx % n;               // 余数为列索引（例：idx=7, n=4 → col=3）
int val = matrix[row][col];      // 通过二维坐标获取矩阵中的值
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(log(m * n)) — 对全部 m * n 个元素执行一次二分查找 |
| Space | O(1) — 仅使用指针变量，不需要额外的数据结构 |

## 代码

```java
// 输入：m×n 的整数矩阵 matrix 和整数 target
// 输出：如果 target 存在于矩阵中则返回 true，否则返回 false
public boolean searchMatrix(int[][] matrix, int target) {
    // 获取矩阵的行数和列数。用于计算总元素数和一维到二维的转换
    int m = matrix.length;
    int n = matrix[0].length;

    // 将二分查找的搜索范围设置为整个矩阵
    // lo=0 对应矩阵左上角，hi=m*n-1 对应矩阵右下角
    int lo = 0, hi = m * n - 1;

    // 当 lo > hi 时搜索范围耗尽，可以判定 target 不存在
    while (lo <= hi) {
        // 使用此形式而非 (lo + hi) / 2，以防止 lo + hi 的整数溢出
        int mid = lo + (hi - lo) / 2;

        // 将一维索引转换为二维坐标并获取值
        // 行索引 = mid / n（商），列索引 = mid % n（余数）
        int val = matrix[mid / n][mid % n];

        if (val == target)
            return true;           // 找到目标值，返回true
        else if (val < target)
            lo = mid + 1;          // target在右半部分（较大侧），因此提升下界
        else
            hi = mid - 1;          // target在左半部分（较小侧），因此降低上界
    }

    // 循环结束仍未返回true，说明target不存在于矩阵中
    return false;
}
```
