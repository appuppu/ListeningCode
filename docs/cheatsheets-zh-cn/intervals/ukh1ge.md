# Inserting a New Interval Into a Sorted List — 将新区间插入已排序的非重叠区间列表并合并

## 问题的本质

给定一个已排序且互不重叠的区间列表 `intervals` 和一个新区间 `newInterval`。将 `newInterval` 插入到正确的位置，如果存在重叠的区间则全部合并，最终返回一个非重叠的区间列表。

## 核心思路

从左到右扫描已排序的区间列表时，每个区间可以分为三组："完全在新区间之前"、"与新区间重叠"、"完全在新区间之后"。按照这三个阶段依次处理，只需一次扫描即可完成插入和合并。

## 思考过程

1. **区间的位置关系只有3种模式**: 已排序列表中的每个区间与 newInterval 比较后，可以分为"完全在前面"、"存在重叠"、"完全在后面"三种情况。利用这种分类方式，只需扫描列表一次即可完成处理
2. **"完全在前面"的判定条件**: 如果现有区间的终点 `intervals[i][1]` 小于 newInterval 的起点 `newInterval[0]`，则该区间与 newInterval 不重叠。将满足此条件的区间直接添加到结果中
3. **"存在重叠"的判定条件**: 如果现有区间的起点 `intervals[i][0]` 小于或等于 newInterval 的终点 `newInterval[1]`，则该区间与 newInterval 重叠。每当发现重叠区间时，更新 newInterval 的起点和终点以扩大合并范围
4. **合并的方法**: 取重叠区间的起点与 newInterval 起点中较小的一方作为新起点，取重叠区间的终点与 newInterval 终点中较大的一方作为新终点。通过这种方式，可以将多个重叠区间合并为一个区间
5. **添加合并结果的时机**: 当不再有重叠区间时，将合并后的 newInterval 添加到结果中。之后的区间全部在 newInterval 之后，直接添加到结果中即可
6. **最终返回的内容**: 将三个阶段构建的结果列表转换为 `int[][]` 并返回

## 前置知识

### 什么是 ArrayList

ArrayList 是可变长度的数组。通过 `add()` 方法添加元素的时间复杂度为 O(1)（均摊），最终可以转换为固定长度的数组。当结果的大小无法事先确定时使用 ArrayList。

```java
List<int[]> res = new ArrayList<>();   // 创建一个空的 ArrayList
res.add(new int[]{1, 3});              // 将元素添加到末尾
res.toArray(new int[0][]);             // 转换为 int[][] 类型的数组
```

### 什么是 Math.min / Math.max

Math.min 和 Math.max 是返回两个值中较小值和较大值的方法。在合并区间时用于确定起点和终点。

```java
Math.min(1, 3);   // → 1（返回较小的值）
Math.max(1, 3);   // → 3（返回较大的值）
```

### 区间的重叠判定

判断两个区间 `[a, b]` 和 `[c, d]` 是否重叠，可以通过 `a <= d && c <= b` 来判定。在本问题中，由于区间已排序，只需检查其中一个条件即可完成判定。

```java
// 现有区间完全在 newInterval 之前（不重叠）
intervals[i][1] < newInterval[0]   // 现有区间的终点 < 新区间的起点

// 现有区间与 newInterval 重叠
intervals[i][0] <= newInterval[1]  // 现有区间的起点 <= 新区间的终点
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n) — 只需扫描区间列表一次即可完成 |
| Space | O(n) — 结果列表最多保存 n+1 个区间 |

## 代码

```java
// 输入: 已排序的非重叠区间列表 intervals（int[][]）和新区间 newInterval（int[]）
// 输出: 将 newInterval 插入并合并后的非重叠区间列表，以 int[][] 形式返回
public int[][] insert(int[][] intervals, int[] newInterval) {
    // 存储结果的列表。由于大小无法事先确定，使用 ArrayList
    List<int[]> res = new ArrayList<>();
    // 跟踪扫描位置的变量
    int i = 0;
    // 将区间总数存入变量，避免在循环条件中每次引用 .length
    int n = intervals.length;

    // 阶段1: 将完全在 newInterval 之前的区间直接添加到结果中
    // 判定条件: 现有区间的终点 < newInterval 的起点，则不重叠
    while (i < n && intervals[i][1] < newInterval[0]) {
        res.add(intervals[i]);
        i++;
    }

    // 阶段2: 将所有与 newInterval 重叠的区间进行合并
    // 判定条件: 现有区间的起点 <= newInterval 的终点，则存在重叠
    while (i < n && intervals[i][0] <= newInterval[1]) {
        // 取较小的起点（将 newInterval 的左端扩展到重叠区间的左端）
        newInterval[0] = Math.min(newInterval[0], intervals[i][0]);
        // 取较大的终点（将 newInterval 的右端扩展到重叠区间的右端）
        newInterval[1] = Math.max(newInterval[1], intervals[i][1]);
        i++;
    }
    // 将合并后的 newInterval 添加到结果中（即使重叠区间数为0，也直接添加）
    res.add(newInterval);

    // 阶段3: 将完全在 newInterval 之后的区间直接添加到结果中（无需合并）
    while (i < n) {
        res.add(intervals[i]);
        i++;
    }

    // 将 ArrayList 转换为 int[][] 并返回。new int[0][] 是用于传递类型信息的空数组
    return res.toArray(new int[0][]);
}
```
