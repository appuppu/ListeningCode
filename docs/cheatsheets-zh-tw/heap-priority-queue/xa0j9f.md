# Tracking the Kth Largest Element in a Stream — 從串流中持續取得第K大的元素

## 問題的本質

設計一個類別，接收整數 `k` 和初始數值列表。每次呼叫 `add` 方法時，將新的數值加入串流中，並回傳該時間點整個串流中**第K大的元素**。

## 核心思路

因為只需要第K大的元素，所以只要用 Min-Heap 保留前K大的元素，堆積的根（最小值）就始終是第K大的元素。

## 思考過程

1. **只需要第K大的元素**：不需要對整個串流進行排序，只要掌握前K大的元素，就能確定第K大的元素
2. **希望高效管理前K大的元素**：元素的新增和最小值的取出都能以 O(log n) 完成的 Min-Heap（最小堆積）非常適合。Min-Heap 的根始終保持堆積內的最小值，因此只要將大小維持在K，根就是第K大的元素
3. **將堆積大小限制為K的方法**：新增元素後，若堆積大小超過K，就用 `poll()` 移除根（最小值）。如此一來，比第K大的元素更小的值會被自動排除，始終只保留前K大的元素
4. **取得第K大元素的方法**：當堆積大小恰好為K時，根的值就是第K大的元素。可以用 `peek()` 以 O(1) 取得
5. **初始化時也重複使用 add**：在建構子中對初始列表的每個元素呼叫 `add`，就能用相同的邏輯建構堆積。初始化和新增可以共用程式碼

## 前置知識

### 什麼是 Min-Heap（最小堆積）

堆積是一種具有完全二元樹結構的資料結構。在 Min-Heap 中，父節點的值始終維持在子節點的值以下。因此，根（Root）始終存放堆積內的最小值。元素的新增和最小值的取出都能以 O(log n) 完成。

### 什麼是 PriorityQueue

PriorityQueue 是 Java 中 Min-Heap 的實作類別。預設以升序（由小到大）進行優先排序。

```java
PriorityQueue<Integer> heap = new PriorityQueue<>();  // 建立空的 Min-Heap
heap.offer(5);        // 將元素5加入堆積
heap.offer(3);        // 將元素3加入堆積
heap.offer(8);        // 將元素8加入堆積
heap.peek();          // 不刪除地回傳堆積的根（最小值） → 3
heap.poll();          // 刪除並回傳堆積的根（最小值） → 3
heap.size();          // 回傳堆積內的元素數量 → 2
```

### 為什麼 Min-Heap 能找到第K大的元素

大小為K的 Min-Heap 中存放著前K大的元素。堆積的根是其中最小的值，也就是「前K大元素中的最小值」=「整體中第K大的元素」。
例：k=3，堆積內容為 [4, 5, 8] 時，根為4。這就是整體中第3大的元素。

## 計算複雜度

| | 值 |
|---|---|
| Time | O(log k) — 每次呼叫 add 方法時，對大小為K的堆積進行插入和刪除各需 O(log k) |
| Space | O(k) — 堆積中始終最多只保留K個元素 |

## 程式碼

```java
// 輸入：整數 k、初始整數陣列 nums、以及傳入 add 方法的整數 val
// 輸出：add 方法回傳串流中第K大的元素，型別為 int
class KthLargest {
    // K 作為堆積的大小上限持續使用，因此保存為欄位
    int k;
    // PriorityQueue 預設以 Min-Heap（最小值為根）方式運作
    PriorityQueue<Integer> heap;

    // 建構子：接收 k 和初始陣列，建構堆積
    KthLargest(int k, int[] nums) {
        this.k = k;
        heap = new PriorityQueue<>();
        // 因為 add 方法內會進行堆積大小限制，所以不需要專門的初始化邏輯
        for (int n : nums) {
            add(n);
        }
    }

    // 新增值並回傳第K大的元素
    int add(int val) {
        // 將元素插入堆積末尾，並向父節點方向移動以維持堆積性質（O(log k)）
        heap.offer(val);

        // 若大小超過K，表示有一個比第K大元素更小的多餘元素存在
        if (heap.size() > k) {
            // Min-Heap 的根始終是最小值，因此被刪除的是比第K大元素更小的值
            heap.poll();
        }

        // 當堆積大小恰好為K時，根是堆積內的最小值 = 整體中第K大的元素
        return heap.peek();
    }
}
```
