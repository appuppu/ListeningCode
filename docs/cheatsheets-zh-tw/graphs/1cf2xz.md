# Finding the Redundant Edge in a Graph — 在樹中多加一條邊的圖中，找出多餘的邊

## 問題的本質

給定一個由 n 個節點和 n-1 條邊組成的樹，再額外添加一條邊後恰好形成一個環（cycle）的圖。目標是找出並返回這條多餘的邊。移除該邊後，圖將重新成為一棵有效的樹。

## 核心思路

逐一處理每條邊時，如果出現一條連接「已經屬於同一連通分量的兩個節點」的邊，那麼該邊就是造成環的多餘邊。Union-Find 是進行此判定的最佳資料結構。

## 思考過程

1. **利用樹的性質**：樹是用 n-1 條邊連接 n 個節點的結構，不存在環。在此基礎上添加一條邊，恰好會產生一個環。因此，只需在依序添加邊的過程中，檢測出「產生環的邊」即可
2. **思考環的檢測條件**：添加邊 (u, v) 時，如果 u 和 v 已經屬於同一連通分量，則該邊會形成環。反之，如果 u 和 v 屬於不同的連通分量，則該邊只是合併兩個分量，不會產生環
3. **Union-Find 適合管理連通分量**：Union-Find 是能夠高效執行「判定兩個節點是否屬於同一連通分量」和「合併兩個連通分量」操作的資料結構。透過 find 操作比較根節點即可判定是否為同一分量，透過 union 操作即可合併分量
4. **Union-Find 的效率優化**：路徑壓縮（path compression）在每次 find 操作時將節點直接連接到根節點。按秩合併（union by rank）抑制樹的高度增長。這兩項優化使每次操作的時間複雜度降為 α(n)（反阿克曼函數，實際上為常數）
5. **依序處理每條邊**：從頭到尾依序處理給定的邊陣列，對每條邊嘗試執行 union 操作。union 失敗的邊（= 兩端點已屬於同一分量）即為多餘的邊，將其返回
6. **最終返回的結果**：將 union 操作失敗的邊以 `int[]` 形式返回。根據題目約束，必定存在一條多餘的邊，因此不會出現找不到答案的情況

## 前提知識

### Union-Find（不相交集合資料結構）是什麼

一種將多個元素分成若干群組（連通分量），並能高效執行「判定兩個元素是否屬於同一群組」和「合併兩個群組」操作的資料結構。使用 `parent` 陣列表示群組的樹結構，若各元素的根（代表元素）相同，則判定為同一群組。

```java
int[] parent = new int[n + 1];  // parent[i] 保存節點 i 的父節點
int[] rank = new int[n + 1];    // rank[i] 是以節點 i 為根的樹的高度上限
for (int i = 1; i <= n; i++)
    parent[i] = i;              // 初始狀態下，每個節點的父節點為自身（所有節點各自為獨立群組）
```

### find 操作（含路徑壓縮）

返回節點 x 所屬群組的根（代表元素）。遞迴地追溯父節點，並將路徑上的所有節點直接連接到根（路徑壓縮）。這使得後續的 find 操作更加高效。

```java
int find(int[] parent, int x) {
    if (parent[x] != x)                    // 如果 x 不是根
        parent[x] = find(parent, parent[x]); // 遞迴追溯父節點，並直接連接到根
    return parent[x];                       // 返回 x 的根
}
```

### union 操作（按秩合併）

合併兩個節點所屬的群組。將秩（樹的高度上限）較小的一方連接到較大的一方下面，以抑制樹的高度增長。如果兩個節點已經屬於同一群組，則不進行合併並返回 `false`。

```java
boolean union(int[] parent, int[] rank, int x, int y) {
    int rx = find(parent, x);  // 取得 x 的根
    int ry = find(parent, y);  // 取得 y 的根
    if (rx == ry) return false; // 屬於同一群組則無需合併 → 返回 false
    // 將秩較小的一方連接到秩較大的一方下面
    if (rank[rx] < rank[ry]) parent[rx] = ry;
    else if (rank[rx] > rank[ry]) parent[ry] = rx;
    else { parent[ry] = rx; rank[rx]++; }  // 秩相同時，將一方連接到另一方下面，並將秩加 1
    return true;  // 合併成功 → 返回 true
}
```

### 反阿克曼函數 α(n) 是什麼

表示 Union-Find 每次操作的時間複雜度的函數。α(n) 增長極為緩慢，對於現實中的輸入規模（n < 2^65536），α(n) ≤ 4，因此可視為實際上的常數。

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n × α(n)) ≈ O(n) — 對 n 條邊分別執行一次 find 和 union。由於 α(n) 實際上為常數，可視為 O(n) |
| Space | O(n) — parent 陣列和 rank 陣列各保存 n+1 個元素 |

## 程式碼

```java
// 輸入：邊的陣列 edges（每個元素為 int[]{u, v}，表示連接節點 u 和節點 v 的邊）
// 輸出：以 int[] 形式返回形成環的多餘邊

// 返回節點 x 所屬群組的根（含路徑壓縮）
int find(int[] parent, int x) {
    if (parent[x] != x)
        // 遞迴追溯父節點，並直接連接到根（路徑壓縮）
        parent[x] = find(parent,
            parent[x]);
    return parent[x];
}

// 合併兩個節點所屬的群組。若已屬於同一群組則返回 false
boolean union(int[] parent,
        int[] rank, int x, int y) {
    int rx = find(parent, x); // 取得 x 的根
    int ry = find(parent, y); // 取得 y 的根
    if (rx == ry) return false; // 已屬於同一連通分量 → 會產生環，因此返回 false
    // 將秩較小的一方連接到秩較大的一方下面，以抑制樹的高度增長
    if (rank[rx] < rank[ry])
        parent[rx] = ry;
    else if (rank[rx] > rank[ry])
        parent[ry] = rx;
    else {
        // 秩相同時，將一方連接到另一方下面，並將秩加 1
        parent[ry] = rx;
        rank[rx]++;
    }
    return true; // 合併成功 → 未產生環
}

public int[] findRedundantConnection(
        int[][] edges) {
    // 邊的數量 = 節點的數量（樹的 n-1 條 + 多餘的 1 條 = n 條）。節點編號從 1 到 n
    int n = edges.length;
    // 將每個節點初始化為獨立的群組（parent[i] = i，自身為根）
    int[] parent = new int[n + 1];
    int[] rank = new int[n + 1]; // rank 陣列保持預設值 0 即可
    for (int i = 1; i <= n; i++)
        parent[i] = i;

    // 從頭到尾依序逐一處理每條邊，檢測形成環的邊
    for (int[] e : edges) {
        // 當 union 返回 false 時，表示 e[0] 和 e[1] 已屬於同一連通分量
        // → 該邊為形成環的多餘邊，直接返回
        if (!union(parent, rank,
                e[0], e[1]))
            return e;
    }
    // 根據題目約束，必定存在一條多餘的邊，因此不會執行到此處
    return new int[0];
}
```
