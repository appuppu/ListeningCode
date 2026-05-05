# Counting Connected Components in an Undirected Graph — 计算无向图中连结成分的数量

## 问题的本质

给定 `n` 个标记为 `0` 到 `n-1` 的节点和一个无向边列表 `edges`。要求以整数形式返回图中**连结成分（connected component）的数量**。连结成分是指通过边可以相互到达的节点的集合。

## 核心思路

首先将每个节点视为独立的连结成分，然后逐条处理边，将边两端节点所属的组合并。处理完所有边后剩余的组数即为连结成分的数量。

## 思考过程

1. **通过边相连的节点属于同一组**: 连结成分是"通过边可以到达的节点的集合"，因此由边连接的两个节点必然属于同一个连结成分。对所有边重复执行"将两端节点合并到同一组"的操作，最终即可求得连结成分
2. **Union-Find 适合管理组**: Union-Find 是一种能够高速执行"将两个元素合并到同一组（union）"和"查询某个元素属于哪个组（find）"的数据结构。为每个节点设置"父节点"，将根（root）相同的节点视为同一组
3. **初始状态下每个节点以自身为父节点**: 通过将 `parent[i] = i` 初始化，最初 n 个节点各自成为独立的组（连结成分）。初始连结成分数量为 `n`
4. **每处理一条边就执行 union，发生合并时减少成分数**: 对于每条边 `[a, b]`，求出 `a` 的根和 `b` 的根。若根不同则属于不同的组，将一方的根作为另一方根的子节点进行合并，并将连结成分数减 1。若根相同则已属于同一组，无需操作
5. **通过路径压缩和秩进行加速**: 在 find 时执行路径压缩（path compression），将访问过的节点的父节点直接指向根。在 union 时比较秩（树高度的上限），将较矮的树挂在较高的树下方（union by rank）。由此，find 的时间复杂度接近 O(1)（准确地说是 O(α(V))）
6. **处理完所有边后的 `components` 即为答案**: 从初始值 `n` 开始，每次 union 成功就减 1，最终结果即为连结成分的数量

## 前置知识

### 什么是 Union-Find（不相交集合数据结构）

Union-Find 是一种将元素分组管理的数据结构。它提供两种操作："将两个元素合并到同一组（union）"和"求某个元素所属组的代表（根）（find）"。通过 `parent` 数组记录每个元素的父节点，沿父节点追溯到根来确定组的代表。

```java
int[] parent = new int[n];   // parent[i] 保存节点 i 的父节点
for (int i = 0; i < n; i++)
    parent[i] = i;            // 初始状态: 每个节点以自身为父节点（独立的组）
```

### 什么是路径压缩（Path Compression）

路径压缩是一种在 find 的递归过程中，将访问过的所有节点的父节点直接指向根的优化技术。使得后续的 find 能够立即返回根，通过将树扁平化使时间复杂度改善到接近 O(1)。

```java
int find(int[] parent, int x) {
    if (parent[x] != x)
        parent[x] = find(parent, parent[x]);  // 递归找到根，并将父节点指向根
    return parent[x];                          // 返回根
}
```

### 什么是按秩（Rank）合并

按秩合并是在 union 时比较树高度的上限（秩），将秩较低的树挂在秩较高的树下方的技术。通过抑制树高度的增长来维持 find 的效率。仅当秩相等时，才将合并目标的秩增加 1。

```java
int[] rank = new int[n];     // rank[i] 是以节点 i 为根的树的高度上限（初始值为 0）
// 将秩较高的一方作为父节点 → 树不容易变深
if (rank[r1] > rank[r2])
    parent[r2] = r1;         // 将 r2 的树挂在 r1 下方
```

### 什么是 α（阿克曼函数的反函数）

α 是出现在 Union-Find 时间复杂度中的函数。对于实际输入规模，α(V) 始终不超过 5，可以视为事实上的常数。因此，Union-Find 的每个操作几乎以 O(1) 运行。

## 计算复杂度

| | 值 |
|---|---|
| Time | O(V + E · α(V)) — 初始化需要 O(V)，对每条边执行 find 和 union，但 α(V) 几乎是常数，因此实质上为 O(V + E) |
| Space | O(V) — parent 数组和 rank 数组各保存 V 个元素 |

## 代码

```java
// 输入: 节点数 n 和边列表 edges（每条边是包含两个元素的数组 [a, b]）
// 输出: 以整数形式返回连结成分的数量

// 带路径压缩的 find 函数: 返回节点 x 所属组的根
int find(int[] parent, int x) {
    if (parent[x] != x)
        // 递归地找到根，并将父节点直接指向根（路径压缩）
        // 由此使后续的 find 能够立即返回根
        parent[x] = find(parent, parent[x]);
    return parent[x];
}

int countComponents(int n, int[][] edges) {
    // 保存每个节点的父节点的数组。以 parent[i] = i 初始化，使每个节点成为独立的组
    int[] parent = new int[n];
    // 保存以每个节点为根的树的高度上限的数组（在 union 时用于决定挂在哪一方下面）
    int[] rank = new int[n];
    for (int i = 0; i < n; i++)
        parent[i] = i;

    // 初始状态下每个节点是独立的连结成分，因此成分数为 n
    int components = n;

    // 逐条遍历边，将两端节点所属的组进行合并
    for (int[] e : edges) {
        // 求边两端节点所属组的根（通过路径压缩，访问过的节点的父节点也会被指向根）
        int r1 = find(parent, e[0]);
        int r2 = find(parent, e[1]);

        // 若根不同则属于不同的组，进行合并（若根相同则已属于同一组，无需操作）
        if (r1 != r2) {
            // 比较秩，将较低的一方挂在较高的一方下面（抑制树高度的增长）
            if (rank[r1] > rank[r2])
                parent[r2] = r1;
            else if (rank[r1] < rank[r2])
                parent[r1] = r2;
            else {
                // 秩相等时，将 r2 挂在 r1 下面并将 r1 的秩增加 1
                parent[r2] = r1;
                rank[r1]++;
            }
            // 两个组合并为一个，因此成分数减 1
            components--;
        }
    }
    // 处理完所有边后的 components 即为连结成分的数量
    return components;
}
```
