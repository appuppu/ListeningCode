# Finding the Smallest Interval Containing Each Query — 找出包含每个查询的最小区间

## 问题的本质

给定一个二维整数数组 `intervals`（每个元素为 `[left, right]`）和一个整数数组 `queries`。对于每个查询值，找出包含该查询值的所有区间中**大小最小的区间**。区间的大小定义为 `right - left + 1`。如果不存在包含该查询值的区间，则返回 `-1`。

## 核心思路

将查询和区间同时排序，按照查询值从小到大的顺序进行处理，这样对于每个查询，可以依次将"左端点不超过查询值的区间"添加到 Min-Heap 中。从 Min-Heap 中取出大小最小且右端点不小于查询值的区间，该区间即为答案。

## 思考过程

1. **对每个查询遍历所有区间效率太低**：对每个查询遍历所有区间的时间复杂度为 O(n×q)。如果将查询和区间都进行排序，则可以在所有查询之间共享区间的添加处理，消除重复遍历
2. **按升序处理查询使区间添加操作具有单调性**：将区间按左端点排序，将查询按值升序排序后，随着查询值的增大，满足"左端点不超过查询值"条件的区间只会增加不会减少。因此区间的添加只需推进指针，是一个单调操作
3. **需要从已添加的区间中快速获取最小大小**：从候选区间中取出大小最小的区间，适合使用 Min-Heap（最小堆）。将区间大小作为堆的键，通过 peek 操作可以在 O(1) 时间内获取最小大小的区间
4. **右端点小于查询值的区间无效**：堆中右端点小于查询值的区间不包含该查询值。这些区间从堆顶依次 poll 移除即可。由于查询值是递增的，一旦移除的区间在后续查询中也同样无效，因此无需重新添加
5. **需要保留查询的原始顺序**：虽然对查询进行了排序处理，但结果需要按原始顺序返回。因此在排序前将每个查询与其原始索引配对保存，并将答案写入结果数组的对应位置
6. **堆为空则表示不存在包含该查询的区间**：移除无效区间后如果堆为空，则表示不存在包含该查询值的区间，将 `-1` 存入结果

## 前置知识

### 什么是 PriorityQueue（Min-Heap）

PriorityQueue 是一种按优先级顺序管理元素的数据结构。默认情况下最小值位于队首（Min-Heap）。添加和取出元素的时间复杂度为 O(log n)，查看队首元素的时间复杂度为 O(1)。

```java
// 存储 int[]，按数组第 0 个元素（大小）升序排列的 Min-Heap
PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[0] - b[0]);
heap.offer(new int[]{5, 10});  // 添加元素
heap.peek();                    // 查看队首元素但不移除 → {5, 10}
heap.poll();                    // 取出并移除队首元素 → {5, 10}
heap.isEmpty();                 // 判断堆是否为空 → true
```

### 什么是离线查询

离线查询是一种不按查询到达顺序，而是将查询重新排列为便于处理的顺序后再进行处理的方法。处理完成后，使用原始索引将结果写回正确的位置。该方法在查询之间没有依赖关系时有效。

```java
int q = queries.length;
int[][] sortedQ = new int[q][2];
for (int i = 0; i < q; i++) {
    sortedQ[i] = new int[]{queries[i], i};  // 创建 {查询值, 原始索引} 的配对
}
Arrays.sort(sortedQ, (a, b) -> a[0] - b[0]);  // 按查询值升序排序
```

### Arrays.sort 的自定义比较器

可以按任意标准对二维数组或对象数组进行排序。Lambda 表达式 `(a, b) -> a[0] - b[0]` 表示按每个元素的第 0 个值升序排序。

```java
int[][] intervals = {{3, 6}, {1, 4}, {2, 8}};
Arrays.sort(intervals, (a, b) -> a[0] - b[0]);  // 按左端点升序排序 → {{1,4}, {2,8}, {3,6}}
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n log n + q log q) — 区间排序为 O(n log n)，查询排序为 O(q log q)，堆操作中每个区间最多添加一次和删除一次，因此为 O(n log n) |
| Space | O(n + q) — 堆中最多存储 n 个区间，排序后的查询数组中存储 q 个元素 |

## 代码

```java
// 输入：二维整数数组 intervals（每个元素为 [left, right]）和整数数组 queries
// 输出：返回 int[]，其中存储包含每个查询的最小区间大小。如果不存在包含该查询的区间，则存储 -1
public int[] minInterval(int[][] intervals, int[] queries) {
    // 将区间按左端点升序排序。这样只需向前推进指针 j，即可不遗漏地添加所有"左端点不超过查询值的区间"
    Arrays.sort(intervals, (a, b) -> a[0] - b[0]);

    int q = queries.length;
    // 为每个查询附加原始索引形成配对。排序后需要使用原始索引将结果写回正确位置
    int[][] sortedQ = new int[q][2];
    for (int i = 0; i < q; i++) {
        sortedQ[i] = new int[]{queries[i], i};
    }
    // 按查询值升序排序。按升序处理可使区间添加操作具有单调性
    Arrays.sort(sortedQ, (a, b) -> a[0] - b[0]);

    // 存储 {区间大小, 右端点}，按大小升序取出的 Min-Heap。以大小为键，可在 O(1) 时间内查看最小区间
    PriorityQueue<int[]> heap =
        new PriorityQueue<>((a, b) -> a[0] - b[0]);

    int[] res = new int[q];
    int j = 0;  // 遍历区间数组的指针。在所有查询处理过程中只向前移动，因此区间添加的总量为 O(n)

    for (int[] sq : sortedQ) {
        int val = sq[0], idx = sq[1];  // val=查询值，idx=原始索引

        // 将所有左端点不超过查询值的区间添加到堆中。j 不会回退，因此整体为 O(n)
        while (j < intervals.length && intervals[j][0] <= val) {
            int sz = intervals[j][1] - intervals[j][0] + 1;  // 区间大小 = right - left + 1
            heap.offer(new int[]{sz, intervals[j][1]});  // 将 {大小, 右端点} 添加到堆中
            j++;
        }

        // 移除右端点小于查询值（不包含该查询）的区间。由于查询值递增，一旦移除的区间在后续查询中也同样无效
        while (!heap.isEmpty() && heap.peek()[1] < val) {
            heap.poll();
        }

        // 如果堆为空则不存在包含该查询的区间，否则堆顶的区间大小即为答案（无效区间已移除，因此堆顶是最小且有效的）
        res[idx] = heap.isEmpty() ? -1 : heap.peek()[0];
    }
    return res;
}
```
