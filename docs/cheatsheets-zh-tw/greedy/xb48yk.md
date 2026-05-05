# Dividing Cards Into Consecutive Groups — 判定能否將卡牌分割為指定大小的連續組別

## 問題的本質

給定一個整數陣列 `hand`（卡牌的值）和一個整數 `groupSize`。以 `boolean` 回傳是否能將所有卡牌分割為每組由 `groupSize` 張**連續值**組成的組別。必須將所有卡牌恰好全部使用完畢，不可有剩餘或不足。

## 核心概念

若從最小值的卡牌開始以貪心法處理，則每張卡牌所屬的組別可以唯一確定。反覆從最小的卡牌開始建立連續組別，並移除已使用的卡牌，若能將所有卡牌使用完畢，則代表可以成功分割。

## 思考過程

1. **確認前提條件**：由於要將卡牌分為每組 `groupSize` 張的組別，若卡牌總數無法被 `groupSize` 整除，則分割不可能。最先執行此判定，可以省略不必要的處理
2. **應從最小卡牌開始處理的原因**：最小的卡牌只能屬於以自身為起始的連續組別。例如最小值為 3 且 `groupSize` 為 3，則該卡牌必定屬於 [3, 4, 5] 的組別。因此從最小值開始貪心處理的策略是正確的
3. **需要管理每張卡牌的出現次數**：由於同一值的卡牌可能存在多張，因此需要一個記錄每個值的出現次數（頻率）的資料結構。此外，為了高效地取得最小值，適合使用鍵值有排序的 TreeMap
4. **組別建構的步驟**：從 TreeMap 取得最小鍵 `first`，確認從 `first` 到 `first + groupSize - 1` 的所有連續值是否都存在於 TreeMap 中。若存在，則將每個值的頻率減 1，頻率變為 0 的值從 TreeMap 中刪除
5. **連續值不足的情況**：在建構組別的過程中，若所需的值不存在於 TreeMap 中，則立即判定為無法分割並回傳 `false`
6. **處理完所有卡牌即為成功**：反覆建構組別直到 TreeMap 為空，若全部成功則回傳 `true`

## 前置知識

### TreeMap 是什麼

TreeMap 是一種鍵值始終以排序順序管理的 Map 資料結構。與 HashMap 一樣可以儲存鍵值對，但基於鍵的順序的操作（如取得最小鍵）可以在 O(log n) 內完成。其內部以紅黑樹（自平衡二元搜尋樹）實作。

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();  // 建立空的 TreeMap
tm.put(5, 2);           // 將值 2 儲存至鍵 5
tm.put(3, 1);           // 將值 1 儲存至鍵 3
tm.firstKey();           // 回傳最小的鍵 → 3
tm.containsKey(5);       // 回傳鍵 5 是否存在的 boolean → true
tm.get(5);               // 回傳鍵 5 對應的值 → 2
tm.remove(3);            // 刪除鍵 3 及其對應的值
```

### getOrDefault 是什麼

getOrDefault 是從 Map 取得值時，若鍵不存在則回傳指定預設值的方法。在頻率計數中可以省略 `null` 檢查。

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();
tm.getOrDefault(10, 0);  // 鍵 10 不存在，因此回傳預設值 0 → 0
tm.put(10, 3);
tm.getOrDefault(10, 0);  // 鍵 10 存在，因此回傳其值 → 3
```

### 貪心法（Greedy）是什麼

貪心法是在每個步驟中做出局部最優選擇，以求得整體最優解的方法。在此問題中，「從最小的卡牌開始依序建立組別」這個貪心選擇能導出整體正確的分割結果。由於最小的卡牌無法被放入其他組別的中間位置，因此貪心選擇與最優解一致。

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n log n) — 對 TreeMap 的插入與刪除各為 O(log n)，需處理全部 n 張卡牌 |
| Space | O(n) — TreeMap 最多儲存 n 個項目 |

## 程式碼

```java
// 輸入：整數陣列 hand（卡牌的值）與整數 groupSize（每組的大小）
// 輸出：若能將所有卡牌分割為連續值的組別則回傳 true，否則回傳 false
public boolean isNStraightHand(int[] hand, int groupSize) {
    // 若卡牌總數無法被組別大小整除，則無法均等分組
    if (hand.length % groupSize != 0)
        return false;

    // 鍵=卡牌的值，值=剩餘張數（頻率），儲存至 TreeMap
    // 使用 TreeMap 的原因：可以在 O(log n) 內取得最小卡牌值
    TreeMap<Integer, Integer> tm = new TreeMap<>();
    // 計算每張卡牌的出現次數，使用 getOrDefault 將既有頻率加 1
    for (int card : hand) {
        tm.put(card, tm.getOrDefault(card, 0) + 1);
    }

    // 反覆建構組別直到 TreeMap 為空（為空代表所有卡牌皆已成功分割）
    while (!tm.isEmpty()) {
        // 取得目前最小的卡牌值，作為組別的起始
        // 最小值無法被放入其他組別的中間位置，因此必定成為新組別的起始
        int first = tm.firstKey();

        // 從 first 開始以 groupSize 個連續值建立組別
        for (int i = 0; i < groupSize; i++) {
            int cur = first + i;

            // 若連續值不存在，則無法建構組別，因此無法分割
            if (!tm.containsKey(cur))
                return false;

            // 若頻率為 1 則該卡牌為最後一張故刪除，若為 2 以上則將頻率減 1
            if (tm.get(cur) == 1) {
                tm.remove(cur);
            } else {
                tm.put(cur, tm.get(cur) - 1);
            }
        }
    }

    // 所有卡牌皆已成功分割為連續組別
    return true;
}
```
