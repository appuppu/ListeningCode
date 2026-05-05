# Searching for a Target in a Rotated Sorted Array — 在旋轉排序陣列中搜尋目標值

## 問題的本質

一個按升序排序的整數陣列在未知的樞軸點處被旋轉。需要在這個陣列中搜尋給定的 `target` 值，並返回其索引。如果 `target` 不存在則返回 `-1`。所有元素都是唯一的。

## 核心思路

將旋轉排序陣列從中間分割時，左半部分和右半部分中必定有一方是已排序的。透過範圍檢查來判定 `target` 是否包含在已排序的那一半中，若不包含則搜尋另一半，如此每次都能將搜尋範圍縮小一半。

## 思考過程

1. **因為是排序陣列，所以想使用 Binary Search**：對於一般的排序陣列，可以用 Binary Search 以 O(log n) 進行搜尋。即使存在旋轉，也要思考如何維持這個效率
2. **將旋轉陣列從中間分割時，其中一半必定是已排序的**：將陣列 `[4,5,6,7,0,1,2]` 在 `mid=3`（值為 7）處分割時，左半部分 `[4,5,6,7]` 是已排序的，右半部分 `[0,1,2]` 也是已排序的。因為旋轉的樞軸只會包含在其中一半，所以另一半必定保持升序
3. **如何判定哪一半是已排序的**：若 `nums[left] <= nums[mid]` 成立，則左半部分是已排序的。若不成立，則右半部分是已排序的。之所以包含等號，是為了正確處理 `left == mid` 的情況（即元素數量為 2 個以下時）
4. **判定 target 是否包含在已排序的那一半中**：已排序的那一半可以得知最小值和最大值，因此可以用不等式判定 `target` 是否在該範圍內。例如若左半部分是已排序的，則用 `target >= nums[left] && target < nums[mid]` 來判定
5. **搜尋包含 target 的那一半**：若 `target` 在已排序那一半的範圍內，則縮小到該半部分。若在範圍外，則 `target` 應該存在於另一半中，因此搜尋另一半
6. **迴圈結束時的處理**：若搜尋到 `left > right` 仍未找到 `target`，則 `target` 不存在於陣列中，返回 `-1`

## 前置知識

### 什麼是 Binary Search（二分搜尋）

在排序陣列中，透過反覆檢查搜尋範圍的中間元素並將搜尋範圍縮小一半的搜尋方法。因為每次範圍都減半，所以能以 O(log n) 的時間複雜度進行搜尋。

```java
int left = 0;
int right = nums.length - 1;
while (left <= right) {                    // 在搜尋範圍有效時持續迴圈
    int mid = left + (right - left) / 2;   // 防止溢位的中間值計算
    // 比較 nums[mid] 與 target，更新 left 或 right
}
```

### 什麼是旋轉排序陣列

將升序排序陣列在某個位置切開，並將後半部分移到前面的陣列。例如將 `[0,1,2,4,5,6,7]` 在索引 4 處旋轉後變成 `[4,5,6,7,0,1,2]`。整體陣列不是排序的，但樞軸的左右兩側各自是已排序的。

```
原始陣列:   [0, 1, 2, 4, 5, 6, 7]
旋轉後:     [4, 5, 6, 7, 0, 1, 2]
             已排序↑  ↑已排序
```

## 複雜度

| | 值 |
|---|---|
| Time | O(log n) — 因為每次將搜尋範圍縮小一半，最多只需 log n 次比較 |
| Space | O(1) — 僅使用 left、right、mid 三個變數，不需要額外的資料結構 |

## 程式碼

```java
// 輸入：旋轉排序整數陣列 nums 與整數 target
// 輸出：以 int 返回 target 的索引。若不存在則返回 -1
public int search(int[] nums, int target) {
    // 初始化搜尋範圍的兩端。這兩個變數代表搜尋範圍的兩端
    int left = 0;
    int right = nums.length - 1;

    // 當 left > right 時表示搜尋範圍已為空
    while (left <= right) {
        // 使用這個公式而非 (left + right) / 2，是為了防止 left + right 的整數溢位
        int mid = left + (right - left) / 2;

        // 若中間元素與 target 一致，則返回索引
        if (nums[mid] == target) {
            return mid;
        }

        // 判定左半部分是否為已排序
        // 包含等號是為了在 left == mid（搜尋範圍為 2 個元素以下）時，能正確判定左半部分為已排序
        if (nums[left] <= nums[mid]) {
            // 判定 target 是否在左半部分的範圍內
            if (target >= nums[left] && target < nums[mid]) {
                right = mid - 1;  // target 在左半部分的範圍內，因此縮小到左半部分
            } else {
                left = mid + 1;   // target 在左半部分的範圍外，因此縮小到右半部分
            }
        // 右半部分為已排序的情況
        } else {
            // 判定 target 是否在右半部分的範圍內
            if (target > nums[mid] && target <= nums[right]) {
                left = mid + 1;   // target 在右半部分的範圍內，因此縮小到右半部分
            } else {
                right = mid - 1;  // target 在右半部分的範圍外，因此縮小到左半部分
            }
        }
    }

    // 搜尋範圍已為空，因此 target 不存在於陣列中
    return -1;
}
```
