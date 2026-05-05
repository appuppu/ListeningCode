# Finding Cells That Drain to Both Oceans — 找出所有能同时流向两个大洋的单元格

## 问题的本质

给定一个 m×n 的高度矩阵。太平洋与上边和左边相邻，大西洋与下边和右边相邻。水从当前单元格流向相邻单元格的条件是相邻单元格的高度小于等于当前单元格的高度。求所有能使水同时到达太平洋和大西洋的单元格。

## 核心思路

如果从每个单元格正向判断是否能到达海洋，会产生大量重复计算。反过来，从海洋的边界单元格向内部进行BFS，沿"水能逆流的方向（高度相同或更高的相邻单元格）"搜索，就能以 O(m*n) 的复杂度求出能到达每个海洋的单元格集合，两个集合的交集即为答案。

## 思考过程

1. **正向探索效率低下**: 从每个单元格(i,j)探索到海洋的路径，需要对 O(m*n) 个单元格分别执行BFS/DFS，总复杂度为 O((m*n)²)。由于每个单元格的独立探索存在大量重复，因此考虑反向探索
2. **转换为反向思维**: "水从单元格流向海洋"等价于"从海洋到单元格存在一条高度非递减的路径"。从海洋边界沿逆流方向进行BFS，就能一次性求出所有可达单元格的集合
3. **对两个海洋独立处理**: 将太平洋的边界单元格（上边+左边）全部加入队列进行BFS，记录可达单元格。对大西洋的边界单元格（下边+右边）同样进行BFS。两次探索相互独立，因此可以复用相同的逻辑
4. **确定BFS的转移条件**: 由于是逆流，当相邻单元格的高度**大于等于**当前单元格时才进行转移。这是"水从高处流向低处"的逆向表达
5. **取交集**: 两次BFS中都被标记为已到达的单元格，就是能同时流向两个海洋的单元格。遍历所有单元格，将两者都为true的单元格添加到结果列表中

## 前置知识

### Multi-source BFS（多源BFS）

普通的BFS从一个起点开始，而多源BFS在开始前将所有起点全部加入队列后再执行BFS。这样等效于从所有起点同时向外扩展探索，只需一次BFS就能求出从所有起点可达的单元格。

```java
Queue<int[]> queue = new LinkedList<>();
// 将所有起点全部添加到队列中
queue.offer(new int[]{0, 0});
queue.offer(new int[]{0, 1});
queue.offer(new int[]{0, 2});
// 在一次while循环中从所有起点同时进行探索
while (!queue.isEmpty()) {
    int[] cell = queue.poll();
    // 根据条件探索相邻单元格
}
```

### 使用 boolean[][] 管理已访问状态

使用二维boolean数组记录每个单元格是否已被到达。初始值为false，到达的单元格设为true。这可以防止对同一单元格的重复处理。

```java
boolean[][] reach = new boolean[m][n];  // 初始化为m×n的全false数组
reach[r][c] = true;   // 将单元格(r,c)标记为已到达
if (!reach[nr][nc])   // 判断单元格(nr,nc)是否尚未到达
```

### 四方向移动向量

用数组表示网格上的上下左右移动。通过循环依次尝试四个方向，可以避免对每个方向编写重复的代码。

```java
int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};  // 右、左、下、上
for (int[] d : dirs) {
    int nr = r + d[0];  // 新的行索引
    int nc = c + d[1];  // 新的列索引
}
```

## 复杂度

| | 值 |
|---|---|
| Time | O(m×n) — 每次BFS最多访问每个单元格一次，共执行两次BFS |
| Space | O(m×n) — 两个boolean数组和BFS队列各最多保存 m×n 个单元格 |

## 代码

```java
// 输入: m×n 的整数矩阵 heights（每个单元格的高度）
// 输出: 以 List<List<Integer>> 形式返回能同时使水到达两个海洋的单元格坐标

// 上下左右四个方向的移动向量
int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};

// 执行多源BFS，以boolean数组形式返回可达单元格
boolean[][] bfs(int[][] h, Queue<int[]> q) {
    int m = h.length, n = h[0].length;
    // 记录每个单元格是否能从海洋逆流到达的数组
    boolean[][] reach = new boolean[m][n];

    // 将队列中的所有起点标记为已到达（边界单元格直接与海洋相邻）
    for (int[] c : q)
        reach[c[0]][c[1]] = true;

    while (!q.isEmpty()) {
        int[] cell = q.poll();
        int r = cell[0], c = cell[1];

        // 检查四个方向的相邻单元格
        for (int[] d : dirs) {
            int nr = r + d[0];
            int nc = c + d[1];

            // 如果在范围内、尚未到达、且高度大于等于当前值（可逆流），则扩展探索
            // 高度大于等于当前值的条件是"水从高处流向低处"的逆向表达
            if (nr >= 0 && nr < m
                && nc >= 0 && nc < n
                && !reach[nr][nc]
                && h[nr][nc] >= h[r][c]) {
                reach[nr][nc] = true;
                q.offer(new int[]{nr, nc});
            }
        }
    }
    return reach;
}

List<List<Integer>> pacificAtlantic(int[][] heights) {
    int m = heights.length;
    int n = heights[0].length;

    // 创建太平洋和大西洋的队列（Multi-source BFS的起点集合）
    Queue<int[]> pQ = new LinkedList<>();
    Queue<int[]> aQ = new LinkedList<>();

    // 上边直接与太平洋相邻，作为太平洋的起点；下边直接与大西洋相邻，作为大西洋的起点
    for (int j = 0; j < n; j++) {
        pQ.offer(new int[]{0, j});
        aQ.offer(new int[]{m - 1, j});
    }

    // 左边直接与太平洋相邻，作为太平洋的起点；右边直接与大西洋相邻，作为大西洋的起点
    for (int i = 0; i < m; i++) {
        pQ.offer(new int[]{i, 0});
        aQ.offer(new int[]{i, n - 1});
    }

    // 执行从每个海洋出发的逆流BFS，获得可达单元格的集合
    boolean[][] pacReach = bfs(heights, pQ);
    boolean[][] atlReach = bfs(heights, aQ);

    // 将能同时到达两个海洋的单元格添加到结果列表中
    // 两者都为true意味着该单元格的水既能流向太平洋也能流向大西洋
    List<List<Integer>> res = new ArrayList<>();
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (pacReach[i][j] && atlReach[i][j])
                res.add(Arrays.asList(i, j));

    return res;
}
```
