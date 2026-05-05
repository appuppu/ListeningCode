# Simulating a Last Stone Weight Game — 每次取出兩顆最重的石頭互相碰撞，求最後剩餘石頭的重量

## 問題的本質

給定一個整數陣列 `stones`。每次取出**最重的兩顆石頭**互相碰撞。若兩顆石頭重量相等，則兩者皆消滅；若不同，較輕的石頭消滅，較重的石頭重量減為兩者的差值。重複此操作直到剩下一顆或零顆石頭，回傳最後剩餘石頭的重量。若沒有石頭剩餘則回傳0。

## 核心思路

每次需要高效地取出「最重的兩顆石頭」。使用最大堆積（Max-Heap），可以在O(log n)時間內取出最大值，因此無需每次重新排序，即可隨時取得最重的兩顆石頭。

## 思考過程

1. **每次操作需要取得兩個最大值**：碰撞規則要求每次選出最重的兩顆石頭。也就是說，這是一個重複執行「從當前集合中取出最大值兩次」的問題
2. **希望高效地取出最大值**：若每次都對陣列排序，每輪需要O(n log n)的時間。使用最大堆積，取出最大值只需O(log n)，插入元素也只需O(log n)
3. **將Java的PriorityQueue作為Max-Heap使用**：Java的PriorityQueue預設為Min-Heap（最小值在前端）。將 `Collections.reverseOrder()` 作為比較器傳入，即可使其作為最大值在前端的Max-Heap運作
4. **將所有石頭放入堆積中**：將陣列 `stones` 的所有元素加入PriorityQueue。至此堆積已準備好管理最大值
5. **當石頭數量為兩顆以上時，重複執行碰撞操作**：用 `poll()` 從堆積中取出最大值兩次，若差值不為0，則用 `add()` 將差值放回堆積。若差值為0，則不放回任何值（兩者皆消滅）
6. **判斷最終狀態並回傳結果**：迴圈結束後，若堆積為空，表示所有石頭皆已消滅，回傳0。若堆積中剩餘一顆石頭，則用 `poll()` 取出該石頭的重量並回傳

## 前置知識

### PriorityQueue（優先佇列）是什麼

PriorityQueue是一種資料結構，當加入元素時會在內部自動管理順序，透過 `poll()` 可以隨時取出優先度最高的元素。內部實作為堆積（二元堆積），加入與取出操作皆以O(log n)的時間運作。

```java
// 預設為Min-Heap（最小值在前端）
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.add(5);       // 加入元素5
minHeap.add(2);       // 加入元素2
minHeap.poll();       // 取出並回傳最小值2
minHeap.size();       // 回傳目前的元素數量 → 1
minHeap.isEmpty();    // 以boolean回傳佇列是否為空 → false
```

### Collections.reverseOrder() 是什麼

Collections.reverseOrder()是傳入PriorityQueue建構子的比較器，可將預設的升序（Min-Heap）反轉為降序（Max-Heap）。如此一來 `poll()` 便會回傳最大值。

```java
// 建立Max-Heap（最大值在前端）
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

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n log n) — 最多有n次碰撞操作，每次操作中堆積的取出與加入需要O(log n) |
| Space | O(n) — 堆積中最多儲存n顆石頭 |

## 程式碼

```java
// 輸入：整數陣列 stones（每個元素為石頭的重量）
// 輸出：以 int 回傳最後剩餘石頭的重量。若沒有石頭剩餘則回傳0
public int lastStoneWeight(int[] stones) {
    // 將 Collections.reverseOrder() 指定為比較器，建立 poll() 會回傳最大值的Max-Heap
    PriorityQueue<Integer> pq =
        new PriorityQueue<>(Collections.reverseOrder());

    // 將所有石頭加入堆積。完成後堆積會以最大值在前端的狀態進行管理
    for (int s : stones) pq.add(s);

    // 當石頭數量為兩顆以上時，重複執行取出最重兩顆石頭碰撞的操作
    while (pq.size() >= 2) {
        // 呼叫 poll() 兩次，分別取出最重的石頭與次重的石頭
        // 由於是Max-Heap，a >= b 恆成立
        int a = pq.poll();
        int b = pq.poll();

        // 若重量不同，將差值石頭放回堆積。若重量相同，兩者皆消滅，因此不放回任何值
        if (a != b) pq.add(a - b);
    }

    // 若堆積為空，表示所有石頭皆已消滅，回傳0；若仍有剩餘，回傳該石頭的重量
    return pq.isEmpty() ? 0 : pq.poll();
}
```
