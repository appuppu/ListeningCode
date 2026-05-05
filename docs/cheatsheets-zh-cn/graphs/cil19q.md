# 判断是否能完成所有课程 — 全コースを完了できるかを判定する

## 问题的本质

给定 `numCourses` 个标记为 `0` 到 `n-1` 的课程，以及一个前置条件对的列表 `prerequisites`。每个对 `[a, b]` 表示"必须先修完课程 `b` 才能修课程 `a`"。要求以 `boolean` 返回是否能修完所有课程。这是一个检测有向图中是否存在环（循环依赖）的问题。

## 核心思路

将课程的依赖关系视为有向图后，能否修完所有课程等价于"图中是否不存在环"。从入度（指向该节点的边的数量）为0的节点开始依次处理，执行拓扑排序，如果能处理所有节点，则说明不存在环。

## 思考过程

1. **将问题转化为图**: 将每个课程作为节点，将每个前置条件 `[a, b]` 作为从 `b` 到 `a` 的有向边，构建邻接表。这样就能用图结构表示依赖关系
2. **存在环则无法全部修完**: 如果课程A依赖B，B又依赖A，形成循环，则两者都无法先修。因此问题归结为"有向图中是否存在环"的判定
3. **关注入度**: 统计每个节点的入度（前置条件的数量）。入度为0的节点没有前置条件，可以立即修读。以这些节点作为起点即可
4. **将入度为0的节点加入队列并开始处理**: 类似BFS，使用队列依次处理入度为0的节点。将已处理节点的出边所指向的节点的入度减1，当入度变为0时将该节点加入队列
5. **通过已处理节点数进行判定**: 如果能处理所有节点（已处理计数 == `numCourses`），则不存在环，可以修完所有课程。环内的节点入度永远不会变为0，因此会留下未处理的节点

## 前置知识

### 邻接表（Adjacency List）

邻接表是一种表示图的数据结构。对于每个节点，保存从该节点出发的边所指向的节点列表。使用 `List<List<Integer>>` 实现，通过 `graph.get(i)` 获取节点 `i` 的邻接节点列表。

```java
List<List<Integer>> graph = new ArrayList<>();
for (int i = 0; i < n; i++)
    graph.add(new ArrayList<>());  // 为每个节点创建空列表
graph.get(0).add(1);               // 添加从节点0到节点1的边
graph.get(0);                       // 获取节点0的邻接节点列表 → [1]
```

### 入度（In-degree）

在有向图中，指向某个节点的边的数量。入度为0的节点不依赖于任何其他节点。使用数组 `inDegree[i]` 管理节点 `i` 的入度。

```java
int[] inDegree = new int[n];   // 将所有节点的入度初始化为0
inDegree[0]++;                  // 将节点0的入度加1
```

### Queue（队列）

队列是一种先进先出（FIFO）的数据结构。在BFS中用于管理待处理的节点。使用 `offer` 在末尾添加元素，使用 `poll` 从头部取出元素。

```java
Queue<Integer> queue = new LinkedList<>();
queue.offer(0);       // 将0添加到队列中
queue.poll();          // 取出并返回队列头部的元素 → 0
queue.isEmpty();       // 以boolean返回队列是否为空 → true
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(V + E) — 对所有节点（V个）和所有边（E条）各处理一次 |
| Space | O(V + E) — 邻接表存储所有边，入度数组和队列存储所有节点 |

## 代码

```java
// 输入: 课程数 numCourses 和前置条件数组 prerequisites（每个元素为 [a, b]，表示"b → a"的依赖关系）
// 输出: 如果能修完所有课程则返回 true，如果存在环导致无法修完则返回 false
boolean canFinish(int numCourses, int[][] prerequisites) {
    // 存储每个节点入度（前置条件数量）的数组。入度表示"该课程有多少个前置条件"
    int[] inDegree = new int[numCourses];

    // 使用邻接表构建图。graph.get(i) 是从节点 i 出发的边所指向的节点列表
    List<List<Integer>> graph = new ArrayList<>();
    for (int i = 0; i < numCourses; i++)
        graph.add(new ArrayList<>());

    // 根据每个前置条件添加边并更新入度。由此完成依赖关系图和各节点入度的构建
    for (int[] p : prerequisites) {
        graph.get(p[1]).add(p[0]);  // 添加 p[1] → p[0] 的边
        inDegree[p[0]]++;           // 将 p[0] 的入度加1
    }

    // 将入度为0的节点（无前置条件）添加到队列中。这些是最先可以修读的课程
    Queue<Integer> queue = new LinkedList<>();
    for (int i = 0; i < numCourses; i++)
        if (inDegree[i] == 0)
            queue.offer(i);

    // 使用BFS从入度为0的节点开始依次处理
    int count = 0;  // 跟踪已处理课程数的变量
    while (!queue.isEmpty()) {
        int course = queue.poll();
        count++;  // 将该节点视为已修完

        // 将邻接节点的入度减1（表示消化了一个前置条件）。当入度变为0时，说明所有前置条件已满足，将其加入队列
        for (int nei : graph.get(course))
            if (--inDegree[nei] == 0)
                queue.offer(nei);
    }

    // 如果能处理所有节点则不存在环（可以修完所有课程）。环内的节点入度不会变为0，因此会留下未处理的节点
    return count == numCourses;
}
```
