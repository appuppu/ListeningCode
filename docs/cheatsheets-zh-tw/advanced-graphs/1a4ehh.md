# Finding the Cheapest Flight With Limited Stops — 最多k次轉機找到最便宜的航班

## 問題的本質

給定 `n` 個城市、航班列表 `[from, to, price]`、出發地 `src`、目的地 `dst`、以及最大轉機次數 `k`。請返回從出發地到目的地，在**最多k次轉機**（經由城市不超過k個）的條件下可達到的最低總票價。若無法到達則返回 `-1`。

## 核心思路

一般的 Dijkstra 演算法只追蹤成本最小的路徑，但在這個問題中，「成本較高但轉機次數較少的路徑」有可能最終成為最便宜的路線。因此，我們記錄到達每個城市的「最少轉機次數」，只將以更少轉機次數到達的路徑保留為探索對象，從而同時考慮成本和轉機次數來求得最佳解。

## 思考過程

1. **搜尋最便宜路徑的基本方法是 Dijkstra**：這是加權圖的最短路徑問題，因此基本方針是使用優先佇列的 Dijkstra 演算法。按成本由小到大取出節點，當首次到達目的地時，該路徑即為最便宜的路徑
2. **如何處理轉機次數的限制**：一般的 Dijkstra 演算法「不會重新訪問已以最小成本到達的城市」，但這個問題存在轉機次數的限制。若以最小成本到達的路徑轉機次數超過 k 次則該路徑無效，而成本稍高但轉機次數較少的路徑可能是有效的
3. **記錄到達每個城市的「最少轉機次數」**：準備陣列 `stops[]`，記錄到達每個城市的最少轉機次數。若以比之前更多的轉機次數到達某個城市，則該路徑在成本和轉機次數上都沒有改善，因此可以進行剪枝
4. **在優先佇列中保存什麼**：將每個狀態以 `[成本, 城市, 轉機次數]` 的三元組來管理。按成本升序取出，當首次到達目的地時的解即為最便宜的解
5. **整理剪枝條件**：(a) 若當前轉機次數大於或等於該城市已記錄的最少轉機次數，則中止探索。(b) 若轉機次數超過 k，則不展開到相鄰城市
6. **展開到相鄰城市**：只有通過剪枝的情況下，才對每個相鄰城市將 `[當前成本 + 票價, 相鄰城市, 轉機次數 + 1]` 加入佇列

## 前置知識

### 鄰接表（Adjacency List）

鄰接表是一種資料結構，對圖的每個頂點，以列表保存從該頂點可直接到達的頂點及邊的權重。使用 `HashMap<Integer, List<int[]>>` 來表示，鍵為出發城市，值為 `[到達城市, 票價]` 的列表。

```java
Map<Integer, List<int[]>> adj = new HashMap<>();
// 添加從城市0到城市1、票價100的航班
adj.computeIfAbsent(0, x -> new ArrayList<>()).add(new int[]{1, 100});
// 取得城市0的鄰接表
List<int[]> neighbors = adj.get(0);  // → [[1, 100]]
```

### PriorityQueue（優先佇列）

優先佇列是一種資料結構，當添加元素時會在內部自動排序，始終可以從頂端取出最小（或最大）的元素。在 Dijkstra 演算法中，用於高效地取出「成本最小的狀態」。

```java
// 按 int[] 的第0個元素（成本）升序排序的優先佇列
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
pq.offer(new int[]{100, 1, 0});   // 添加 [成本=100, 城市=1, 轉機=0]
pq.offer(new int[]{50, 2, 1});    // 添加 [成本=50, 城市=2, 轉機=1]
int[] min = pq.poll();            // 取出成本最小的 [50, 2, 1]
pq.isEmpty();                      // 判斷佇列是否為空 → false
```

### 使用 stops 陣列進行剪枝

一般的 Dijkstra 演算法使用 `visited` 陣列來管理已訪問的城市，但在這個問題中，需要區分以「不同轉機次數」到達同一城市的路徑。在 `stops[]` 陣列中記錄到達每個城市的最少轉機次數，中止以更多轉機次數到達的路徑，從而排除不必要的探索。

```java
int[] stops = new int[n];
Arrays.fill(stops, k + 2);  // k+2 是一個足夠大的初始值，表示「尚未到達」
// 以1次轉機到達城市2的情況
stops[2] = 1;
// 之後以2次轉機到達城市2 → 2 >= stops[2]，因此進行剪枝（跳過）
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(E · log n) — 對每個航班（邊），向優先佇列添加和取出需要 log n 的時間 |
| Space | O(n + E) — 鄰接表佔用 O(E)，stops 陣列佔用 O(n)，佇列最多保存 O(E) 個狀態 |

## 程式碼

```java
// 輸入：城市數 n、航班陣列 flights（每個元素為 [from, to, price]）、出發地 src、目的地 dst、最大轉機次數 k
// 輸出：以 int 返回在最多 k 次轉機內從出發地到目的地的最低票價。若無法到達則返回 -1
public int findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
    // 建構鄰接表。鍵=出發城市，值=[到達城市, 票價]的列表
    // 對每個航班 f，將 [f[1], f[2]] 添加到 adj 中鍵為 f[0] 的列表
    Map<Integer, List<int[]>> adj = new HashMap<>();
    for (int[] f : flights)
        adj.computeIfAbsent(f[0], x -> new ArrayList<>())
            .add(new int[]{f[1], f[2]});

    // 按成本升序排列的優先佇列。每個狀態為 [成本, 城市, 轉機次數]
    // 優先取出成本較小的狀態，使得首次到達目的地時即為最便宜的路徑
    PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
    // 初始狀態：以成本0、轉機0次到達出發地
    pq.offer(new int[]{0, src, 0});

    // 記錄到達每個城市的最少轉機次數的陣列
    // k+2 是比轉機上限 k 足夠大的值，作為「尚未到達」的初始值
    int[] stops = new int[n];
    Arrays.fill(stops, k + 2);

    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int cost = curr[0];
        int city = curr[1];
        int stop = curr[2];

        // 若到達目的地，由於按成本升序取出，此路徑即為最便宜的
        if (city == dst) return cost;

        // 若以比之前更多（或相同）的轉機次數到達此城市，則進行剪枝
        // 由於按成本升序取出，之前到達的成本也更小 → 沒有繼續探索的意義
        if (stop >= stops[city]) continue;
        // 更新到達此城市的最少轉機次數
        stops[city] = stop;

        // 若轉機次數超過上限 k，則無法從此城市進一步展開到相鄰城市
        if (stop > k) continue;

        // 若此城市沒有出發的航班則跳過
        if (!adj.containsKey(city)) continue;

        // 對每個相鄰城市，將 [累計成本, 相鄰城市, 轉機次數+1] 加入佇列
        for (int[] next : adj.get(city)) {
            pq.offer(new int[]{cost + next[1], next[0], stop + 1});
        }
    }

    // 若迴圈結束仍未到達目的地，則返回 -1
    return -1;
}
```
