# Counting Ways to Assign Signs to Reach a Target Sum — 計算透過符號分配達到目標總和的方法數

## 問題的本質

給定一個整數陣列 `nums` 和一個整數 `target`。對 `nums` 的每個元素分配 `+` 或 `-` 符號，返回使所有元素總和等於 `target` 的組合數。

## 核心思路

對每個元素分配 `+` 或 `-` 的問題，等同於將陣列分割為「正符號群組（P）」和「負符號群組（N）」的問題。由 P - N = target 且 P + N = totalSum 可推導出 P = (target + totalSum) / 2，因此問題可以轉換為「計算總和為 P 的子集數量」的子集和問題。

## 思考過程

1. **將符號分配視為集合的分割**：將分配 `+` 的元素總和設為 P，分配 `-` 的元素總和設為 N，則 P - N = target 成立。同時 P + N = totalSum（所有元素的總和）也成立。聯立這兩個方程式可得 P = (target + totalSum) / 2
2. **先排除不存在解的條件**：當 P = (target + totalSum) / 2 不是整數時（即 `(target + totalSum)` 為奇數時），不存在有效的分割。此外，當 `|target|` 超過 `totalSum` 時也不存在解。先檢查這些條件並返回 0
3. **用 DP 作為子集和問題來求解**：「從陣列 `nums` 中選擇元素使總和為 `subsetSum`（= P）的組合數」是典型的子集和計數問題。定義 DP 陣列 `dp[j]` 為「總和為 j 的子集數量」，對每個元素進行更新
4. **使用一維 DP 陣列優化空間**：不使用二維表格，而是準備一維陣列 `dp[0..subsetSum]`，對每個元素 `num`，將 `j` 從 `subsetSum` 到 `num` 逆序遍歷，執行 `dp[j] += dp[j - num]` 的更新。逆序遍歷的原因是防止同一個元素被多次使用
5. **設定初始條件**：設定 `dp[0] = 1`。這表示「不選擇任何元素使總和為 0 的方法有 1 種」
6. **最終返回值**：處理完所有元素後的 `dp[subsetSum]` 就是總和為 `subsetSum` 的子集數量，即原始問題的答案

## 前提知識

### 子集和問題（Subset Sum Problem）

從給定的集合中選擇元素，求其總和等於特定值的組合。這是背包問題的一種，可以用 DP 高效求解。

### 使用一維 DP 陣列的子集和計數

`dp[j]` 表示「總和為 j 的子集數量」。對每個元素 `num`，透過 `dp[j] += dp[j - num]` 進行更新。

```java
int[] dp = new int[targetSum + 1]; // dp[j] = 總和為 j 的組合數
dp[0] = 1;                         // 使總和為 0 的方法有 1 種（不選擇任何元素）
dp[j] += dp[j - num];              // 使用 num 湊出 j = 加上不使用 num 湊出 j-num 的方法數
```

### 逆序迴圈的原因

內層迴圈從 `subsetSum` 到 `num` 逆序執行。若正序執行，會在同一次迭代中將同一個元素 `num` 多次累加。逆序可以滿足每個元素「選或不選」的 0-1 背包約束。

```java
// 逆序迴圈：每個元素最多使用 1 次（0-1 背包）
for (int j = subsetSum; j >= num; j--) {
    dp[j] += dp[j - num];
}
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n × subsetSum) — 對每個元素遍歷 DP 陣列一次 |
| Space | O(subsetSum) — 僅使用一維 DP 陣列 |

## 程式碼

```java
// 輸入：整數陣列 nums 和整數 target
// 輸出：對每個元素分配 +/- 使總和等於 target 的組合數，以 int 返回
public int findTargetSumWays(int[] nums, int target) {
    // 計算陣列 nums 所有元素的總和，並存入變數 totalSum
    int totalSum = 0;
    for (int num : nums) {
        totalSum += num;
    }

    // 檢查不存在解的條件
    // 當 (target + totalSum) 為奇數時，P = (target + totalSum) / 2 不是整數，
    // 由整數個元素組成的子集無法達成，因此返回 0
    // 當 |target| 超過 totalSum 時，無論如何分配符號都無法達到 target，因此返回 0
    if ((target + totalSum) % 2 != 0
        || Math.abs(target) > totalSum)
        return 0;

    // 求正符號群組的總和值。這是後續處理中要達成的目標值
    int subsetSum = (target + totalSum) / 2;

    // dp[j] = 從 nums 的元素中選擇使總和為 j 的組合數
    int[] dp = new int[subsetSum + 1];
    // 基底情況：不選擇任何元素使總和為 0 的方法有 1 種
    dp[0] = 1;

    // 外層迴圈：從頭到尾依序遍歷陣列 nums 的每個元素
    for (int num : nums) {
        // 內層迴圈：從 subsetSum 到 num 逆序遍歷
        // 逆序的原因：防止在同一次迭代中多次使用同一個 num（0-1 背包約束）
        for (int j = subsetSum; j >= num; j--) {
            // 將不使用 num 湊出總和 j - num 的方法數，加到使用 num 湊出總和 j 的方法數中
            dp[j] += dp[j - num];
        }
    }

    // dp[subsetSum] 為總和等於 subsetSum 的子集數量，即原始問題中符號分配方式的總數
    return dp[subsetSum];
}
```
