# Counting Connected Components in an Undirected Graph — 計算無向圖中的連通分量數量

## 問題的本質

給定從 `0` 到 `n-1` 標記的 `n` 個節點，以及一個無向邊的列表 `edges`。請以整數形式返回圖中**連通分量（connected component）的數量**。連通分量是指通過邊可以互相到達的節點集合。

## 核心思路

首先將每個節點視為獨立的連通分量，然後逐條處理邊，將邊兩端節點所屬的群組進行合併。處理完所有邊之後，剩餘的群組數量即為連通分量的數量。

## 思考過程

1. **由邊連接的節點屬於同一群組**：連通分量是「通過邊可以到達的節點集合」，因此由邊連接的兩個節點必定屬於同一連通分量。對所有邊重複執行「將兩端節點歸入同一群組」的操作，最終即可求得連通分量
2. **Union-Find 適合用於群組管理**：Union-Find 是一種能高速執行「將兩個元素合併到同一群組（union）」和「查詢某個元素屬於哪個群組（find）」的資料結構。為每個節點設置「父節點」，將根（root）相同的節點視為同一群組
3. **初始狀態下每個節點的父節點是自身**：通過將 `parent[i] = i` 初始化，最初 n 個節點各自成為獨立的群組（連通分量）。初始的連通分量數量為 `n`
4. **每處理一條邊就執行 union，若發生合併則將分量數減少**：對每條邊 `[a, b]`，求出 `a` 的根和 `b` 的根。若根不同，則兩者屬於不同群組，將一方的根設為另一方根的子節點進行合併，並將連通分量數量減 1。若根相同，則已屬於同一群組，不做任何操作
5. **通過路徑壓縮和秩來加速**：在 find 時執行路徑壓縮（path compression），將訪問過的節點的父節點直接指向根。在 union 時比較秩（樹高度的上限），將較矮的樹接到較高的樹下方（union by rank）。這使得 find 的時間複雜度接近 O(1)（精確地說是 O(α(V))）
6. **處理完所有邊之後的 `components` 即為答案**：從初始值 `n` 開始，每次 union 成功就減 1，最終結果即為連通分量的數量

## 前置知識

### 什麼是 Union-Find（不相交集合資料結構）

Union-Find 是一種將元素分組管理的資料結構。它提供兩種操作：「將兩個元素合併到同一群組（union）」和「求出某個元素所屬群組的代表（根）（find）」。使用 `parent` 陣列記錄每個元素的父節點，通過沿父節點追溯到根來確定群組的代表。

```java
int[] parent = new int[n];   // parent[i] 儲存節點 i 的父節點
for (int i = 0; i < n; i++)
    parent[i] = i;            // 初始狀態：每個節點的父節點是自身（獨立的群組）
```

### 什麼是路徑壓縮（Path Compression）

路徑壓縮是一種在 find 的遞迴過程中，將所有訪問過的節點的父節點直接指向根的優化技術。這使得後續的 find 能夠立即返回根，通過將樹扁平化，時間複雜度改善為接近 O(1)。

```java
int find(int[] parent, int x) {
    if (parent[x] != x)
        parent[x] = find(parent, parent[x]);  // 遞迴找到根，並將父節點指向根
    return parent[x];                          // 返回根
}
```

### 什麼是按秩合併（Union by Rank）

按秩合併是在 union 時比較樹高度的上限（秩），將秩較低的樹接到秩較高的樹下方的技術。通過抑制樹高度的增長來維持 find 的效率。只有在秩相等時，才將合併目標的秩增加 1。

```java
int[] rank = new int[n];     // rank[i] 是以節點 i 為根的樹的高度上限（初始值為 0）
// 將秩較高的一方設為父節點 → 樹不容易變深
if (rank[r1] > rank[r2])
    parent[r2] = r1;         // 將 r2 的樹接到 r1 下方
```

### 什麼是 α（Ackermann 函數的反函數）

α 是出現在 Union-Find 時間複雜度中的函數。對於實際的輸入規模，α(V) 始終不超過 5，因此可以視為常數。所以 Union-Find 的每個操作幾乎以 O(1) 的時間運行。

## 複雜度

| | 值 |
|---|---|
| Time | O(V + E · α(V)) — 初始化需要 O(V)，對每條邊執行 find 和 union，但 α(V) 幾乎為常數，因此實際上為 O(V + E) |
| Space | O(V) — parent 陣列和 rank 陣列各儲存 V 個元素 |

## 程式碼

```java
// 輸入：節點數 n 和邊的列表 edges（每條邊是包含兩個元素的陣列 [a, b]）
// 輸出：以整數形式返回連通分量的數量

// 帶路徑壓縮的 find 函數：返回節點 x 所屬群組的根
int find(int[] parent, int x) {
    if (parent[x] != x)
        // 遞迴找到根，並將父節點直接指向根（路徑壓縮）
        // 這使得後續的 find 能夠立即返回根
        parent[x] = find(parent, parent[x]);
    return parent[x];
}

int countComponents(int n, int[][] edges) {
    // 儲存每個節點父節點的陣列。以 parent[i] = i 初始化，使每個節點成為獨立的群組
    int[] parent = new int[n];
    // 儲存以每個節點為根的樹的高度上限的陣列（在 union 時用於決定接到哪一方下面）
    int[] rank = new int[n];
    for (int i = 0; i < n; i++)
        parent[i] = i;

    // 初始狀態下每個節點是獨立的連通分量，因此分量數為 n
    int components = n;

    // 逐條掃描邊，將兩端節點所屬的群組進行合併
    for (int[] e : edges) {
        // 求出邊兩端節點所屬群組的根（通過路徑壓縮，訪問過的節點的父節點也會被指向根）
        int r1 = find(parent, e[0]);
        int r2 = find(parent, e[1]);

        // 若根不同則屬於不同群組，進行合併（若根相同則已屬於同一群組，不做任何操作）
        if (r1 != r2) {
            // 比較秩，將較低的一方接到較高的一方下面（抑制樹高度的增長）
            if (rank[r1] > rank[r2])
                parent[r2] = r1;
            else if (rank[r1] < rank[r2])
                parent[r1] = r2;
            else {
                // 秩相等時，將 r2 接到 r1 下方，並將 r1 的秩增加 1
                parent[r2] = r1;
                rank[r1]++;
            }
            // 兩個群組合併為一個，因此將分量數減 1
            components--;
        }
    }
    // 處理完所有邊之後的 components 即為連通分量的數量
    return components;
}
```
