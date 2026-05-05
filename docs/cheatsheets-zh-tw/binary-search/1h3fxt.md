# Searching for a Value in a Sorted Matrix — 在排序矩陣中搜尋目標值

## 問題的本質

給定一個 m×n 的矩陣。每一行按升序排序，且每一行的首元素大於前一行的末尾元素。判定給定的 `target` 是否存在於該矩陣中，並以 `boolean` 回傳結果。

## 核心思路

將整個矩陣從左上到右下排成一列，即可視為一個排序陣列。利用一維索引 `mid` 到矩陣座標 `[mid / n][mid % n]` 的轉換，無需將矩陣展平，即可透過一次二分搜尋以 O(log(m * n)) 的時間複雜度完成搜尋。

## 思考過程

1. **整個矩陣是一個排序陣列**：每一行按升序排列，且下一行的首元素大於前一行的末尾元素，因此從左上到右下依序讀取矩陣的元素，整體構成一個升序排序陣列
2. **排序陣列可使用二分搜尋**：總元素數為 `m * n` 個，因此在 0 到 `m * n - 1` 的範圍內進行二分搜尋即可。設定搜尋範圍的下限 `lo = 0`、上限 `hi = m * n - 1`
3. **需要將一維索引轉換為二維座標**：二分搜尋的中間點 `mid` 是一維索引。要從矩陣中取得值需要二維座標，因此將行索引轉換為 `mid / n`（除以列數的商），列索引轉換為 `mid % n`（除以列數的餘數）
4. **套用標準的二分搜尋邏輯**：若透過 `matrix[mid / n][mid % n]` 取得的值等於 `target`，則回傳 `true`。若該值較小，則以 `lo = mid + 1` 將搜尋範圍縮小至右半部分；若該值較大，則以 `hi = mid - 1` 將搜尋範圍縮小至左半部分
5. **搜尋範圍耗盡則 target 不存在**：若直到 `lo > hi` 仍未匹配，則表示矩陣中不存在 `target`，回傳 `false`

## 前置知識

### 二分搜尋（Binary Search）

針對排序陣列，透過每次將搜尋範圍縮減一半來快速找到目標值的演算法。對於元素數為 n 的陣列，最多進行 log₂(n) 次比較即可得到結果。

```java
int lo = 0, hi = array.length - 1;  // 設定搜尋範圍的下限與上限
while (lo <= hi) {                    // 當搜尋範圍存在時持續迴圈
    int mid = lo + (hi - lo) / 2;    // 在避免溢位的同時計算中間點
    if (array[mid] == target)         // 判定中間點的值是否與target一致
        return true;
    else if (array[mid] < target)
        lo = mid + 1;                // target位於右半部分，因此提高下限
    else
        hi = mid - 1;                // target位於左半部分，因此降低上限
}
return false;                         // 未找到的情況
```

### 一維索引與二維座標的轉換

在列數為 `n` 的矩陣中，透過除法與取餘數將一維索引 `idx` 轉換為二維座標。此轉換使我們能將矩陣視為虛擬的一維陣列來處理。

```java
int n = matrix[0].length;        // 取得列數
int row = idx / n;               // 商為行索引（例：idx=7, n=4 → row=1）
int col = idx % n;               // 餘數為列索引（例：idx=7, n=4 → col=3）
int val = matrix[row][col];      // 以二維座標取得矩陣的值
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(log(m * n)) — 對全部 m * n 個元素進行一次二分搜尋 |
| Space | O(1) — 僅使用指標變數，不需要額外的資料結構 |

## 程式碼

```java
// 輸入：m×n 的整數矩陣 matrix 與整數 target
// 輸出：若 target 存在於矩陣中則回傳 true，否則回傳 false
public boolean searchMatrix(int[][] matrix, int target) {
    // 取得矩陣的行數與列數。用於計算總元素數及一維→二維轉換
    int m = matrix.length;
    int n = matrix[0].length;

    // 將二分搜尋的搜尋範圍設定為整個矩陣
    // lo=0 對應矩陣的左上角，hi=m*n-1 對應矩陣的右下角
    int lo = 0, hi = m * n - 1;

    // 當 lo > hi 時搜尋範圍耗盡，可判定 target 不存在
    while (lo <= hi) {
        // 使用此形式而非 (lo + hi) / 2，以防止 lo + hi 的整數溢位
        int mid = lo + (hi - lo) / 2;

        // 將一維索引轉換為二維座標並取得值
        // 行索引 = mid / n（商），列索引 = mid % n（餘數）
        int val = matrix[mid / n][mid % n];

        if (val == target)
            return true;           // 找到目標值，回傳 true
        else if (val < target)
            lo = mid + 1;          // target 位於右半部分（較大側），因此提高下限
        else
            hi = mid - 1;          // target 位於左半部分（較小側），因此降低上限
    }

    // 迴圈結束仍未回傳 true，表示 target 不存在於矩陣中
    return false;
}
```
