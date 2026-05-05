# 在图中查找冗余边 — 从树加一条边构成的图中找出多余的边

## 问题的本质

给定一个由n个节点和n-1条边构成的树，再添加1条边后恰好形成1个环（循环）的图。要求找出并返回被添加的多余边。移除该边后，图将重新变为有效的树。

## 核心思路

逐条处理边时，如果出现一条连接"已经属于同一连通分量的两个节点"的边，那么该边就是产生环的多余边。Union-Find是进行此判定的最佳数据结构。

## 思考过程

1. **利用树的性质**: 树是用n-1条边连接n个节点的结构，不存在环。在此基础上添加1条边后恰好产生1个环。因此，只需在逐条添加边的过程中检测"产生环的边"即可
2. **考虑环的检测条件**: 添加边(u, v)时，如果u和v已经属于同一连通分量，则该边会形成环。反之，如果u和v属于不同的连通分量，则该边只是合并两个分量，不会产生环
3. **Union-Find适合管理连通分量**: Union-Find是一种能够高速执行"判断两个节点是否属于同一连通分量"和"合并两个连通分量"操作的数据结构。通过find操作比较根节点即可判定是否属于同一分量，通过union操作即可合并分量
4. **Union-Find的优化**: 通过路径压缩（path compression），在每次find操作时将节点直接连接到根节点。通过按秩（rank）合并，抑制树的高度增长。这两项优化使每次操作的时间复杂度降为α(n)（反阿克曼函数，实质上为常数）
5. **按顺序处理边**: 从头到尾依次处理给定的边数组，对每条边尝试执行union操作。union失败的边（即已经属于同一分量的边）就是多余的边，将其返回
6. **最终返回值**: 将union操作失败的边作为 `int[]` 返回。根据题目约束，必定存在1条多余的边，因此不存在找不到答案的情况

## 前置知识

### Union-Find（并查集）是什么

将多个元素划分为若干组（连通分量），并能高速执行"判断两个元素是否属于同一组"和"合并两个组"操作的数据结构。使用 `parent` 数组表示组的树结构，若各元素的根（代表元素）相同，则判定为属于同一组。

```java
int[] parent = new int[n + 1];  // parent[i]保存节点i的父节点
int[] rank = new int[n + 1];    // rank[i]是以节点i为根的树的高度上限
for (int i = 1; i <= n; i++)
    parent[i] = i;              // 初始状态下每个节点的父节点为自身（所有节点各自独立成组）
```

### find 操作（带路径压缩）

返回节点x所属组的根（代表元素）。递归地追溯父节点，并将路径上的所有节点直接连接到根节点（路径压缩）。这使得后续的find操作更加高效。

```java
int find(int[] parent, int x) {
    if (parent[x] != x)                    // 如果x不是根节点
        parent[x] = find(parent, parent[x]); // 递归追溯父节点，并将其直接连接到根节点
    return parent[x];                       // 返回x的根节点
}
```

### union 操作（按秩合并）

合并两个节点所属的组。将秩（树的高度上限）较小的一方连接到较大的一方下面，以抑制树的高度增长。如果两个节点已经属于同一组，则不进行合并并返回 `false`。

```java
boolean union(int[] parent, int[] rank, int x, int y) {
    int rx = find(parent, x);  // 获取x的根节点
    int ry = find(parent, y);  // 获取y的根节点
    if (rx == ry) return false; // 属于同一组则无需合并 → 返回false
    // 将秩较小的一方连接到秩较大的一方下面
    if (rank[rx] < rank[ry]) parent[rx] = ry;
    else if (rank[rx] > rank[ry]) parent[ry] = rx;
    else { parent[ry] = rx; rank[rx]++; }  // 秩相同则将一方连接到另一方下面，并将秩加1
    return true;  // 合并成功 → 返回true
}
```

### 反阿克曼函数 α(n) 是什么

表示Union-Find每次操作时间复杂度的函数。α(n) 增长极其缓慢，对于现实中的输入规模（n < 2^65536），α(n) ≤ 4，因此可以视为实质上的常数。

## 复杂度

| | 值 |
|---|---|
| Time | O(n × α(n)) ≈ O(n) — 对n条边分别执行一次find和union操作。由于α(n)实质上为常数，因此可视为O(n) |
| Space | O(n) — parent数组和rank数组各保存n+1个元素 |

## 代码

```java
// 输入: 边的数组 edges（每个元素为 int[]{u, v}，表示连接节点u和节点v的边）
// 输出: 以 int[] 形式返回形成环的多余边

// 返回节点x所属组的根节点（带路径压缩）
int find(int[] parent, int x) {
    if (parent[x] != x)
        // 递归追溯父节点，并将其直接连接到根节点（路径压缩）
        parent[x] = find(parent,
            parent[x]);
    return parent[x];
}

// 合并两个节点所属的组。如果已经属于同一组则返回false
boolean union(int[] parent,
        int[] rank, int x, int y) {
    int rx = find(parent, x); // 获取x的根节点
    int ry = find(parent, y); // 获取y的根节点
    if (rx == ry) return false; // 已经属于同一连通分量 → 会产生环，因此返回false
    // 将秩较小的一方连接到秩较大的一方下面，以抑制树的高度增长
    if (rank[rx] < rank[ry])
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        // 秩相同则将一方连接到另一方下面，并将秩加1
        parent[ry] = rx;
        rank[rx]++;
    }
    return true; // 合并成功 → 未产生环
}

public int[] findRedundantConnection(
        int[][] edges) {
    // 边的数量 = 节点的数量（树的n-1条 + 多余的1条 = n条）。节点编号从1到n
    int n = edges.length;
    // 将每个节点初始化为独立的组（parent[i] = i，自身为根节点）
    int[] parent = new int[n + 1];
    int[] rank = new int[n + 1]; // rank数组保持默认值0即可
    for (int i = 1; i <= n; i++)
        parent[i] = i;

    // 从头到尾逐条处理边，检测形成环的边
    for (int[] e : edges) {
        // 当union返回false时，e[0]和e[1]已经属于同一连通分量
        // → 该边是形成环的多余边，直接返回
        if (!union(parent, rank,
                e[0], e[1]))
            return e;
    }
    // 根据题目约束，必定存在1条多余的边，因此不会到达此处
    return new int[0];
}
```
