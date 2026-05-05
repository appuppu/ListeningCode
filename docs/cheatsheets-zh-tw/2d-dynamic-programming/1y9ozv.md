# Maximizing Coins From Bursting Balloons — 優化戳破氣球的順序以最大化硬幣數量

## 問題的本質

給定一個整數陣列 `nums`（每個氣球的值）。當你戳破氣球 `i` 時，你會獲得 `nums[left] * nums[i] * nums[right]`（left 和 right 是相鄰的剩餘氣球）的硬幣。請返回戳破所有氣球後能獲得的最大硬幣數量。陣列邊界外的值視為 `1`。

## 核心思路

不是思考「按什麼順序戳破氣球」，而是反向思考：在區間 `[left, right]` 中「哪個氣球**最後**被戳破」。固定最後戳破的氣球 `k` 後，左右的子區間彼此獨立，可以透過區間DP來合成最優解。

## 思考過程

1. **希望消除戳破順序的依賴關係**：戳破氣球會改變相鄰關係，因此不同的戳破順序會產生不同的硬幣數量。窮舉所有順序需要 `n!` 種情況，這不切實際。我們需要一個能切斷這種依賴關係的觀點
2. **以「最後戳破」的角度思考可使區間獨立**：如果決定在區間 `[left, right]` 中最後戳破氣球 `k`，那麼在戳破 `k` 的時刻，`[left, k-1]` 和 `[k+1, right]` 的氣球已經全部消失。也就是說，`k` 的相鄰氣球固定為區間外側的 `arr[left-1]` 和 `arr[right+1]`。左右子問題變得獨立，因此可以用DP來合成結果
3. **簡化邊界處理**：在原始陣列的兩端添加值為 `1` 的虛擬氣球，建立新陣列 `arr`。設定 `arr[0] = 1`、`arr[n+1] = 1`，這樣就不需要對邊界條件做特殊處理，可以統一使用 `arr[left-1] * arr[k] * arr[right+1]` 的公式
4. **DP表格的定義**：將 `dp[left][right]` 定義為「戳破區間 `[left, right]` 中所有氣球所能獲得的最大硬幣數量」。最終答案為 `dp[1][n]`（對應原始陣列的整個區間）
5. **從較短的區間開始填表**：從長度為1的區間（單一氣球）開始，依序填到長度為 `n` 的區間。較長區間的值依賴於較短區間的值，因此從短區間開始計算可確保引用的值都已計算完畢
6. **對每個區間窮舉最後戳破的氣球**：對於區間 `[left, right]`，嘗試將最後戳破的氣球 `k` 從 `left` 到 `right` 逐一嘗試。最後戳破 `k` 時獲得的硬幣為 `arr[left-1] * arr[k] * arr[right+1] + dp[left][k-1] + dp[k+1][right]`，將此最大值記錄到 `dp[left][right]` 中

## 前置知識

### 區間DP（Interval DP）

以區間 `[left, right]` 為單位建構DP表格的方法。將區間分割後，組合子區間的最優解來求得整體的最優解。計算順序是從短區間到長區間的自底向上方式。

```java
// 區間DP的基本結構：從較短的區間長度開始依序計算
for (int len = 1; len <= n; len++) {        // 區間的長度
    for (int left = 1; left <= n - len + 1; left++) {  // 區間的左端
        int right = left + len - 1;          // 區間的右端
        // 計算 dp[left][right]
    }
}
```

### 哨兵（Sentinel）

在陣列兩端添加虛擬元素，以避免對邊界條件進行特殊處理的技巧。在這道題目中，我們在兩端放置值為 `1` 的氣球。

```java
int[] arr = new int[n + 2];   // 建立比原始陣列大2的陣列
arr[0] = 1;                   // 左端的哨兵（值為1）
arr[n + 1] = 1;               // 右端的哨兵（值為1）
for (int i = 0; i < n; i++)
    arr[i + 1] = nums[i];     // 將原始元素複製到索引1至n的位置
```

### 二維陣列的DP表格

使用 `dp[i][j]` 記錄區間 `[i, j]` 的最優解。在Java中，使用 `new int[n+2][n+2]` 建立時，所有元素都會初始化為 `0`。空區間（`left > right`）的值維持 `0` 即可，因此不需要額外的初始化處理。

```java
int[][] dp = new int[n + 2][n + 2];  // 所有元素初始化為0
dp[left][right];                      // 儲存區間[left, right]的最大硬幣數量
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n³) — 區間左端、右端、最後戳破位置的三重迴圈 |
| Space | O(n²) — 使用DP表格 `dp[n+2][n+2]` |

## 程式碼

```java
// 輸入：整數陣列 nums（每個氣球的值）
// 輸出：以 int 返回戳破所有氣球後能獲得的最大硬幣數量
public int maxCoins(int[] nums) {
    int n = nums.length;

    // 建立在兩端添加哨兵（值為1）的陣列
    // 透過這些哨兵，在引用區間外側時不需要對邊界條件進行特殊處理
    int[] arr = new int[n + 2];
    arr[0] = arr[n + 1] = 1;
    for (int i = 0; i < n; i++)
        arr[i + 1] = nums[i];

    // dp[left][right] = 戳破區間[left, right]中所有氣球所能獲得的最大硬幣數量
    // 大小設為n+2是為了包含哨兵的索引（0和n+1）
    // 空區間（left > right）的值維持0即可
    int[][] dp = new int[n + 2][n + 2];

    // 從較短的區間長度開始依序計算
    // 從短區間開始計算，可以保證在計算長區間時所需的子區間值都已經計算完畢
    for (int len = 1; len <= n; len++) {
        // 走訪所有長度為len的區間
        for (int left = 1; left <= n - len + 1; left++) {
            int right = left + len - 1;

            // 窮舉區間[left, right]中最後戳破的氣球k
            for (int k = left; k <= right; k++) {
                // 決定最後戳破k時，k的相鄰氣球固定為區間外的arr[left-1]和arr[right+1]
                int coins = arr[left - 1] * arr[k] * arr[right + 1];
                // 加上左右子區間的硬幣數量，求得總計
                int total = coins + dp[left][k - 1] + dp[k + 1][right];
                // 以最大值更新dp[left][right]
                dp[left][right] = Math.max(dp[left][right], total);
            }
        }
    }

    // 返回對應原始陣列整體（索引1至n）的最大硬幣數量
    return dp[1][n];
}
```
