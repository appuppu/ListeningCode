# Finding Cells That Drain to Both Oceans — 找出所有能夠流向兩個海洋的儲存格

## 問題的本質

給定一個 m×n 的高度矩陣。太平洋與上邊和左邊相鄰，大西洋與下邊和右邊相鄰。水從當前儲存格流向相鄰儲存格的條件是相鄰儲存格的高度小於或等於當前儲存格的高度。求出所有能夠同時到達太平洋和大西洋**兩者**的儲存格。

## 核心思路

如果從每個儲存格正向判定是否能到達海洋，計算會產生大量重複。反過來，從海洋的邊界儲存格向內側以「水能逆流的方向（高度相同或更高的相鄰儲存格）」進行 BFS，就能以 O(m*n) 的時間複雜度求出能夠到達每個海洋的儲存格集合，兩個集合的交集即為答案。

## 思考過程

1. **正向探索效率低下**：從每個儲存格 (i,j) 探索到達海洋的路徑，需要對 O(m*n) 個儲存格分別執行 BFS/DFS，整體時間複雜度為 O((m*n)²)。由於每個儲存格的獨立探索存在大量重複，因此考慮反向探索
2. **將思路反轉為逆向**：「水從儲存格流向海洋」等價於「從海洋到儲存格存在一條高度非遞減的路徑」。從海洋邊界沿逆流方向進行 BFS，即可一次性求出所有可到達的儲存格集合
3. **獨立處理兩個海洋**：將太平洋的邊界儲存格（上邊＋左邊）全部加入佇列並執行 BFS，記錄可到達的儲存格。對大西洋的邊界儲存格（下邊＋右邊）也同樣執行 BFS。兩次探索互相獨立，因此可以複用相同的邏輯
4. **確定 BFS 的轉移條件**：由於是逆流，當相鄰儲存格的高度**大於或等於**當前儲存格時才進行轉移。這是「水從高處流向低處」的反向條件
5. **取交集**：在兩次 BFS 中都被標記為已到達的儲存格，就是能夠流向兩個海洋的儲存格。遍歷所有儲存格，將兩者皆為 true 的儲存格加入結果列表

## 前置知識

### Multi-source BFS（多源點 BFS）是什麼

一般的 BFS 從一個起點開始，而多源點 BFS 是將多個起點在開始前全部加入佇列，然後再開始 BFS 的方法。這等同於從所有起點同時展開探索，能夠在一次 BFS 中求出從所有起點可到達的儲存格。

```java
Queue<int[]> queue = new LinkedList<>();
// 將所有起點全部加入佇列
queue.offer(new int[]{0, 0});
queue.offer(new int[]{0, 1});
queue.offer(new int[]{0, 2});
// 在一次 while 迴圈中從所有起點同時進行探索
while (!queue.isEmpty()) {
    int[] cell = queue.poll();
    // 根據條件探索相鄰儲存格
}
```

### 使用 boolean[][] 管理已訪問狀態

使用二維 boolean 陣列記錄每個儲存格是否已被到達。初始值為 false，將已到達的儲存格設為 true。這可以防止重複處理同一個儲存格。

```java
boolean[][] reach = new boolean[m][n];  // 初始化為 m×n 的 false 陣列
reach[r][c] = true;   // 將儲存格 (r,c) 標記為已到達
if (!reach[nr][nc])   // 判定儲存格 (nr,nc) 是否尚未到達
```

### 四方向移動向量

用陣列表示網格上的上下左右移動。透過迴圈依次嘗試四個方向，可以在不重複撰寫程式碼的情況下處理各方向的分支。

```java
int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};  // 右、左、下、上
for (int[] d : dirs) {
    int nr = r + d[0];  // 新的列索引
    int nc = c + d[1];  // 新的行索引
}
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(m×n) — 每次 BFS 最多訪問每個儲存格一次，共執行兩次 BFS |
| Space | O(m×n) — 兩個 boolean 陣列和 BFS 佇列各自最多持有 m×n 個儲存格 |

## 程式碼

```java
// 輸入：m×n 的整數矩陣 heights（每個儲存格的高度）
// 輸出：以 List<List<Integer>> 返回能夠流向兩個海洋的儲存格座標

// 上下左右四方向的移動向量
int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};

// 執行多源點 BFS，以 boolean 陣列返回可到達的儲存格
boolean[][] bfs(int[][] h, Queue<int[]> q) {
    int m = h.length, n = h[0].length;
    // 記錄每個儲存格是否能透過逆流從海洋到達的陣列
    boolean[][] reach = new boolean[m][n];

    // 將佇列中的所有起點標記為已到達（邊界儲存格直接與海洋相鄰）
    for (int[] c : q)
        reach[c[0]][c[1]] = true;

    while (!q.isEmpty()) {
        int[] cell = q.poll();
        int r = cell[0], c = cell[1];

        // 檢查四個方向的相鄰儲存格
        for (int[] d : dirs) {
            int nr = r + d[0];
            int nc = c + d[1];

            // 若在範圍內且未到達且高度大於或等於當前值（可逆流），則擴展探索
            // 高度大於或等於當前值的條件表示「水從高處流向低處」的反向
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

    // 建立太平洋和大西洋的佇列（Multi-source BFS 的起點集合）
    Queue<int[]> pQ = new LinkedList<>();
    Queue<int[]> aQ = new LinkedList<>();

    // 上邊直接與太平洋相鄰，因此作為太平洋的起點；下邊直接與大西洋相鄰，因此作為大西洋的起點
    for (int j = 0; j < n; j++) {
        pQ.offer(new int[]{0, j});
        aQ.offer(new int[]{m - 1, j});
    }

    // 左邊直接與太平洋相鄰，因此作為太平洋的起點；右邊直接與大西洋相鄰，因此作為大西洋的起點
    for (int i = 0; i < m; i++) {
        pQ.offer(new int[]{i, 0});
        aQ.offer(new int[]{i, n - 1});
    }

    // 從每個海洋執行逆流 BFS，取得可到達儲存格的集合
    boolean[][] pacReach = bfs(heights, pQ);
    boolean[][] atlReach = bfs(heights, aQ);

    // 將能夠到達兩個海洋的儲存格加入結果列表
    // 兩者皆為 true 表示該儲存格的水既能流向太平洋也能流向大西洋
    List<List<Integer>> res = new ArrayList<>();
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (pacReach[i][j] && atlReach[i][j])
                res.add(Arrays.asList(i, j));

    return res;
}
```
