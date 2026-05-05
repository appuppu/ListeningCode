# Finding the Minimum Cost to Connect All Points — 以最小成本连接所有点

## 问题的本质

给定一个二维平面上的点数组 `points`。任意两点之间的成本定义为曼哈顿距离 `|xi - xj| + |yi - yj|`。返回连接所有点的**最小总成本**。这是一个求最小生成树（MST: Minimum Spanning Tree）的问题。

## 核心思路

要以最小成本连接所有点，可以使用 Prim 算法贪心地不断选择"距离当前 MST 最近的未访问点"。使用优先队列可以高效地取出最小成本的边。

## 思考过程

1. **这是一个 MST 问题**：连接所有点并使成本最小化。这正是最小生成树的定义。图的边权重可以通过曼哈顿距离来计算
2. **完全图适合使用 Prim 算法**：n 个点会产生 n(n-1)/2 条边。Kruskal 算法需要事先生成并排序所有边，而 Prim 算法只需逐步处理与当前 MST 相邻的边
3. **需要快速取出最小成本的边**：Prim 算法每次都需要选择"到未访问点的最小成本边"。使用优先队列（最小堆）可以在 O(log n) 时间内完成这一取出操作
4. **可以从任意点开始**：MST 的总成本从任何点开始都相同，因此从点 0 开始。初始状态下将到点 0 的成本 0 加入队列
5. **使用已访问标志防止重复**：如果从队列中取出的点已经包含在 MST 中，则跳过该点。这样可以防止对同一个点进行重复处理
6. **每次将新点加入 MST 时添加相邻边**：将点 u 加入 MST 后，计算从 u 到所有未访问点 v 的曼哈顿距离，并将其加入队列。队列会自动将最小成本的边作为下一个候选进行管理

## 前置知识

### 什么是最小生成树（MST）

最小生成树是连接图中所有顶点的子图中，边权重之和最小的子图。对于 n 个顶点，它恰好包含 n-1 条边，且不包含环。

### 什么是 Prim 算法

Prim 算法是一种构建 MST 的贪心算法。从任意顶点开始，反复选择"连接当前 MST 与未访问顶点的边中权重最小的边"来扩展 MST。当所有顶点都被包含在 MST 中时算法结束。

### 什么是曼哈顿距离

曼哈顿距离是两点之间各坐标差的绝对值之和。二维平面上点 `(x1, y1)` 与 `(x2, y2)` 之间的距离计算公式为 `|x1 - x2| + |y1 - y2|`。它相当于在网格状道路上行走时的最短距离。

```java
int dist = Math.abs(pts[u][0] - pts[v][0]) + Math.abs(pts[u][1] - pts[v][1]);
```

### 什么是 PriorityQueue（优先队列）

优先队列是一种能够按优先级顺序取出元素的数据结构。默认情况下最小值最先被取出（最小堆）。使用 `offer` 添加元素，使用 `poll` 取出最小元素，两种操作的时间复杂度均为 O(log n)。

```java
// 创建按 int[] 第 0 个元素升序排列的优先队列
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{5, 0});   // 添加 [成本=5, 点的索引=0]
pq.offer(new int[]{2, 1});   // 添加 [成本=2, 点的索引=1]
int[] min = pq.poll();       // 取出成本最小的元素 [2, 1]
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n² log n) — 每次将一个点加入 MST 时，最多将 n 条边加入队列，队列操作的时间复杂度为 log n |
| Space | O(n²) — 队列中最多存储 n² 条边。inMST 数组的空间复杂度为 O(n) |

## 代码

```java
// 输入: 二维坐标数组 pts（每个元素为 [x, y]）
// 输出: 以 int 形式返回连接所有点的最小成本
int minCostConnectPoints(int[][] pts) {
    // 获取点的数量
    int n = pts.length;
    // 管理每个点是否已包含在 MST 中的标志数组（全部初始化为 false）
    boolean[] inMST = new boolean[n];
    // 存储 {成本, 点的索引} 并按成本升序取出的优先队列
    PriorityQueue<int[]> pq =
        new PriorityQueue<>((a, b) -> a[0] - b[0]);
    // 将起始点（索引 0）以成本 0 加入队列
    // 成本 0 表示将第一个点加入 MST 的成本为 0
    // 由于 MST 的总成本从任何点开始都相同，因此任意选择点 0
    pq.offer(new int[]{0, 0});
    // cost: MST 的总成本，visited: 已加入 MST 的点的数量
    int cost = 0, visited = 0;

    // 重复执行直到所有点都被包含在 MST 中
    while (visited < n) {
        // 取出成本最小的边（d: 连接成本，u: 点的索引）
        int[] curr = pq.poll();
        int d = curr[0], u = curr[1];

        // 跳过已包含在 MST 中的点
        // 由于同一个点可能以不同成本被多次加入队列，因此需要这个判断
        if (inMST[u]) continue;

        // 将点 u 加入 MST，并累加成本
        inMST[u] = true;
        cost += d;
        visited++;

        // 将从点 u 到所有未访问点的边加入队列
        // 候选边被注册到队列中，队列自动管理最小成本的边
        for (int v = 0; v < n; v++) {
            if (!inMST[v]) {
                // 计算曼哈顿距离: |xu - xv| + |yu - yv|
                int nd =
                    Math.abs(pts[u][0] - pts[v][0])
                    + Math.abs(pts[u][1] - pts[v][1]);
                pq.offer(new int[]{nd, v});
            }
        }
    }
    // while 循环结束后，cost 中存储了 MST 的总成本
    return cost;
}
```
