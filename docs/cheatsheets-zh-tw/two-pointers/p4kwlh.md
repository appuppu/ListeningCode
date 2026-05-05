# Calculating Trapped Rainwater Between Bars — 計算柱子之間積存的雨水總量

## 問題的本質

給定一個非負整數陣列 `height`，每個元素代表寬度為1的柱子高度，構成一個高低差地圖。計算並返回降雨後柱子之間能積存的**水的總量**。

## 核心思路

某個位置能積存的水量，等於「左側最大高度與右側最大高度中較小的一方」減去「該位置柱子的高度」。從左右兩端向內移動指標，同時更新各自一側的最大高度，就能在不使用額外陣列的情況下計算每個位置的水量。

## 思考過程

1. **每個位置的水量由左右最大高度決定**：位置 `i` 能積存的水量為 `min(左側最大高度, 右側最大高度) - height[i]`。因為水只能積存到左右牆壁中較低一方的高度為止
2. **希望高效地求出左右最大高度**：若在每個位置都重新遍歷左右的最大高度，時間複雜度為 O(n²)。準備兩個陣列進行預計算可以達到 O(n)，但需要 Space O(n)。考慮以 Space O(1) 實現的方法
3. **從左右兩端向內移動指標**：在左端放置指標 `left`，在右端放置指標 `right`，向內側移動。用變數 `maxLeftHeight` 和 `maxRightHeight` 追蹤各指標一側目前為止見過的最大高度
4. **移動較小一側的指標**：當 `height[left] <= height[right]` 時，可以保證左側的最大高度不超過右側的最大高度。因為右側至少存在一面高度不低於 `height[right]` 的牆壁。因此，在左側指標的位置，僅憑 `maxLeftHeight` 就能確定水量
5. **移動指標後再加算水量**：將指標前進一步後，在新的位置更新最大高度，並將 `maxLeftHeight - height[left]`（或 `maxRightHeight - height[right]`）加到水量中。由於最大高度始終不小於當前柱子的高度，因此此差值必定為0以上
6. **兩個指標相遇時結束**：在 `left < right` 的條件下持續迴圈，返回所有位置水量的總和 `totalwater`

## 前置知識

### Two Pointers（雙指標）

在陣列的兩端或不同位置放置兩個指標，根據條件移動其中一個來進行遍歷的技巧。能夠在一次遍歷中處理整個陣列，適用於已排序陣列或從兩端進行搜尋的場景。

```java
int left = 0;                    // 左端的指標
int right = height.length - 1;   // 右端的指標
while (left < right) {           // 持續迴圈直到兩個指標相遇
    // 根據條件用 left++ 或 right-- 將指標向內側移動
}
```

### Math.max

返回兩個值中較大值的 Java 靜態方法。在此用於每次指標前進時更新目前為止的最大高度。

```java
int maxHeight = 3;
maxHeight = Math.max(maxHeight, 5);  // maxHeight 更新為 5
maxHeight = Math.max(maxHeight, 2);  // maxHeight 維持 5（因為 2 < 5）
```

### 水積存的條件

某個位置要能積存水，該位置的左右兩側都必須存在比當前柱子更高的牆壁。積存的水量等於「左右牆壁中較低一方的高度」減去「當前柱子的高度」。

```
// height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]
// 位置2（高度0）：左側最大=1, 右側最大=3 → min(1,3) - 0 = 1 的水積存
// 位置5（高度0）：左側最大=2, 右側最大=3 → min(2,3) - 0 = 2 的水積存
```

## 複雜度

| | 值 |
|---|---|
| Time | O(n) — 左右指標合計移動n次，對陣列進行一次遍歷 |
| Space | O(1) — 僅使用指標和最大高度的變數，不需要額外的陣列 |

## 程式碼

```java
// 輸入：非負整數陣列 height（每個元素代表柱子的高度）
// 輸出：以 int 返回柱子之間積存的水的總量
public int trap(int[] height) {
    // 將積存水的總量變數初始化為0
    int totalwater = 0;

    // 將左指標設定在陣列的開頭，右指標設定在陣列的末尾
    int left = 0;
    int right = height.length - 1;

    // 初始化左右各自目前為止的最大高度
    // 因為兩端的柱子本身不會積存水，所以將其作為初始值使用
    int maxLeftHeight = height[left];
    int maxRightHeight = height[right];

    // 持續迴圈直到兩個指標相遇
    while (left < right) {
        // 當 height[left] <= height[right] 時，右側至少存在高度為 height[right] 的牆壁
        // 因此僅憑左側最大高度就能確定水量
        if (height[left] <= height[right]) {
            // 將指標向右前進一步後再計算水量
            left++;
            // 更新目前為止的左側最大高度
            maxLeftHeight = Math.max(maxLeftHeight, height[left]);
            // 由於 maxLeftHeight 始終不小於 height[left]，加算值必定為0以上
            totalwater += maxLeftHeight - height[left];
        } else {
            // 當 height[left] > height[right] 時，左側至少存在高度為 height[left] 的牆壁
            // 因此僅憑右側最大高度就能確定水量
            right--;
            // 更新目前為止的右側最大高度
            maxRightHeight = Math.max(maxRightHeight, height[right]);
            // 由於 maxRightHeight 始終不小於 height[right]，加算值必定為0以上
            totalwater += maxRightHeight - height[right];
        }
    }
    // 迴圈結束後，返回所有位置水量的總和 totalwater
    return totalwater;
}
```
