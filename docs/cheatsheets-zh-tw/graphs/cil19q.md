# 判斷是否能完成所有課程 — Determining if All Courses Can Be Completed

## 問題的本質

給定 `numCourses` 個標記為 `0` 到 `n-1` 的課程，以及一個前置條件配對列表 `prerequisites`。每個配對 `[a, b]` 表示「必須先修完課程 `b` 才能修課程 `a`」。請以 `boolean` 回傳是否能修完所有課程。這是一個檢測有向圖中是否存在環（循環依賴）的問題。

## 核心思路

將課程的依賴關係視為有向圖後，能否修完所有課程等同於「圖中是否不存在環」。從入度（進入該節點的邊數）為 0 的節點開始依序處理，執行拓撲排序，若能處理所有節點則表示不存在環。

## 思考過程

1. **將問題轉換為圖**：將每個課程視為節點，每個前置條件 `[a, b]` 視為「`b` → `a`」的有向邊，建構鄰接表。如此便能以圖結構表達依賴關係
2. **存在環則無法全部修完**：若課程 A 依賴 B、B 又依賴 A 形成循環，則兩者都無法先修。因此問題可歸結為「有向圖中是否存在環」的判定
3. **著眼於入度**：計算每個節點的入度（前置條件數量）。入度為 0 的節點沒有前置條件，可以立即修習。以這些節點作為起點即可
4. **將入度為 0 的節點放入佇列開始處理**：類似 BFS，使用佇列依序處理入度為 0 的節點。將已處理節點的鄰接節點入度減 1，若入度變為 0 則將該節點加入佇列
5. **以已處理節點數進行判定**：若能處理所有節點（已處理計數 == `numCourses`），則不存在環，可以修完所有課程。環內的節點入度永遠不會變為 0，因此會被遺留未處理

## 前置知識

### 鄰接表（Adjacency List）

用於表示圖的資料結構。對每個節點，保存從該節點出發的邊所指向的節點列表。以 `List<List<Integer>>` 實作，透過 `graph.get(i)` 取得節點 `i` 的鄰接節點列表。

```java
List<List<Integer>> graph = new ArrayList<>();
for (int i = 0; i < n; i++)
    graph.add(new ArrayList<>());  // 為每個節點建立空列表
graph.get(0).add(1);               // 添加從節點 0 到節點 1 的邊
graph.get(0);                       // 節點 0 的鄰接節點列表 → [1]
```

### 入度（In-degree）

在有向圖中，進入某節點的邊數。入度為 0 的節點不依賴任何其他節點。使用陣列 `inDegree[i]` 管理節點 `i` 的入度。

```java
int[] inDegree = new int[n];   // 將所有節點的入度初始化為 0
inDegree[0]++;                  // 將節點 0 的入度加 1
```

### Queue（佇列）

先進先出（FIFO）的資料結構。在 BFS 中用於管理等待處理的節點。使用 `offer` 從尾端添加，使用 `poll` 從頭端取出。

```java
Queue<Integer> queue = new LinkedList<>();
queue.offer(0);       // 將 0 添加到佇列中
queue.poll();          // 取出並回傳佇列頭端的元素 → 0
queue.isEmpty();       // 以 boolean 回傳佇列是否為空 → true
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(V + E) — 所有節點（V 個）和所有邊（E 個）各處理一次 |
| Space | O(V + E) — 鄰接表儲存所有邊，入度陣列和佇列儲存所有節點 |

## 程式碼

```java
// 輸入：課程數 numCourses 和前置條件陣列 prerequisites（每個元素為 [a, b]，表示「b → a」的依賴關係）
// 輸出：若能修完所有課程則回傳 true，若存在環而無法修完則回傳 false
boolean canFinish(int numCourses, int[][] prerequisites) {
    // 儲存每個節點入度（前置條件數量）的陣列。入度表示「該課程有多少個前置條件」
    int[] inDegree = new int[numCourses];

    // 以鄰接表建構圖。graph.get(i) 是從節點 i 出發的邊所指向的節點列表
    List<List<Integer>> graph = new ArrayList<>();
    for (int i = 0; i < numCourses; i++)
        graph.add(new ArrayList<>());

    // 根據每個前置條件添加邊並更新入度。藉此完成依賴關係圖和各節點的入度
    for (int[] p : prerequisites) {
        graph.get(p[1]).add(p[0]);  // 添加 p[1] → p[0] 的邊
        inDegree[p[0]]++;           // 將 p[0] 的入度加 1
    }

    // 將入度為 0 的節點（無前置條件）添加到佇列中。這些是最先可以修習的課程
    Queue<Integer> queue = new LinkedList<>();
    for (int i = 0; i < numCourses; i++)
        if (inDegree[i] == 0)
            queue.offer(i);

    // 以 BFS 從入度為 0 的節點開始依序處理
    int count = 0;  // 追蹤已處理課程數的變數
    while (!queue.isEmpty()) {
        int course = queue.poll();
        count++;  // 將此節點視為已修完

        // 將鄰接節點的入度減 1（表示消化了一個前置條件）。若變為 0 則所有前置條件已滿足，將其加入佇列
        for (int nei : graph.get(course))
            if (--inDegree[nei] == 0)
                queue.offer(nei);
    }

    // 若能處理所有節點則無環（可修完所有課程）。環內的節點入度不會變為 0，因此會被遺留未處理
    return count == numCourses;
}
```
