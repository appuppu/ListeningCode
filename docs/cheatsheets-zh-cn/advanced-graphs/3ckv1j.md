# 计算网络信号传播时间 — 求信号到达整个网络所有节点的最短时间

## 问题的本质

给定 `n` 个节点（1〜n）和一个加权有向边列表 `times`（每条边为 `[源节点, 目标节点, 所需时间]`）。从指定的源节点 `k` 发送信号时，返回信号到达所有节点的最短时间。如果存在任何一个不可达节点，则返回 `-1`。

## 核心思路

"信号到达所有节点的最短时间"等于"各节点最短距离中的最大值"。使用 Dijkstra 算法求出到所有节点的最短距离，取其最大值即可。

## 思考过程

1. **将问题视为最短路径问题**: 信号从源节点沿各边传播。每个节点接收到信号的时刻等于从源节点到该节点的最短距离。因此，只需求解单源最短路径问题即可
2. **高效求出到所有节点的最短距离**: 由于边的权重为非负值，可以使用 Dijkstra 算法。Dijkstra 算法使用优先队列（min-heap），以贪心策略从距离最小的节点开始逐步确定最短距离
3. **确定图的表示方法**: 使用邻接表。为每个节点维护一个包含"相邻节点及其边权重"的列表。这样可以高效地枚举从某个节点出发的所有边
4. **初始化距离数组**: 将所有节点的距离初始化为无穷大（`Integer.MAX_VALUE`），并将源节点 `k` 的距离设为0。因为从源节点到自身的距离为0
5. **使用优先队列处理最短距离节点**: 从队列中取出距离最小的节点，对该节点的相邻节点进行距离更新（松弛）。如果距离被更新，则将该节点加入队列
6. **跳过重复处理**: 如果从队列中取出的节点的距离大于当前已知的最短距离，说明该节点已通过更优路径处理过，因此跳过。这样可以避免不必要的计算
7. **根据所有节点的最短距离求出答案**: 遍历所有节点的距离数组，如果存在距离仍为无穷大的节点，则表示该节点不可达，返回 `-1`。否则，距离的最大值即为答案

## 前置知识

### 邻接表（Adjacency List）

邻接表是一种表示图的数据结构。为每个节点维护一个"从该节点出发的边的列表"。对于 `n` 个节点，使用 `List<List<int[]>>` 表示，通过 `graph.get(u)` 获取从节点 `u` 出发的所有边。

```java
List<List<int[]>> graph = new ArrayList<>();
for (int i = 0; i <= n; i++) {
    graph.add(new ArrayList<>());       // 为每个节点创建一个空列表
}
graph.get(1).add(new int[]{2, 5});      // 添加一条从节点1到节点2、权重为5的边
graph.get(1).add(new int[]{3, 2});      // 添加一条从节点1到节点3、权重为2的边
```

### PriorityQueue（优先队列）

优先队列是一种无论元素添加顺序如何，始终将最小（或最大）元素保持在队首的数据结构。在 Dijkstra 算法中，优先队列用于高效取出"距离最小的节点"。

```java
// 按 int[] 的第0个元素（距离）升序排列的 min-heap
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{0, 1});   // 将 {距离0, 节点1} 加入队列
pq.offer(new int[]{5, 2});   // 将 {距离5, 节点2} 加入队列
int[] curr = pq.poll();       // 取出距离最小的元素 {0, 1}
pq.isEmpty();                 // 返回队列是否为空的布尔值
```

### Dijkstra 算法的松弛（Relaxation）

当经由节点 `u` 到达节点 `v` 的距离 `dist[u] + w` 小于当前的 `dist[v]` 时，将 `dist[v]` 更新为更短的值。通过反复执行此更新操作，最终可以确定到所有节点的最短距离。

```java
int newDist = dist[u] + w;      // 计算经由u到达v的距离
if (newDist < dist[v]) {        // 如果小于当前最短距离
    dist[v] = newDist;          // 更新最短距离
    pq.offer(new int[]{newDist, v});  // 将更新后的v加入队列
}
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O((V + E) log V) — 对每个节点和每条边执行优先队列操作（log V） |
| Space | O(V + E) — 邻接表存储所有边，距离数组和队列占用节点数量的空间 |

## 代码

```java
// 输入: 有向边列表 int[][] times（每个元素为 [起点, 终点, 权重]）、节点数 int n、源节点 int k
// 输出: 以 int 形式返回信号从源节点到达所有节点的最短时间。如果存在不可达节点则返回 -1
public int networkDelayTime(int[][] times, int n, int k) {
    // 创建邻接表（节点编号从1开始，因此大小为n+1，索引0不使用）
    List<List<int[]>> graph = new ArrayList<>();
    for (int i = 0; i <= n; i++) {
        graph.add(new ArrayList<>());
    }
    // 将每条边 [u, v, w] 注册到邻接表中，完成有向图的邻接表表示
    for (int[] t : times) {
        graph.get(t[0]).add(new int[]{t[1], t[2]});
    }

    // 用无穷大初始化距离数组。dist[i] 表示"从源节点到节点 i 的当前最短距离"
    int[] dist = new int[n + 1];
    Arrays.fill(dist, Integer.MAX_VALUE);
    // 从源节点到自身的距离为0
    dist[k] = 0;

    // 创建按距离（第0个元素）升序取出的 min-heap，并将源节点 {距离0, 节点k} 加入
    PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
    pq.offer(new int[]{0, k});

    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int d = curr[0];  // 从源节点到节点u的距离
        int u = curr[1];  // 当前处理的节点

        // 如果 d > dist[u]，说明已通过更短距离处理过该节点。这种情况发生在队列中残留了旧的（距离较大的）条目时
        if (d > dist[u]) continue;

        // 尝试对相邻节点进行松弛
        for (int[] nei : graph.get(u)) {
            int v = nei[0];  // 相邻节点
            int w = nei[1];  // 边的权重
            // 如果经由u的距离 d + w 小于当前的 dist[v]，则更新距离并加入队列
            if (d + w < dist[v]) {
                dist[v] = d + w;
                pq.offer(new int[]{d + w, v});
            }
        }
    }

    // 求所有节点最短距离中的最大值。该最大值即为"信号到达所有节点的最短时间"
    int max = 0;
    for (int i = 1; i <= n; i++) {
        // 如果距离仍为 Integer.MAX_VALUE，则表示存在不可达节点，返回 -1
        if (dist[i] == Integer.MAX_VALUE) return -1;
        max = Math.max(max, dist[i]);
    }
    return max;
}
```
