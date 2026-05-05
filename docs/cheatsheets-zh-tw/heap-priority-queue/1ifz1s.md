# Finding the Median From a Data Stream — 從資料流中即時求取中位數

## 問題的本質

在整數從資料流中不斷被加入的情況下，設計一個支援兩種操作的資料結構。`addNum(int num)` 用於加入一個整數，`findMedian()` 則回傳目前已加入的所有整數的**中位數**。若元素數量為奇數，則回傳中間的值；若為偶數，則回傳中間兩個值的平均值。

## 核心概念

將所有元素分成「較小的一半」和「較大的一半」，分別用 max-heap 和 min-heap 進行管理，這樣中位數就能隨時從兩個 heap 的頂端以 O(1) 的時間取得。

## 思考過程

1. **中位數位於「正中間」**：要求取中位數，需要將所有元素以排序狀態保持，並存取中間的元素。然而，每次加入元素都重新排序的話，時間複雜度為 O(n log n)
2. **不需要所有元素的排序順序，只要知道中間位置即可**：將所有元素二分為「較小的一半（lower half）」和「較大的一半（upper half）」，lower half 的最大值和 upper half 的最小值就是中位數的候選值
3. **希望能快速取得各半部分的極值**：要以 O(1) 取得 lower half 的最大值，適合使用 max-heap；要以 O(1) 取得 upper half 的最小值，適合使用 min-heap。加入 heap 的時間複雜度為 O(log n)
4. **維持兩個 heap 的大小平衡**：為了正確求取中位數，需要將兩個 heap 的大小差維持在最多 1。讓 lo（max-heap）的大小始終大於或等於 hi（min-heap）的大小來保持平衡
5. **加入元素時的平衡調整步驟**：先將新元素加入 lo，再將 lo 的最大值移至 hi。這樣可以始終保證 lo 的最大值 ≤ hi 的最小值。之後，若 hi 的大小超過 lo，則將 hi 的最小值移回 lo
6. **取得中位數**：若 lo 的大小大於 hi，則元素數量為奇數，lo 的頂端（最大值）即為中位數。若大小相等，則元素數量為偶數，中位數為 lo 的頂端與 hi 的頂端的平均值

## 前置知識

### PriorityQueue（Heap）是什麼

PriorityQueue 是一種按照優先順序管理元素的資料結構。預設以 min-heap（最小值在頂端）的方式運作。取得頂端元素的時間複雜度為 O(1)，加入和刪除元素的時間複雜度為 O(log n)。

```java
// min-heap（預設）：最小值位於頂端
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.offer(5);       // 加入元素 5
minHeap.offer(3);       // 加入元素 3
minHeap.peek();          // 取得頂端的最小值 → 3（不刪除）
minHeap.poll();          // 取出頂端的最小值 → 3（刪除）

// max-heap：最大值位於頂端（指定 Collections.reverseOrder()）
PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
maxHeap.offer(5);       // 加入元素 5
maxHeap.offer(3);       // 加入元素 3
maxHeap.peek();          // 取得頂端的最大值 → 5
```

### offer / poll / peek 的差異

| 方法 | 行為 | 回傳值 |
|---|---|---|
| `offer(e)` | 將元素 `e` 加入 heap | `boolean`（成功時回傳 true） |
| `poll()` | 取出頂端元素並**將其刪除** | 取出的元素（若為空則回傳 `null`） |
| `peek()` | **不刪除**地參照頂端元素 | 頂端的元素（若為空則回傳 `null`） |

### 中位數（median）是什麼

中位數是排序後的列表中正中間的值。若元素數量為奇數，則取中間的 1 個值；若為偶數，則取中間 2 個值的平均值。
例如：`[1, 2, 3]` → 中位數為 `2`。`[1, 2, 3, 4]` → 中位數為 `(2 + 3) / 2.0 = 2.5`。

## 計算複雜度

| | 值 |
|---|---|
| Time | O(log n) — `addNum` 中對 heap 的加入和取出最多發生 3 次，每次操作為 O(log n)。`findMedian` 為 O(1) |
| Space | O(n) — 兩個 heap 保存所有元素 |

## 程式碼

```java
// 輸入：透過 addNum(int num) 將整數以串流形式逐一傳入
// 輸出：findMedian() 以 double 型別回傳目前已加入的所有整數的中位數
class MedianFinder {
    // 管理較小一半的 max-heap（頂端為最大值）
    PriorityQueue<Integer> lo;
    // 管理較大一半的 min-heap（頂端為最小值）
    PriorityQueue<Integer> hi;

    MedianFinder() {
        // max-heap 使用 Collections.reverseOrder() 設定為由大到小排列
        lo = new PriorityQueue<>(Collections.reverseOrder());
        // min-heap 維持預設（由小到大排列）
        hi = new PriorityQueue<>();
    }

    void addNum(int num) {
        // 所有元素先加入較小的一半（lo）
        lo.offer(num);
        // 將 lo 的最大值移至 hi，以始終維持 lo 的所有元素 ≤ hi 的所有元素這一大小關係
        hi.offer(lo.poll());

        // 若 hi 的大小超過 lo，則將 hi 的最小值移回 lo 以保持平衡
        // 透過此操作，lo 的大小始終大於或等於 hi 的大小（差值最大為 1）
        if (hi.size() > lo.size())
            lo.offer(hi.poll());
    }

    double findMedian() {
        // lo 的大小較大 = 所有元素數量為奇數 → lo 的頂端（較小一半的最大值）即為中位數
        if (lo.size() > hi.size())
            return lo.peek();

        // 大小相等 = 所有元素數量為偶數 → 回傳中間兩個值的平均值
        // 除以 2.0 以執行浮點數除法而非整數除法
        return (lo.peek() + hi.peek()) / 2.0;
    }
}
```
