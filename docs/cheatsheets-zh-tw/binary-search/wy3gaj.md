# Searching for a Target in a Sorted Array — 在已排序陣列中尋找目標值的位置

## 問題的本質

給定一個已排序的整數陣列 `nums` 和一個整數 `target`。從陣列中找到與 `target` 相符的元素，並回傳該元素的**索引**。若 `target` 不存在於陣列中，則回傳 `-1`。

## 核心思路

由於陣列已排序，僅需將中間元素與目標值進行比較，即可每次將搜尋範圍縮小一半。藉此，搜尋可在 O(log n) 內完成，而非逐一檢查所有元素的 O(n)。

## 思考過程

1. **善用已排序的條件**：由於陣列已排序，只要查看任意位置的元素，即可判斷目標值位於該元素的左側還是右側。利用此性質，可以每次將搜尋範圍縮小一半
2. **以兩個指標管理搜尋範圍**：以指向陣列左端的 `left` 和指向右端的 `right` 兩個指標來表示搜尋範圍。初始狀態下，整個陣列即為搜尋範圍
3. **比較中間元素與目標值**：計算搜尋範圍的中間索引 `mid`，並將 `nums[mid]` 與 `target` 進行比較。若兩者相符，則 `mid` 即為答案
4. **依據比較結果將搜尋範圍縮小一半**：若 `nums[mid] < target`，表示目標值位於中間的右側，因此以 `left = mid + 1` 縮小左端。若 `nums[mid] > target`，表示目標值位於中間的左側，因此以 `right = mid - 1` 縮小右端
5. **重複執行直到搜尋範圍為空**：只要 `left <= right` 就持續搜尋。當 `left > right` 時，表示搜尋範圍已為空，目標值不存在於陣列中，因此回傳 `-1`
6. **防止計算中間索引時發生溢位**：`mid = (left + right) / 2` 可能導致 `left + right` 超過整數最大值。改寫為 `mid = left + (right - left) / 2` 即可避免溢位

## 前置知識

### Binary Search（二元搜尋）是什麼

二元搜尋是一種針對已排序陣列，透過每次將搜尋範圍縮小一半來高效尋找目標元素的演算法。將搜尋範圍的中間元素與目標值進行比較，若不相符，則捨棄左半部分或右半部分。重複此過程，搜尋次數即可降至 O(log n)。

```java
// 當陣列長度為 8 時的搜尋次數
// 第 1 次: 8 → 4（縮小一半）
// 第 2 次: 4 → 2（縮小一半）
// 第 3 次: 2 → 1（縮小一半）
// 最多 3 次 = log₂(8) = 3
```

### 中間索引的計算

求兩個指標 `left` 與 `right` 的中間位置。使用 `left + (right - left) / 2` 而非 `(left + right) / 2`，可以防止 `left + right` 相加時發生整數溢位。

```java
int left = 0;
int right = 10;
int mid = left + (right - left) / 2;  // mid = 0 + (10 - 0) / 2 = 5
```

### while 迴圈的條件 `left <= right`

`left <= right` 表示搜尋範圍中至少還剩一個元素。當 `left == right` 時，搜尋範圍中僅剩一個元素，由於仍需檢查該元素，因此使用 `<=` 而非 `<`。

```java
// 當 left=3, right=3 時，nums[3] 尚未被檢查
// left <= right 為 true，因此可以檢查 nums[3]
// 若使用 left < right 則為 false，將在未檢查 nums[3] 的情況下結束
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(log n) — 由於每次將搜尋範圍縮小一半，最多僅需 log₂(n) 次比較 |
| Space | O(1) — 僅使用指標變數，不需要額外的資料結構 |

## 程式碼

```java
// 輸入：已排序的整數陣列 nums 與整數 target
// 輸出：回傳與 target 相符之元素的索引（int 型別）。若不存在則回傳 -1
public int binarySearch(int[] nums, int target) {
    // 初始化搜尋範圍的左端與右端。以這兩個變數管理搜尋範圍
    int left = 0;
    int right = nums.length - 1;

    // left <= right：當搜尋範圍中至少還剩一個元素時，持續重複
    // 當 left > right 時，搜尋範圍為空，跳出迴圈
    while (left <= right) {
        // 注意：(left + right) / 2 可能因 left + right 的相加而發生整數溢位
        // 改寫為 left + (right - left) / 2 即可防止溢位
        int mid = left
            + (right - left) / 2;

        // 若中間元素與目標值相符，則回傳該索引
        if (nums[mid] == target) {
            return mid;
        }

        // 若目標值大於中間元素，則將搜尋範圍縮小至右半部分
        // 由於 mid 本身已被檢查過，因此設為 mid + 1
        if (nums[mid] < target) {
            left = mid + 1;
        }
        // 若目標值小於中間元素，則將搜尋範圍縮小至左半部分
        // 由於 mid 本身已被檢查過，因此設為 mid - 1
        else {
            right = mid - 1;
        }
    }

    // 搜尋範圍已為空，目標值不存在於陣列中
    return -1;
}
```
