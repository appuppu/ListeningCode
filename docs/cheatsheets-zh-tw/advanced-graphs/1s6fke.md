# Finding the Minimum Cost to Connect All Points — 以最小成本連接所有點

## 問題的本質

給定一個二維平面上的點陣列 `points`。任意兩點之間的成本定義為曼哈頓距離 `|xi - xj| + |yi - yj|`。求連接所有點所需的**最小總成本**。這是一個求最小生成樹（MST: Minimum Spanning Tree）的問題。

## 核心思路

若要以最小成本連接所有點，可使用 Prim 演算法貪婪地持續選擇「距離當前 MST 最近的未訪問點」。使用優先佇列可以高效地取出成本最小的邊。

## 思考過程

1. **這是一個 MST 問題**：需要連接所有點，並且最小化成本。這正是最小生成樹的定義。圖的邊權重可以用曼哈頓距離來計算
2. **完全圖適合使用 Prim 演算法**：當有 n 個點時，邊的數量為 n(n-1)/2 條。Kruskal 演算法需要事先生成並排序所有邊，而 Prim 演算法只需逐步處理與當前 MST 相鄰的邊即可
3. **需要快速取出成本最小的邊**：Prim 演算法每次都需要選擇「到未訪問點的最小成本邊」。使用優先佇列（最小堆積）可以在 O(log n) 內完成取出操作
4. **可以從任意點開始**：無論從哪個點開始，MST 的總成本都相同，因此從點 0 開始。初始狀態將成本 0 的點 0 加入佇列
5. **使用已訪問標記防止重複**：當從佇列中取出的點已經包含在 MST 中時，跳過該點。這可以防止對同一個點進行重複處理
6. **每次將新的點加入 MST 時，添加相鄰的邊**：將點 u 加入 MST 後，計算 u 到所有未訪問點 v 的曼哈頓距離，並加入佇列。佇列會自動將成本最小的邊作為下一個候選進行管理

## 前置知識

### 什麼是最小生成樹（MST）

在連接圖中所有頂點的子圖中，邊權重總和最小的子圖。對於 n 個頂點，恰好有 n-1 條邊，且不包含迴路。

### 什麼是 Prim 演算法

一種構建 MST 的貪婪演算法。從任意頂點開始，反覆選擇「連接當前 MST 與未訪問頂點的邊中，權重最小的邊」來擴展 MST。當所有頂點都被加入 MST 後結束。

### 什麼是曼哈頓距離

兩點之間各座標差的絕對值之和。二維平面上點 `(x1, y1)` 與 `(x2, y2)` 的距離計算方式為 `|x1 - x2| + |y1 - y2|`。這相當於在格子狀道路上行走的最短距離。

```java
int dist = Math.abs(pts[u][0] - pts[v][0]) + Math.abs(pts[u][1] - pts[v][1]);
```

### 什麼是 PriorityQueue（優先佇列）

一種可按優先順序取出元素的資料結構。預設情況下，最小值會最先被取出（最小堆積）。使用 `offer` 進行添加，使用 `poll` 取出最小元素，兩者的時間複雜度均為 O(log n)。

```java
// 建立按 int[] 第 0 個元素升序排列的優先佇列
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{5, 0});   // 添加 [成本=5, 點的索引=0]
pq.offer(new int[]{2, 1});   // 添加 [成本=2, 點的索引=1]
int[] min = pq.poll();       // 取出成本最小的元素 [2, 1]
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n² log n) — 每次將一個點加入 MST 時，最多將 n 條邊加入佇列，佇列操作需要 log n |
| Space | O(n²) — 佇列中最多儲存 n² 條邊。inMST 陣列為 O(n) |

## 程式碼

```java
// 輸入：二維座標陣列 pts（每個元素為 [x, y]）
// 輸出：以 int 回傳連接所有點的最小成本
int minCostConnectPoints(int[][] pts) {
    // 取得點的數量
    int n = pts.length;
    // 管理每個點是否已包含在 MST 中的標記陣列（全部初始化為 false）
    boolean[] inMST = new boolean[n];
    // 儲存 {成本, 點的索引} 並按成本升序取出的優先佇列
    PriorityQueue<int[]> pq =
        new PriorityQueue<>((a, b) -> a[0] - b[0]);
    // 將起始點（索引 0）以成本 0 加入佇列
    // 成本 0 表示將第一個點加入 MST 的成本為 0
    // 無論從哪個點開始，MST 的總成本都相同，因此任意選擇點 0
    pq.offer(new int[]{0, 0});
    // cost：MST 的總成本，visited：已加入 MST 的點的數量
    int cost = 0, visited = 0;

    // 重複執行直到所有點都包含在 MST 中
    while (visited < n) {
        // 取出成本最小的邊（d：連接成本，u：點的索引）
        int[] curr = pq.poll();
        int d = curr[0], u = curr[1];

        // 跳過已包含在 MST 中的點
        // 由於同一個點可能以不同成本被多次加入佇列，因此需要此判斷
        if (inMST[u]) continue;

        // 將點 u 加入 MST，並累加成本
        inMST[u] = true;
        cost += d;
        visited++;

        // 將點 u 到所有未訪問點的邊加入佇列
        // 候選邊被登錄到佇列中，佇列會自動管理成本最小的邊
        for (int v = 0; v < n; v++) {
            if (!inMST[v]) {
                // 計算曼哈頓距離：|xu - xv| + |yu - yv|
                int nd =
                    Math.abs(pts[u][0] - pts[v][0])
                    + Math.abs(pts[u][1] - pts[v][1]);
                pq.offer(new int[]{nd, v});
            }
        }
    }
    // while 迴圈結束後，cost 中儲存了 MST 的總成本
    return cost;
}
```
