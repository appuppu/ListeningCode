# 计算柱子之间蓄积雨水量 — Calculating Trapped Rainwater Between Bars

## 问题本质

给定一个非负整数数组 `height`，每个元素表示宽度为1的柱子的高度，构成一张高低差地图。计算并返回下雨之后柱子与柱子之间能够蓄积的**水的总量**。

## 核心思路

某个位置能够蓄积的水量，等于"左侧最大高度与右侧最大高度中较小的一方"减去"该位置柱子的高度"。从左右两端分别向内侧移动指针，同时更新各自一侧的最大高度，就可以在不使用额外数组的情况下计算每个位置的蓄水量。

## 思考过程

1. **每个位置的蓄水量由左右最大高度决定**：某个位置 `i` 能够蓄积的水量为 `min(左侧最大高度, 右侧最大高度) - height[i]`。因为水只能蓄积到左右两侧墙壁中较低一方的高度为止
2. **需要高效地求出左右最大高度**：如果对每个位置都重新遍历左右两侧来求最大高度，时间复杂度为 O(n²)。准备两个数组进行预计算可以降至 O(n)，但需要 O(n) 的空间。考虑用 O(1) 空间实现的方法
3. **从左右两端向内侧移动指针**：在左端放置指针 `left`，在右端放置指针 `right`，向内侧移动。用变量 `maxLeftHeight` 和 `maxRightHeight` 分别追踪各指针一侧迄今为止遇到的最大高度
4. **移动较小一侧的指针**：当 `height[left] <= height[right]` 时，可以保证左侧最大高度不超过右侧最大高度。因为右侧至少存在一面高度不低于 `height[right]` 的墙壁。因此，在左侧指针的位置上，仅凭 `maxLeftHeight` 就能确定蓄水量
5. **移动指针后累加蓄水量**：将指针向前移动一步后，在新位置更新最大高度，并将 `maxLeftHeight - height[left]`（或 `maxRightHeight - height[right]`）累加到蓄水量中。由于最大高度始终不小于当前柱子的高度，因此该差值必定为0以上
6. **两个指针相遇时结束**：在 `left < right` 的条件下持续循环，返回所有位置蓄水量的总和 `totalwater`

## 前置知识

### Two Pointers（双指针）

在数组的两端或不同位置放置两个指针，根据条件移动其中一个进行遍历的方法。可以通过一次遍历处理整个数组，适用于已排序数组和从两端进行探索的场景。

```java
int left = 0;                    // 左端指针
int right = height.length - 1;   // 右端指针
while (left < right) {           // 循环直到两个指针相遇
    // 根据条件通过 left++ 或 right-- 将指针向内侧移动
}
```

### Math.max

返回两个值中较大一方的Java静态方法。在这里用于每次指针移动时更新迄今为止的最大高度。

```java
int maxHeight = 3;
maxHeight = Math.max(maxHeight, 5);  // maxHeight 更新为 5
maxHeight = Math.max(maxHeight, 2);  // maxHeight 保持为 5（因为 2 < 5）
```

### 蓄水条件

某个位置要能蓄水，该位置的左右两侧都必须存在比当前柱子更高的墙壁。蓄水量等于"左右墙壁中较低一方的高度"减去"当前柱子的高度"。

```
// height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]
// 位置2（高度0）：左侧最大=1，右侧最大=3 → min(1,3) - 0 = 1 的水被蓄积
// 位置5（高度0）：左侧最大=2，右侧最大=3 → min(2,3) - 0 = 2 的水被蓄积
```

## 复杂度

| | 值 |
|---|---|
| Time | O(n) — 左右指针总共移动n次，对数组进行一次遍历 |
| Space | O(1) — 仅使用指针和最大高度的变量，不需要额外的数组 |

## 代码

```java
// 输入：非负整数数组 height（每个元素表示柱子的高度）
// 输出：以 int 返回柱子之间蓄积的水的总量
public int trap(int[] height) {
    // 将蓄积水的总量变量初始化为0
    int totalwater = 0;

    // 将左指针设置在数组开头，右指针设置在数组末尾
    int left = 0;
    int right = height.length - 1;

    // 初始化左右各自迄今为止的最大高度
    // 因为两端的柱子本身不会蓄水，所以将其作为初始值使用
    int maxLeftHeight = height[left];
    int maxRightHeight = height[right];

    // 循环直到两个指针相遇
    while (left < right) {
        // 当 height[left] <= height[right] 时，右侧至少存在一面高度为 height[right] 的墙壁
        // 因此仅凭左侧最大高度就能确定蓄水量
        if (height[left] <= height[right]) {
            // 将指针向右移动一步后计算蓄水量
            left++;
            // 更新迄今为止的左侧最大高度
            maxLeftHeight = Math.max(maxLeftHeight, height[left]);
            // 因为 maxLeftHeight 始终不小于 height[left]，所以累加值必定为0以上
            totalwater += maxLeftHeight - height[left];
        } else {
            // 当 height[left] > height[right] 时，左侧至少存在一面高度为 height[left] 的墙壁
            // 因此仅凭右侧最大高度就能确定蓄水量
            right--;
            // 更新迄今为止的右侧最大高度
            maxRightHeight = Math.max(maxRightHeight, height[right]);
            // 因为 maxRightHeight 始终不小于 height[right]，所以累加值必定为0以上
            totalwater += maxRightHeight - height[right];
        }
    }
    // 循环结束后，返回所有位置蓄水量的总和 totalwater
    return totalwater;
}
```
