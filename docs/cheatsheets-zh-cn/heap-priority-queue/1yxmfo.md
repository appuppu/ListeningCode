# Finding the K Closest Points to the Origin — 找到距离原点最近的K个点

## 问题的本质

给定二维平面上的点数组 `points` 和整数 `k`。返回距离原点 (0, 0) 的欧几里得距离最近的 `k` 个点。距离使用欧几里得距离来测量。答案可以按任意顺序返回。

## 核心思路

求"k个最近的点"不需要完全排序。使用Quickselect算法，只需通过枢轴对数组进行分区并找到第k个边界，左侧就会聚集k个最近邻点。

## 思考过程

1. **完全排序是过度的**: 只需返回k个最近邻点，顺序无所谓。也就是说，只要能将数据分为"最近的k个"和"其余的"即可。完全排序需要O(n log n)，而仅做分区可以更快完成
2. **用Quickselect寻找分区位置**: 利用Quicksort的分区操作，比枢轴小的元素聚集在左侧，比枢轴大的元素聚集在右侧。如果枢轴的最终位置恰好是k-1，那么左侧的k个元素就是答案
3. **简化距离计算**: 欧几里得距离是 `√(x² + y²)`，但如果只做大小比较，则不需要平方根，比较 `x² + y²` 就足够了。这样可以避免浮点运算
4. **分区操作的机制**: 选择最右端的元素作为枢轴，用 `storeIdx` 管理"放置小于等于枢轴的元素的下一个位置"。扫描过程中发现小于等于枢轴的元素时，将其与 `storeIdx` 位置交换，并将 `storeIdx` 前移
5. **根据枢轴的最终位置缩小搜索范围**: 分区后，枢轴位于 `storeIdx` 的位置。如果该位置小于 `k-1`，说明左侧元素不足，需搜索右半部分；如果大于等于 `k-1`，则搜索左半部分。通过这种反复操作，平均以O(n)完成分区
6. **最终返回前k个元素**: 循环结束时，数组的前k个元素就是最近邻点，使用 `Arrays.copyOfRange(points, 0, k)` 截取并返回

## 前置知识

### 什么是Quickselect

Quickselect是一种以平均O(n)的时间复杂度从数组中找到第k小元素的算法。通过只对一侧递归应用Quicksort的分区操作，无需完全排序即可确定目标位置。

```java
// 分区的基本结构
int pivotValue = arr[right];       // 选择最右端作为枢轴
int storeIdx = left;               // 放置小于等于枢轴的元素的位置
for (int i = left; i < right; i++) {
    if (arr[i] <= pivotValue) {    // 小于等于枢轴则集中到左侧
        swap(arr, i, storeIdx);
        storeIdx++;
    }
}
swap(arr, storeIdx, right);        // 将枢轴放到正确的位置
// storeIdx 是枢轴的最终位置
```

### 欧几里得距离的平方

到原点的距离是 `√(x² + y²)`，但如果只做大小比较，可以省略平方根，直接用 `x² + y²` 进行比较。因为平方根函数是单调递增的，所以距离的大小关系在距离的平方上也同样成立。

```java
private int dist(int[] point) {
    return point[0] * point[0] + point[1] * point[1];  // x² + y²
}
```

### 什么是Arrays.copyOfRange

Arrays.copyOfRange是Java的实用方法，用于复制数组的指定范围并作为新数组返回。

```java
int[][] result = Arrays.copyOfRange(points, 0, k);  // 复制索引0到k-1的k个元素
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n) 平均 — 由于分区只应用于一侧，平均经过 n + n/2 + n/4 + ... = 2n 次比较即可收敛 |
| Space | O(1) — 由于对输入数组进行原地重排，不使用额外内存 |

## 代码

```java
// 输入: 二维坐标数组 points（每个元素为 [x, y]）和整数 k
// 输出: 返回包含距离原点最近的 k 个点的 int[][]

// 返回点到原点的欧几里得距离的平方（因为大小比较不需要平方根，所以省略）
private int dist(int[] p) {
    return p[0] * p[0] + p[1] * p[1];
}

public int[][] kClosest(int[][] points, int k) {
    // 初始化搜索范围的左端和右端。在此范围内反复分区，使前k个元素成为最近邻点
    int left = 0;
    int right = points.length - 1;

    // 反复分区直到前k个元素成为最近邻点
    while (left < right) {
        // 选择最右端的点作为枢轴，计算其欧几里得距离的平方（x² + y²）
        int pivotDist = dist(points[right]);
        // storeIdx 管理"放置距离小于等于枢轴的点的下一个位置"
        int storeIdx = left;

        // 将每个点的距离与枢轴比较，将距离小于等于枢轴的点集中到左侧
        for (int i = left; i < right; i++) {
            if (dist(points[i]) <= pivotDist) {
                // 小于等于枢轴，交换到 storeIdx 位置以集中到左侧
                int[] temp = points[i];
                points[i] = points[storeIdx];
                points[storeIdx] = temp;
                storeIdx++;
            }
        }

        // 将枢轴放置到正确的最终位置 storeIdx。左侧是距离小于等于枢轴的点，右侧是距离大于枢轴的点
        int[] temp = points[storeIdx];
        points[storeIdx] = points[right];
        points[right] = temp;

        // 将枢轴的最终位置与 k-1 比较，将搜索范围缩小一半
        if (storeIdx < k - 1) {
            // 左侧元素不足k个，搜索右侧
            left = storeIdx + 1;
        } else {
            // 注意: 当 storeIdx 恰好等于 k-1 时，也通过缩小 right 使循环条件 left < right 为假从而结束循环
            right = storeIdx - 1;
        }
    }

    // 循环结束后，数组的前k个元素就是距离原点最近的k个点
    return Arrays.copyOfRange(points, 0, k);
}
```
