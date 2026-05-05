# Counting the Number of Islands in a Grid — 计算网格中岛屿的数量

## 问题的本质

给定一个由 `'1'`（陆地）和 `'0'`（水）组成的二维网格。将水平方向或垂直方向上相邻的陆地单元格的集合视为一个"岛屿"，返回网格中岛屿的**总数**。

## 核心思想

将每个陆地单元格视为一个节点，使用Union-Find将相邻的陆地单元格逐步合并，最终剩余的独立组（根）的数量就是岛屿的数量。

## 思考过程

1. **岛屿就是"连通分量"**: 相邻陆地单元格的集合构成一个岛屿，因此该问题可以归结为求网格上连通分量的数量
2. **Union-Find适合管理连通分量**: Union-Find能够以近似O(1)的时间复杂度执行"将两个元素合并到同一组"和"判断两个元素是否属于同一组"的操作。将网格中每个陆地单元格作为元素，只需依次合并相邻单元格即可求出连通分量
3. **将二维网格的单元格转换为一维索引**: 由于Union-Find的数组是一维的，需要将单元格 `(i, j)` 通过 `i * n + j`（n为列数）转换为一个整数。这样就可以将二维网格上的单元格作为Union-Find的元素来处理
4. **初始化时统计陆地单元格的数量**: 将每个陆地单元格的 `parent` 设置为自身，并用陆地单元格的总数初始化 `count`（岛屿数量）。此时每个陆地单元格都是一个独立的岛屿
5. **通过与相邻单元格的合并来减少岛屿数量**: 遍历网格，对于每个陆地单元格，如果其右方和下方的相邻单元格也是陆地，则执行 `union` 操作。每当 `union` 将两个不同的组合并时，`count` 减1。只检查右方和下方，因为左方和上方在之前的单元格遍历时已经处理过，这样可以覆盖所有相邻关系
6. **最终剩余的count即为答案**: 所有合并操作完成后的 `count` 就是独立连通分量的数量，即岛屿的数量

## 前置知识

### 什么是Union-Find（并查集数据结构）

一种将多个元素分组管理的数据结构。它提供两种操作："将两个元素合并到同一组（union）"和"查询某个元素属于哪个组（find）"。通过 `parent` 数组管理每个元素的父节点，用树结构表示组。

```java
int[] parent = new int[n];   // parent[i] = 元素i的父节点
int[] rank = new int[n];     // rank[i] = 以元素i为根的树的高度上限

// 初始化: 将每个元素的父节点设置为自身（每个元素为独立的组）
for (int i = 0; i < n; i++)
    parent[i] = i;
```

### 什么是路径压缩（Path Compression）

在执行 `find` 操作时，将搜索路径上所有节点的父节点直接指向根节点的优化方法。递归找到根节点后，通过 `parent[x] = find(parent[x])` 将父节点更新为根节点。这使得后续的 `find` 操作接近O(1)。

```java
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);  // 将父节点指向根节点
    return parent[x];
}
```

### 什么是按秩合并（Union by Rank）

在执行 `union` 操作时，将树高度（rank）较低的一方连接到较高的一方下面的方法。这可以抑制树高度的增长，保持 `find` 的搜索效率。只有当双方的rank相等时，合并后才将rank加1。

```java
void union(int x, int y) {
    int rx = find(x), ry = find(y);  // 分别找到各自的根节点
    if (rx == ry) return;            // 如果已经在同一组则不做任何操作
    if (rank[rx] < rank[ry])         // 将rank较低的一方连接到较高的一方下面
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;                  // 只有rank相等时才增加rank
    }
}
```

### 从二维索引到一维索引的转换

将二维网格的单元格 `(i, j)` 转换为一维数组索引的公式。设列数为 `n`，则通过 `id = i * n + j` 可以转换为唯一的整数。

```java
int m = 3, n = 4;          // 3行4列的网格
int id = i * n + j;        // 单元格(1, 2) → 1 * 4 + 2 = 6
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(m × n × α(m × n)) — 遍历所有单元格，每个单元格最多执行2次union/find操作。α是阿克曼函数的反函数，实际上可视为常数 |
| Space | O(m × n) — parent数组和rank数组各存储 m × n 个元素 |

## 代码

```java
// 输入: 由 '1'（陆地）和 '0'（水）组成的 char[][] grid
// 输出: 以 int 形式返回网格中岛屿的数量

int[] parent;
int[] rank;
int count;

// 带路径压缩的find: 返回元素x的根节点，并将路径上所有节点的父节点指向根节点
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);
    return parent[x];
}

// 按秩合并: 将两个元素合并到同一组，成功时将count减1
void union(int x, int y) {
    int rx = find(x), ry = find(y);
    if (rx == ry) return;       // 如果已经在同一组则不做任何操作
    if (rank[rx] < rank[ry])
        parent[rx] = ry;       // 将rank较低的一方连接到较高的一方下面
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;             // 只有rank相等时才增加rank
    }
    count--;                    // 两个组合并为一个，因此将岛屿数量减1
}

public int numIslandsUF(char[][] grid) {
    // 获取网格的行数m和列数n
    int m = grid.length;
    int n = grid[0].length;
    // 创建大小为 m * n 的parent数组和rank数组
    parent = new int[m * n];
    rank = new int[m * n];
    // 将岛屿数量初始化为0（之后的遍历中统计陆地单元格的数量）
    count = 0;

    // 初始化: 将每个陆地单元格的父节点设置为自身（i * n + j），并将count设为陆地单元格的总数
    // 此时每个陆地单元格都是一个独立的岛屿
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            parent[i * n + j] = i * n + j;  // 将二维索引转换为一维并将父节点设置为自身
            count++;                          // 每个陆地单元格使count加1
        }

    // 对于每个陆地单元格，如果右邻和下邻是陆地则进行合并
    // 只检查右方和下方两个方向的原因: 左方和上方在之前的单元格遍历时已经处理完毕
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            int id = i * n + j;              // 计算当前单元格的一维索引
            if (j + 1 < n && grid[i][j + 1] == '1')
                union(id, id + 1);           // 与右邻的陆地单元格合并（id + 1 是右邻的一维索引）
            if (i + 1 < m && grid[i + 1][j] == '1')
                union(id, id + n);           // 与下邻的陆地单元格合并（id + n 是下邻的一维索引）
        }

    // count从初始值（陆地单元格总数）开始，每次union成功合并时减1，最终值即为岛屿的数量
    return count;
}
```
