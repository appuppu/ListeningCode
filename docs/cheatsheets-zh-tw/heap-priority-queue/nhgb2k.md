# Simulating a Last Stone Weight Game — 每次取出兩顆最重的石頭碰撞，求最後剩餘石頭的重量

## 問題的本質

給定一個整數陣列 `stones`。每次取出**最重的兩顆石頭**進行碰撞。若兩顆石頭重量相等，則兩者皆消滅；若重量不同，則較輕的石頭消滅，較重的石頭重量減少為兩者的差值。重複此操作直到剩下一顆或零顆石頭為止，回傳最後剩餘石頭的重量。若沒有石頭剩餘則回傳0。

## 核心概念

每次需要高效地取出「最重的兩顆石頭」。使用最大堆積（Max-Heap），取出最大值的時間複雜度為O(log n)，因此無需重新排序，即可持續取得最重的兩顆石頭。

## 思考過程

1. **每次操作需要取得兩個最大值**：根據石頭碰撞規則，每次都需選出最重的兩顆石頭。換言之，這是一個反覆執行「從目前的集合中取出最大值兩次」的問題
2. **希望高效地取出最大值**：若每次都對陣列重新排序，每一輪需要O(n log n)的時間。使用最大堆積，取出最大值僅需O(log n)，插入元素也僅需O(log n)
3. **將 Java 的 PriorityQueue 作為 Max-Heap 使用**：Java 的 PriorityQueue 預設為 Min-Heap（最小值在最前方）。透過傳入 `Collections.reverseOrder()` 作為比較器，可使其作為最大值在最前方的 Max-Heap 運作
4. **將所有石頭放入堆積中**：將陣列 `stones` 的所有元素加入 PriorityQueue。如此一來，堆積便準備好管理最大值
5. **當石頭數量為兩顆以上時，重複執行碰撞操作**：透過 `poll()` 從堆積中取出最大值兩次，若差值不為0，則透過 `add()` 將差值放回堆積。若差值為0，則不放回任何值（兩者皆消滅）
6. **判定最終狀態並回傳結果**：迴圈結束後，若堆積為空，表示所有石頭皆已消滅，回傳0。若堆積中剩餘一顆石頭，則透過 `poll()` 取出該石頭的重量並回傳

## 前置知識

### PriorityQueue（優先佇列）是什麼

PriorityQueue 是一種資料結構，當加入元素時會在內部自動管理順序，透過 `poll()` 可隨時取出優先度最高的元素。其內部實作為堆積（二元堆積），加入與取出的時間複雜度皆為O(log n)。

```java
// 預設為 Min-Heap（最小值在最前方）
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.add(5);       // 加入元素5
minHeap.add(2);       // 加入元素2
minHeap.poll();       // 取出並回傳最小值2
minHeap.size();       // 回傳目前的元素數量 → 1
minHeap.isEmpty();    // 以 boolean 回傳佇列是否為空 → false
```

### Collections.reverseOrder() 是什麼

這是傳入 PriorityQueue 建構子的比較器，可將預設的升序（Min-Heap）反轉為降序（Max-Heap）。如此一來，`poll()` 便會回傳最大值。

```java
// 建立 Max-Heap（最大值在最前方）
PriorityQueue<Integer> maxHeap =
    new PriorityQueue<>(Collections.reverseOrder());
maxHeap.add(3);       // 加入元素3
maxHeap.add(7);       // 加入元素7
maxHeap.add(1);       // 加入元素1
maxHeap.poll();       // 取出並回傳最大值7
maxHeap.poll();       // 取出並回傳次大值3
```

### Max-Heap 的運作示意

stones = [2, 7, 4, 1, 8, 1] 的情況：
- 將所有元素加入堆積後，內部以 `[8, 7, 4, 1, 2, 1]` 的形式管理
- `poll()` → 取出8。堆積重新構成為 `[7, 4, 2, 1, 1]`
- `poll()` → 取出7。將 8 - 7 = 1 透過 `add()` 放回堆積

## 計算量

| | 值 |
|---|---|
| Time | O(n log n) — 最多執行n次碰撞操作，每次操作中堆積的取出與加入各需O(log n) |
| Space | O(n) — 堆積中最多保存n顆石頭 |

## 程式碼

```java
// 輸入：整數陣列 stones（每個元素為石頭的重量）
// 輸出：以 int 回傳最後剩餘石頭的重量。若沒有石頭剩餘則回傳0
public int lastStoneWeight(int[] stones) {
    // 透過 Collections.reverseOrder() 建立 Max-Heap（最大值在最前方）
    // 預設的 PriorityQueue 為 Min-Heap，因此透過比較器反轉為降序
    PriorityQueue<Integer> pq =
        new PriorityQueue<>(Collections.reverseOrder());

    // 將所有石頭加入堆積。全部元素加入後，堆積會將最大值管理在最前方
    for (int s : stones) pq.add(s);

    // 當石頭數量為兩顆以上時，重複執行取出最重兩顆石頭進行碰撞的操作
    while (pq.size() >= 2) {
        // 呼叫 poll() 兩次，取出最重的石頭與次重的石頭
        // 由於使用 Max-Heap，a >= b 始終成立
        int a = pq.poll();  // 取出最重的石頭
        int b = pq.poll();  // 取出次重的石頭

        // 若重量不同，將差值的石頭放回堆積。若相等，則兩者皆消滅，不放回任何值
        if (a != b) pq.add(a - b);
    }

    // 若堆積為空，表示所有石頭皆已消滅，回傳0；若有剩餘，則回傳該石頭的重量
    return pq.isEmpty() ? 0 : pq.poll();
}
```
