# Finding the Smallest Interval Containing Each Query — 找出包含每個查詢的最小區間

## 問題的本質

給定一個二維整數陣列 `intervals`（每個元素為 `[left, right]`）和一個整數陣列 `queries`。對於每個查詢值，找出包含該查詢值的所有區間中**大小最小的區間**。區間的大小定義為 `right - left + 1`。如果不存在包含該查詢值的區間，則返回 `-1`。

## 核心思路

將查詢和區間都進行排序，按照查詢值從小到大的順序進行處理。這樣對於每個查詢，可以依次將「左端點小於等於查詢值的區間」加入 Min-Heap。從 Min-Heap 中取出大小最小且右端點大於等於查詢值的區間，該區間即為答案。

## 思考過程

1. **對每個查詢檢查所有區間效率太低**：如果對每個查詢遍歷所有區間，時間複雜度為 O(n×q)。將查詢和區間都排序後，區間的添加處理可以在所有查詢之間共享，從而消除重複的遍歷
2. **按升序處理查詢使區間的添加變為單調操作**：將區間按左端點排序，將查詢按值的升序排序後，隨著查詢值的增大，滿足「左端點小於等於查詢值」條件的區間只會增加而不會減少。也就是說，區間的添加只需推進指標，是一個單調操作
3. **需要從已添加的區間中快速取得最小大小的區間**：從候選區間中取出大小最小的區間，Min-Heap（最小堆積）是最合適的資料結構。將區間大小作為堆積的鍵，透過 peek 操作即可以 O(1) 的時間取得最小大小的區間
4. **右端點小於查詢值的區間是無效的**：堆積中剩餘的區間裡，右端點小於查詢值的區間不包含該查詢值。這些區間從堆積頂端依次 poll 移除。一旦移除的區間在之後的查詢中也同樣無效（因為查詢值是遞增的），所以不需要重新添加
5. **需要保留查詢的原始順序**：雖然對查詢進行排序處理，但結果需要按原始順序返回。因此在排序前將每個查詢與其原始索引配對保存，並將答案寫入結果陣列的對應位置
6. **如果堆積為空，則不存在包含該查詢的區間**：移除無效區間後如果堆積為空，表示不存在包含該查詢的區間，因此在結果中存入 `-1`

## 前置知識

### 什麼是 PriorityQueue（Min-Heap）

PriorityQueue 是一種按優先順序管理元素的資料結構。預設情況下最小值位於頂端（Min-Heap）。添加和取出元素的時間複雜度為 O(log n)，查看頂端元素的時間複雜度為 O(1)。

```java
// 儲存 int[]，按陣列第 0 個元素（大小）升序排列的 Min-Heap
PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[0] - b[0]);
heap.offer(new int[]{5, 10});  // 添加元素
heap.peek();                    // 不取出地查看頂端元素 → {5, 10}
heap.poll();                    // 取出並刪除頂端元素 → {5, 10}
heap.isEmpty();                 // 判斷堆積是否為空 → true
```

### 什麼是離線查詢

離線查詢是一種不按查詢到達順序，而是重新排列為便於處理的順序後再進行處理的手法。結果使用原始索引寫回正確的位置。當查詢之間不存在依賴關係時，此方法有效。

```java
int q = queries.length;
int[][] sortedQ = new int[q][2];
for (int i = 0; i < q; i++) {
    sortedQ[i] = new int[]{queries[i], i};  // 建立 {查詢值, 原始索引} 的配對
}
Arrays.sort(sortedQ, (a, b) -> a[0] - b[0]);  // 按查詢值的升序排序
```

### Arrays.sort 的自訂比較器

可以按任意標準對二維陣列或物件陣列進行排序。Lambda 表達式 `(a, b) -> a[0] - b[0]` 表示按每個元素的第 0 個值升序排序。

```java
int[][] intervals = {{3, 6}, {1, 4}, {2, 8}};
Arrays.sort(intervals, (a, b) -> a[0] - b[0]);  // 按左端點升序排序 → {{1,4}, {2,8}, {3,6}}
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n log n + q log q) — 區間排序為 O(n log n)，查詢排序為 O(q log q)，堆積操作中每個區間最多添加一次和刪除一次，因此為 O(n log n) |
| Space | O(n + q) — 堆積中最多儲存 n 個區間，排序後的查詢陣列儲存 q 個元素 |

## 程式碼

```java
// 輸入：二維整數陣列 intervals（每個元素為 [left, right]）和整數陣列 queries
// 輸出：返回一個 int[]，儲存包含每個查詢的最小區間大小。如果不存在包含該查詢的區間，則儲存 -1
public int[] minInterval(int[][] intervals, int[] queries) {
    // 將區間按左端點升序排序。這樣只需將指標 j 向前推進，即可不遺漏地添加所有「左端點小於等於查詢值的區間」
    Arrays.sort(intervals, (a, b) -> a[0] - b[0]);

    int q = queries.length;
    // 將每個查詢與其原始索引配對。這是為了在排序後仍能將結果寫回正確的位置
    int[][] sortedQ = new int[q][2];
    for (int i = 0; i < q; i++) {
        sortedQ[i] = new int[]{queries[i], i};
    }
    // 按查詢值升序排序。按升序處理使區間添加成為單調操作
    Arrays.sort(sortedQ, (a, b) -> a[0] - b[0]);

    // 儲存 {區間大小, 右端點}，按大小升序取出的 Min-Heap。以大小為鍵，可以 O(1) 查看最小大小的區間
    PriorityQueue<int[]> heap =
        new PriorityQueue<>((a, b) -> a[0] - b[0]);

    int[] res = new int[q];
    int j = 0;  // 遍歷區間陣列的指標。在所有查詢中只會向前推進，因此區間添加的總計為 O(n)

    for (int[] sq : sortedQ) {
        int val = sq[0], idx = sq[1];  // val=查詢值，idx=原始索引

        // 將所有左端點小於等於查詢值的區間添加到堆積中。j 不會回退，因此整體為 O(n)
        while (j < intervals.length && intervals[j][0] <= val) {
            int sz = intervals[j][1] - intervals[j][0] + 1;  // 區間大小 = right - left + 1
            heap.offer(new int[]{sz, intervals[j][1]});  // 將 {大小, 右端點} 添加到堆積
            j++;
        }

        // 移除右端點小於查詢值（不包含該查詢）的區間。由於查詢值是升序遞增的，一旦移除的區間在之後也同樣無效
        while (!heap.isEmpty() && heap.peek()[1] < val) {
            heap.poll();
        }

        // 如果堆積為空則不存在包含該查詢的區間，否則頂端的區間大小即為答案（無效區間已被移除，因此頂端是最小且有效的）
        res[idx] = heap.isEmpty() ? -1 : heap.peek()[0];
    }
    return res;
}
```
