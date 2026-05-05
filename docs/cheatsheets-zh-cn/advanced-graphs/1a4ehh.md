# Finding the Cheapest Flight With Limited Stops — 在最多k次中转内找到最便宜的航班

## 问题本质

给定 `n` 个城市、航班列表 `[from, to, price]`、出发地 `src`、目的地 `dst` 和最大中转次数 `k`。返回从出发地到目的地在**最多k次中转**（经过的中间城市不超过k个）内可达的最低总票价。如果无法到达，则返回 `-1`。

## 核心思想

普通的Dijkstra算法只追踪成本最小的路径，但在本问题中，"成本较高但中转次数较少的路径"有可能最终成为最便宜的路线。因此，需要记录到达每个城市的"最少中转次数"，仅将以更少中转次数到达的路径保留为探索对象，从而在同时考虑成本和中转次数的情况下求得最优解。

## 思考过程

1. **寻找最便宜路径的基本方法是Dijkstra算法**: 这是一个加权图的最短路径问题，因此基本方针是使用优先队列的Dijkstra算法。按成本从小到大的顺序取出节点，当第一次到达目的地时，该路径即为最便宜的路径
2. **如何处理中转次数的限制**: 普通的Dijkstra算法遵循"以最小成本到达过的城市不再重访"的原则，但本问题存在中转次数的限制。如果以最小成本到达的路径中转次数超过了k次，则该路径无效；而成本稍高但中转次数更少的路径可能是有效的
3. **记录到达每个城市的"最少中转次数"**: 准备数组 `stops[]`，记录到达每个城市的最少中转次数。如果到达某个城市时的中转次数比之前更多，则该路径在成本和中转次数上都没有改善，因此可以进行剪枝
4. **在优先队列中保存什么**: 将每个状态以 `[成本, 城市, 中转次数]` 的三元组进行管理。按成本升序取出，当第一次到达目的地时，该解即为最便宜的解
5. **整理剪枝条件**: (a) 如果当前中转次数大于等于该城市已记录的最少中转次数，则终止探索。(b) 如果中转次数超过k，则不再向相邻城市展开
6. **向相邻城市展开**: 仅在通过剪枝条件的情况下，对每个相邻城市将 `[当前成本 + 票价, 相邻城市, 中转次数 + 1]` 加入队列

## 前置知识

### 邻接表（Adjacency List）

邻接表是一种数据结构，为图中的每个顶点维护一个列表，记录从该顶点可直接到达的顶点及边的权重。使用 `HashMap<Integer, List<int[]>>` 表示，其中键为出发城市，值为 `[到达城市, 票价]` 的列表。

```java
Map<Integer, List<int[]>> adj = new HashMap<>();
// 添加从城市0到城市1票价为100的航班
adj.computeIfAbsent(0, x -> new ArrayList<>()).add(new int[]{1, 100});
// 获取城市0的邻接列表
List<int[]> neighbors = adj.get(0);  // → [[1, 100]]
```

### PriorityQueue（优先队列）

优先队列是一种数据结构，添加元素后内部会自动排序，始终可以从头部取出最小（或最大）的元素。在Dijkstra算法中，优先队列用于高效地取出"成本最小的状态"。

```java
// 按int[]的第0个元素（成本）升序排列的优先队列
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{100, 1, 0});   // 添加 [成本=100, 城市=1, 中转=0]
pq.offer(new int[]{50, 2, 1});    // 添加 [成本=50, 城市=2, 中转=1]
int[] min = pq.poll();            // 取出成本最小的 [50, 2, 1]
pq.isEmpty();                      // 判断队列是否为空 → false
```

### 使用stops数组进行剪枝

在普通的Dijkstra算法中，使用 `visited` 数组管理已访问的城市，但在本问题中，需要区分以"不同中转次数"到达同一城市的路径。在 `stops[]` 数组中记录到达每个城市的最少中转次数，对以更多中转次数到达的路径进行截断，从而排除不必要的探索。

```java
int[] stops = new int[n];
Arrays.fill(stops, k + 2);  // k+2是一个足够大的初始值，表示"尚未到达"
// 以1次中转到达城市2的情况
stops[2] = 1;
// 之后以2次中转到达城市2 → 2 >= stops[2]，因此进行剪枝（跳过）
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(E · log n) — 对于每个航班（边），向优先队列的添加和取出操作需要 log n 的时间 |
| Space | O(n + E) — 邻接表占用 O(E)，stops数组占用 O(n)，队列最多保持 O(E) 个状态 |

## 代码

```java
// 输入: 城市数 n、航班数组 flights（每个元素为 [from, to, price]）、出发地 src、目的地 dst、最大中转次数 k
// 输出: 返回在最多k次中转内从出发地到目的地的最低票价（int类型）。如果无法到达则返回 -1
public int findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
    // 构建邻接表。键=出发城市，值=[到达城市, 票价]的列表
    // 对于每个航班 f，将 [f[1], f[2]] 添加到 adj 中键为 f[0] 的列表中
    Map<Integer, List<int[]>> adj = new HashMap<>();
    for (int[] f : flights)
        adj.computeIfAbsent(f[0], x -> new ArrayList<>())
            .add(new int[]{f[1], f[2]});

    // 按成本升序排列的优先队列。每个状态为 [成本, 城市, 中转次数]
    // 优先取出成本最小的状态，这样第一次到达目的地时即为最便宜的路径
    PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
    // 初始状态: 以成本0、中转0次到达出发地
    pq.offer(new int[]{0, src, 0});

    // 记录到达每个城市的最少中转次数的数组
    // k+2 是比中转上限 k 足够大的值，作为"尚未到达"的初始值
    int[] stops = new int[n];
    Arrays.fill(stops, k + 2);

    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int cost = curr[0];
        int city = curr[1];
        int stop = curr[2];

        // 到达目的地时，由于按成本升序取出，因此这是最便宜的路径
        if (city == dst) return cost;

        // 如果以比之前更多（或相同）的中转次数到达该城市，则进行剪枝
        // 由于按成本升序取出，之前的到达成本也更小 → 没有继续探索的意义
        if (stop >= stops[city]) continue;
        // 更新到达该城市的最少中转次数
        stops[city] = stop;

        // 如果中转次数超过上限k，则无法从该城市继续向相邻城市展开
        if (stop > k) continue;

        // 如果该城市没有出发的航班，则跳过
        if (!adj.containsKey(city)) continue;

        // 对每个相邻城市，将 [累计成本, 相邻城市, 中转次数+1] 加入队列
        for (int[] next : adj.get(city)) {
            pq.offer(new int[]{cost + next[1], next[0], stop + 1});
        }
    }

    // 循环结束后仍未到达目的地，则返回 -1
    return -1;
}
```
