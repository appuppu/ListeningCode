# Counting the Number of Islands in a Grid — 計算網格中島嶼的數量

## 問題的本質

給定一個由 `'1'`（陸地）和 `'0'`（水域）組成的二維網格。將水平方向或垂直方向相鄰的陸地單元格的集合視為一個「島嶼」，返回網格中島嶼的**總數**。

## 核心思路

將每個陸地單元格視為一個節點，利用 Union-Find 將相鄰的陸地單元格逐步合併，最終剩餘的獨立群組（根）的數量即為島嶼的數量。

## 思考過程

1. **島嶼就是「連通分量」**：相鄰陸地單元格的集合構成一個島嶼，因此這個問題可以歸結為求網格上連通分量的數量
2. **Union-Find 適合管理連通分量**：Union-Find 能夠以近乎 O(1) 的時間複雜度執行「將兩個元素合併到同一群組」和「判斷兩個元素是否屬於同一群組」的操作。將網格中的每個陸地單元格作為元素，只需依序合併相鄰單元格即可求得連通分量
3. **將二維網格的單元格轉換為一維索引**：Union-Find 的陣列是一維的，因此將單元格 `(i, j)` 透過 `i * n + j`（n 為列數）轉換為一個整數。這樣就能將二維網格上的單元格作為 Union-Find 的元素來處理
4. **在初始化階段計算陸地單元格的數量**：將每個陸地單元格的 `parent` 設定為自身，並以陸地單元格的總數初始化 `count`（島嶼數量）。此時每個陸地單元格都是一個獨立的島嶼
5. **透過合併相鄰單元格來減少島嶼數量**：遍歷網格，對於每個陸地單元格，若其右方和下方的相鄰單元格也是陸地，則執行 `union`。每當 `union` 合併兩個不同的群組時，`count` 減 1。只需檢查右方和下方，因為左方和上方在之前遍歷單元格時已經處理過，這樣就能涵蓋所有相鄰關係
6. **最終剩餘的 count 就是答案**：所有合併操作完成後的 `count` 就是獨立連通分量的數量，即島嶼的數量

## 前置知識

### 什麼是 Union-Find（不相交集合資料結構）

Union-Find 是一種將多個元素分組管理的資料結構。它提供兩種操作：「將兩個元素合併到同一群組（union）」和「查詢某個元素屬於哪個群組（find）」。透過 `parent` 陣列管理每個元素的父節點，並以樹狀結構表示群組。

```java
int[] parent = new int[n];   // parent[i] = 元素 i 的父節點
int[] rank = new int[n];     // rank[i] = 以元素 i 為根的樹的高度上限

// 初始化：將每個元素的父節點設定為自身（每個元素為一個獨立群組）
for (int i = 0; i < n; i++)
    parent[i] = i;
```

### 什麼是路徑壓縮（Path Compression）

路徑壓縮是在執行 `find` 操作時，將搜尋路徑上的所有節點的父節點直接指向根節點的最佳化手法。在遞迴找到根節點後，透過 `parent[x] = find(parent[x])` 將父節點更新為根節點。這使得後續的 `find` 操作接近 O(1)。

```java
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);  // 將父節點指向根節點
    return parent[x];
}
```

### 什麼是按秩合併（Union by Rank）

按秩合併是在執行 `union` 操作時，將樹的高度（rank）較低的一方接到較高的一方下面的手法。這能抑制樹的高度增長，維持 `find` 的搜尋效率。僅當兩者的 rank 相等時，合併後才將 rank 加 1。

```java
void union(int x, int y) {
    int rx = find(x), ry = find(y);  // 分別找到各自的根節點
    if (rx == ry) return;            // 若已屬於同一群組則不做任何操作
    if (rank[rx] < rank[ry])         // 將 rank 較低的一方接到較高的一方下面
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;                  // 僅當 rank 相等時才將 rank 加 1
    }
}
```

### 二維索引轉換為一維索引

將二維網格的單元格 `(i, j)` 轉換為一維陣列索引的公式。設列數為 `n`，則透過 `id = i * n + j` 可以轉換為唯一的整數。

```java
int m = 3, n = 4;          // 3 行 4 列的網格
int id = i * n + j;        // 單元格 (1, 2) → 1 * 4 + 2 = 6
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(m × n × α(m × n)) — 遍歷所有單元格，每個單元格最多執行 2 次 union/find 操作。α 是阿克曼函數的反函數，實際上可視為常數 |
| Space | O(m × n) — parent 陣列和 rank 陣列各儲存 m × n 個元素 |

## 程式碼

```java
// 輸入：由 '1'（陸地）和 '0'（水域）組成的 char[][] grid
// 輸出：以 int 返回網格中島嶼的數量

int[] parent;
int[] rank;
int count;

// 帶路徑壓縮的 find：返回元素 x 的根節點，並將路徑上所有節點的父節點指向根節點
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);
    return parent[x];
}

// 按秩合併：將兩個元素合併到同一群組，合併成功時將 count 減 1
void union(int x, int y) {
    int rx = find(x), ry = find(y);
    if (rx == ry) return;       // 若已屬於同一群組則不做任何操作
    if (rank[rx] < rank[ry])
        parent[rx] = ry;       // 將 rank 較低的一方接到較高的一方下面
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        parent[ry] = rx;
        rank[rx]++;             // 僅當 rank 相等時才將 rank 加 1
    }
    count--;                    // 兩個群組合併為一個，因此將島嶼數量減 1
}

public int numIslandsUF(char[][] grid) {
    // 取得網格的行數 m 和列數 n
    int m = grid.length;
    int n = grid[0].length;
    // 建立大小為 m * n 的 parent 陣列和 rank 陣列
    parent = new int[m * n];
    rank = new int[m * n];
    // 將島嶼數量初始化為 0（之後遍歷時計算陸地單元格的數量）
    count = 0;

    // 初始化：將每個陸地單元格的父節點設定為自身（i * n + j），並將 count 設為陸地單元格的總數
    // 此時每個陸地單元格各自為一個獨立的島嶼
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            parent[i * n + j] = i * n + j;  // 將二維索引轉換為一維並將父節點設定為自身
            count++;                          // 每個陸地單元格使 count 加 1
        }

    // 對於每個陸地單元格，若其右鄰和下鄰為陸地則進行合併
    // 只檢查右方和下方兩個方向的原因：左方和上方在之前遍歷單元格時已經處理完畢
    for (int i = 0; i < m; i++)
      for (int j = 0; j < n; j++)
        if (grid[i][j] == '1') {
            int id = i * n + j;              // 計算當前單元格的一維索引
            if (j + 1 < n && grid[i][j + 1] == '1')
                union(id, id + 1);           // 與右鄰的陸地單元格合併（id + 1 為右鄰的一維索引）
            if (i + 1 < m && grid[i + 1][j] == '1')
                union(id, id + n);           // 與下鄰的陸地單元格合併（id + n 為下鄰的一維索引）
        }

    // count 從初始值（陸地單元格總數）開始，每次 union 合併成功時減 1，最終值即為島嶼的數量
    return count;
}
```
