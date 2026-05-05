# Merging Triplets to Form a Target Triplet — 判定是否能透過三元組的逐元素最大值構成目標三元組

## 問題的本質

給定一個由三個整數組成的三元組二維陣列 `triplets` 和一個目標三元組 `target`。從 `triplets` 中選擇任意子集，取逐元素最大值（element-wise maximum）後的結果是否與 `target` 完全一致，以 **boolean** 回傳判定結果。

## 核心概念

若某個三元組中的任一元素超過目標的對應元素，則將該三元組用於合併時，該位置的值會超過目標，因此絕對不能使用。反之，只合併所有元素皆不超過目標的三元組，就無需擔心超過目標，只需累積最大值，最終確認結果是否與目標一致即可。

## 思考過程

1. **辨識不可使用的三元組**：若三元組 `t` 的任一元素超過 `target` 的對應元素，將 `t` 納入合併會導致最大值超過目標。最大值一旦上升就無法降低，因此這類三元組絕對不能選取
2. **可使用的三元組全部採用即可**：所有元素皆不超過 `target` 的三元組，即使合併也不會超過目標。使用它們不會造成任何影響，因此可以貪心地全部採用
3. **如何累積合併結果**：以 `[0, 0, 0]` 初始化用於儲存結果的陣列 `result`，將可使用的三元組的各元素與 `result` 的各元素取最大值並更新。使用 `Math.max` 逐元素更新，即可得到所選全部三元組的 element-wise maximum
4. **最終判定**：處理完所有三元組後，若 `result` 與 `target` 完全一致則回傳 `true`，不一致則回傳 `false`。使用 `Arrays.equals` 可比較陣列的所有元素

## 前提知識

### 什麼是 element-wise maximum（逐元素最大值）

比較兩個以上陣列中相同位置的元素，在每個位置取最大值的操作。例如 `[2, 5, 3]` 與 `[5, 1, 6]` 的 element-wise maximum 為 `[5, 5, 6]`。

```java
int[] a = {2, 5, 3};
int[] b = {5, 1, 6};
int[] merged = new int[3];
merged[0] = Math.max(a[0], b[0]);  // max(2, 5) → 5
merged[1] = Math.max(a[1], b[1]);  // max(5, 1) → 5
merged[2] = Math.max(a[2], b[2]);  // max(3, 6) → 6
// merged = [5, 5, 6]
```

### 什麼是 Math.max

回傳兩個值中較大者的方法。用於累積合併結果。

```java
Math.max(3, 7);   // → 7
Math.max(5, 5);   // → 5
Math.max(0, 4);   // → 4（用於與初始值 0 比較並更新）
```

### 什麼是 Arrays.equals

判定兩個陣列的長度和所有元素是否一致，並以 boolean 回傳的方法。由於 `==` 運算子比較的是參照，因此要比較陣列的內容必須使用此方法。

```java
int[] a = {2, 5, 3};
int[] b = {2, 5, 3};
a == b;              // → false（因為參照不同）
Arrays.equals(a, b); // → true（因為所有元素一致）
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 只需遍歷三元組陣列一次（每個三元組的處理為 O(1)） |
| Space | O(1) — 僅使用長度為 3 的固定大小陣列 `result` |

## 程式碼

```java
// 輸入：二維整數陣列 triplets（每個元素為長度 3 的三元組）和長度為 3 的整數陣列 target
// 輸出：若三元組子集的 element-wise maximum 能構成 target 則回傳 true，否則回傳 false
public boolean mergeTriplets(int[][] triplets, int[] target) {
    // 以 [0, 0, 0] 初始化用於累積可使用三元組之 element-wise maximum 的陣列
    int[] result = new int[3];

    // 從頭到尾逐一遍歷 triplets 中的每個三元組 t
    for (int[] t : triplets) {
        // 若任一元素超過目標的三元組納入合併，最大值會超過目標且無法修正，因此跳過
        if (t[0] > target[0] ||
            t[1] > target[1] ||
            t[2] > target[2])
            continue;

        // 所有元素皆不超過目標，因此此更新不會導致 result 超過目標
        // 以各元素的最大值更新結果
        result[0] = Math.max(result[0], t[0]);
        result[1] = Math.max(result[1], t[1]);
        result[2] = Math.max(result[2], t[2]);
    }

    // 判定累積的結果是否與目標完全一致並回傳
    return Arrays.equals(result, target);
}
```
