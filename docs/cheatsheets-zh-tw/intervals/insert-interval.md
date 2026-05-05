# Inserting a New Interval Into a Sorted List — 將新區間插入已排序的非重疊區間列表並進行合併

## 問題的本質

給定一個已排序且互不重疊的區間列表 `intervals` 和一個新區間 `newInterval`。將 `newInterval` 插入到正確的位置，如果存在重疊的區間則全部合併，最終返回一個非重疊的區間列表。

## 核心思路

從左到右掃描已排序的區間列表時，每個區間可以分為「完全在新區間之前」「與新區間重疊」「完全在新區間之後」三組。按照這三個階段依次處理，只需一次掃描即可完成插入與合併。

## 思考過程

1. **區間的位置關係只有3種模式**：已排序列表中的每個區間與 newInterval 比較後，可以分類為「完全在前面」「重疊」「完全在後面」三者之一。利用這個分類，只需掃描列表一次即可完成處理
2. **「完全在前面」的判定條件**：如果現有區間的終點 `intervals[i][1]` 小於 newInterval 的起點 `newInterval[0]`，則該區間與 newInterval 不重疊。將滿足此條件的區間直接加入結果中
3. **「重疊」的判定條件**：如果現有區間的起點 `intervals[i][0]` 小於或等於 newInterval 的終點 `newInterval[1]`，則該區間與 newInterval 重疊。每當找到重疊的區間時，更新 newInterval 的起點和終點以擴大合併範圍
4. **合併的方法**：取重疊區間的起點與 newInterval 的起點中較小的值作為新的起點，取重疊區間的終點與 newInterval 的終點中較大的值作為新的終點。這樣就能將多個重疊區間合併為一個區間
5. **加入合併結果的時機**：當不再有重疊區間時，將合併完成的 newInterval 加入結果中。之後的區間都在 newInterval 之後，直接加入結果即可
6. **最終返回的內容**：將經過三個階段構建的結果列表轉換為 `int[][]` 並返回

## 前置知識

### ArrayList 是什麼

可變長度的陣列。使用 `add()` 方法可以以 O(1)（均攤）的時間複雜度添加元素，最終可以轉換為固定長度的陣列。當結果的大小無法事先確定時使用。

```java
List<int[]> res = new ArrayList<>();   // 建立空的 ArrayList
res.add(new int[]{1, 3});              // 將元素添加到末尾
res.toArray(new int[0][]);             // 轉換為 int[][] 型別的陣列
```

### Math.min / Math.max 是什麼

返回兩個值中較小值或較大值的方法。在合併區間時用於決定起點和終點。

```java
Math.min(1, 3);   // → 1（返回較小的值）
Math.max(1, 3);   // → 3（返回較大的值）
```

### 區間的重疊判定

兩個區間 `[a, b]` 和 `[c, d]` 是否重疊，可以用 `a <= d && c <= b` 來判定。在本問題中由於列表已排序，只需檢查其中一個條件即可充分判定。

```java
// 現有區間完全在 newInterval 之前（不重疊）
intervals[i][1] < newInterval[0]   // 現有區間的終點 < 新區間的起點

// 現有區間與 newInterval 重疊
intervals[i][0] <= newInterval[1]  // 現有區間的起點 <= 新區間的終點
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 只需掃描區間列表一次即可完成 |
| Space | O(n) — 結果列表最多儲存 n+1 個區間 |

## 程式碼

```java
// 輸入：已排序的非重疊區間列表 intervals（int[][]）和新區間 newInterval（int[]）
// 輸出：將 newInterval 插入並合併後的非重疊區間列表，以 int[][] 返回
public int[][] insert(int[][] intervals, int[] newInterval) {
    // 儲存結果的可變長度列表。因為大小無法事先確定，所以使用 ArrayList
    List<int[]> res = new ArrayList<>();
    // 追蹤掃描位置的變數
    int i = 0;
    // 將區間總數儲存到變數中，在迴圈條件中重複引用
    int n = intervals.length;

    // 階段1：將完全在 newInterval 之前的區間直接加入結果
    // 條件：現有區間的終點 < newInterval 的起點 → 不重疊
    while (i < n && intervals[i][1] < newInterval[0]) {
        res.add(intervals[i]);
        i++;
    }

    // 階段2：將所有與 newInterval 重疊的區間進行合併
    // 條件：現有區間的起點 <= newInterval 的終點 → 重疊
    while (i < n && intervals[i][0] <= newInterval[1]) {
        // 取較小的起點（合併範圍可能向左擴展）
        newInterval[0] = Math.min(newInterval[0], intervals[i][0]);
        // 取較大的終點（合併範圍可能向右擴展）
        newInterval[1] = Math.max(newInterval[1], intervals[i][1]);
        i++;
    }
    // 將合併完成的 newInterval 加入結果（即使重疊區間為0個也直接加入）
    res.add(newInterval);

    // 階段3：將完全在 newInterval 之後的區間直接加入結果（無需合併）
    while (i < n) {
        res.add(intervals[i]);
        i++;
    }

    // 將 ArrayList 轉換為 int[][] 並返回。new int[0][] 是 toArray 的型別提示
    return res.toArray(new int[0][]);
}
```
