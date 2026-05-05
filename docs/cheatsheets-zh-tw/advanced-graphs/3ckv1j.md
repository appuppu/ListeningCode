# 計算網路信號傳播時間 — 求信號傳遍整個網路所需的最短時間

## 問題的本質

給定 `n` 個節點（1〜n）和一個加權有向邊的列表 `times`（每條邊為 `[發送端, 接收端, 所需時間]`）。從指定的來源節點 `k` 發送信號時，返回信號傳遍所有節點所需的最短時間。若存在任何一個無法到達的節點，則返回 `-1`。

## 核心思路

「信號傳遍所有節點的最短時間」等於「各節點最短距離中的最大值」。使用 Dijkstra 演算法求出到所有節點的最短距離，再取其最大值即可。

## 思考過程

1. **將問題視為最短路徑問題**：信號從來源節點沿各邊傳播。信號到達各節點的時刻等於從來源到該節點的最短距離。因此，只需解決單源最短路徑問題即可
2. **希望高效求出到所有節點的最短距離**：由於邊的權重為非負值，可以使用 Dijkstra 演算法。Dijkstra 演算法使用優先佇列（min-heap），以貪心策略從距離最小的節點開始逐一確定最短距離
3. **決定圖的表示方法**：使用鄰接串列。對每個節點，以列表儲存「鄰接節點及其邊的權重」的配對。這樣可以高效地列舉從某個節點延伸出的邊
4. **初始化距離陣列**：將所有節點的距離初始化為無限大（`Integer.MAX_VALUE`），並將來源節點 `k` 的距離設為 0。因為從來源到自身的距離為 0
5. **使用優先佇列處理最短距離的節點**：從佇列中取出距離最小的節點，對該節點的鄰接節點進行距離更新（鬆弛）。若有更新則將其加入佇列
6. **跳過重複處理**：若從佇列中取出的節點距離大於當前最短距離，表示該節點已透過更優路徑處理過，因此跳過。這樣可以避免不必要的計算
7. **從所有節點的最短距離求出答案**：遍歷所有節點的距離陣列，若有節點仍為無限大，表示該節點無法到達，返回 `-1`。否則距離的最大值即為答案

## 前置知識

### 鄰接串列（Adjacency List）是什麼

鄰接串列是一種表示圖的資料結構。對每個節點，以列表保存「從該節點出發的邊的清單」。對於 `n` 個節點，使用 `List<List<int[]>>` 表示，透過 `graph.get(u)` 取得從節點 `u` 出發的邊。

```java
List<List<int[]>> graph = new ArrayList<>();
for (int i = 0; i <= n; i++) {
    graph.add(new ArrayList<>());       // 為每個節點準備一個空列表
}
graph.get(1).add(new int[]{2, 5});      // 新增一條從節點1到節點2、權重為5的邊
graph.get(1).add(new int[]{3, 2});      // 新增一條從節點1到節點3、權重為2的邊
```

### PriorityQueue（優先佇列）是什麼

優先佇列是一種無論元素加入的順序如何，始終將最小（或最大）元素保持在最前方的資料結構。在 Dijkstra 演算法中，用於高效地取出「距離最小的節點」。

```java
// 以 int[] 的第0個元素（距離）進行升序排列的 min-heap
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{0, 1});   // 將 {距離0, 節點1} 加入佇列
pq.offer(new int[]{5, 2});   // 將 {距離5, 節點2} 加入佇列
int[] curr = pq.poll();       // 取出距離最小的元素 {0, 1}
pq.isEmpty();                 // 以 boolean 值返回佇列是否為空
```

### Dijkstra 演算法的鬆弛（Relaxation）是什麼

當經由節點 `u` 到達節點 `v` 的距離 `dist[u] + w` 小於當前的 `dist[v]` 時，將 `dist[v]` 更新為更短的值。透過反覆執行此更新操作，最終可以確定到所有節點的最短距離。

```java
int newDist = dist[u] + w;      // 計算經由 u 到達 v 的距離
if (newDist < dist[v]) {        // 若比當前最短距離更短
    dist[v] = newDist;          // 更新最短距離
    pq.offer(new int[]{newDist, v});  // 將更新後的 v 加入佇列
}
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O((V + E) log V) — 對每個節點和每條邊執行優先佇列的操作（log V） |
| Space | O(V + E) — 鄰接串列儲存所有邊，距離陣列和佇列使用節點數量的空間 |

## 程式碼

```java
// 輸入：有向邊列表 int[][] times（每個元素為 [起點, 終點, 權重]）、節點數 int n、來源節點 int k
// 輸出：以 int 返回從來源到所有節點信號傳遞的最短時間。若存在無法到達的節點則返回 -1
public int networkDelayTime(int[][] times, int n, int k) {
    // 建立鄰接串列（節點編號從1開始，因此大小為 n+1，索引0不使用）
    List<List<int[]>> graph = new ArrayList<>();
    for (int i = 0; i <= n; i++) {
        graph.add(new ArrayList<>());
    }
    // 將每條邊 [u, v, w] 註冊到鄰接串列中，完成有向圖的鄰接串列表示
    for (int[] t : times) {
        graph.get(t[0]).add(new int[]{t[1], t[2]});
    }

    // 以無限大初始化距離陣列。dist[i] 表示「從來源到節點 i 的當前最短距離」
    int[] dist = new int[n + 1];
    Arrays.fill(dist, Integer.MAX_VALUE);
    // 從來源節點到自身的距離為 0
    dist[k] = 0;

    // 建立按距離（第0個元素）升序取出的 min-heap，並加入來源節點 {距離0, 節點k}
    PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
    pq.offer(new int[]{0, k});

    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int d = curr[0];  // 從來源到節點 u 的距離
        int u = curr[1];  // 當前處理的節點

        // 若 d > dist[u]，表示已透過更短距離處理過。當佇列中殘留舊的（距離較大的）項目時會發生此情況
        if (d > dist[u]) continue;

        // 嘗試對鄰接節點進行鬆弛
        for (int[] nei : graph.get(u)) {
            int v = nei[0];  // 鄰接節點
            int w = nei[1];  // 邊的權重
            // 若經由 u 的距離 d + w 比當前的 dist[v] 更短，則更新距離並加入佇列
            if (d + w < dist[v]) {
                dist[v] = d + w;
                pq.offer(new int[]{d + w, v});
            }
        }
    }

    // 求所有節點最短距離中的最大值。此最大值即為「信號傳遍所有節點的最短時間」
    int max = 0;
    for (int i = 1; i <= n; i++) {
        // 若仍為 Integer.MAX_VALUE，表示存在無法到達的節點，返回 -1
        if (dist[i] == Integer.MAX_VALUE) return -1;
        max = Math.max(max, dist[i]);
    }
    return max;
}
```
