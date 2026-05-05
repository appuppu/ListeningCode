# Finding the Starting Gas Station for a Circular Route — 尋找能夠繞行環形路線一周的起始加油站

## 問題的本質

給定長度為 `n` 的整數陣列 `gas` 和 `cost`。`gas[i]` 是在站點 `i` 獲得的燃料，`cost[i]` 是從站點 `i` 移動到下一個站點所需的燃料。返回能夠繞行環形路線一周的起始站點索引。如果不存在能夠繞行一周的站點，則返回 `-1`。解最多只存在一個。

## 核心思路

如果所有站點的燃料收支總和為非負數，則必定存在解。由於到燃料餘量變為負數的地點為止的站點都不可能成為起始地點，因此將下一個站點設為新的起始候選並重置，只需一次遍歷即可找到答案。

## 思考過程

1. **考慮每個站點的燃料收支**：在站點 `i` 獲得 `gas[i]` 的燃料並消耗 `cost[i]` 的燃料，因此淨燃料變化可表示為 `net = gas[i] - cost[i]`。若 `net` 為正數，該站點產生燃料盈餘；若為負數，則產生燃料不足
2. **判定能否繞行一周的條件**：若所有站點的 `net` 總和（`totalBalance`）為非負數，表示整條路線獲得的燃料大於或等於消耗的燃料，因此必定能從某個起始地點繞行一周。反之，若 `totalBalance` 為負數，則無論從哪裡出發燃料都不夠，所以不存在解
3. **高效地篩選起始候選**：假設從站點 `start` 出發進行遍歷，在某個地點 `i` 累積燃料餘量（`currentBalance`）變為負數。此時，從 `start` 到 `i` 之間的任何站點出發，都無法越過 `i`。原因是從 `start` 到中途站點 `j` 為止的累積值為非負數，因此若從 `j` 出發，將以更少的燃料到達 `i`。所以可以一次性排除從 `start` 到 `i` 的所有站點，將 `i + 1` 設為新的起始候選
4. **重置 currentBalance 並繼續遍歷**：為了從新的起始候選 `i + 1` 重新追蹤燃料餘量，將 `currentBalance` 重置為 `0`，並將 `start` 更新為 `i + 1`。遍歷本身只需從頭到尾執行一次即可
5. **遍歷結束後透過 totalBalance 進行最終判定**：遍歷結束時，若 `totalBalance >= 0` 則存在解，返回 `start`。若 `totalBalance < 0` 則無法繞行一周，返回 `-1`

## 前置知識

### net（淨燃料變化）的定義

每個站點的燃料收支。透過 `net = gas[i] - cost[i]` 計算。正數表示燃料有盈餘，負數表示燃料不足。

```java
int net = gas[i] - cost[i];  // 計算站點i的燃料收支
// 例：gas[i]=3, cost[i]=5 時 net=-2（燃料不足2）
// 例：gas[i]=4, cost[i]=1 時 net=3（燃料盈餘3）
```

### totalBalance 和 currentBalance 的作用

`totalBalance` 是整條路線的燃料收支總和，用於判定是否能繞行一周。`currentBalance` 是從當前起始候選到遍歷中站點為止的累積燃料餘量，用於判定是否需要更新起始候選。

```java
int totalBalance = 0;    // 整條路線的燃料收支總和（用於判定是否能繞行一周）
int currentBalance = 0;  // 從當前起始候選開始的累積燃料餘量（用於判定是否更新候選）
totalBalance += net;     // 對所有站點持續加算
currentBalance += net;   // 每次重置起始候選時歸零
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 只需遍歷陣列一次 |
| Space | O(1) — 僅使用3個變數，不依賴輸入規模 |

## 程式碼

```java
// 輸入：整數陣列 gas（每個站點獲得的燃料）和整數陣列 cost（從每個站點移動到下一個站點所需的燃料）
// 輸出：以 int 返回能夠繞行環形路線一周的起始站點索引。無法繞行一周時返回 -1
public int canCompleteCircuit(int[] gas, int[] cost) {
    // 整條路線的燃料收支總和（用於最終判定是否能繞行一周）
    int totalBalance = 0;
    // 從當前起始候選開始的累積燃料餘量（用於判定是否重置候選）
    int currentBalance = 0;
    // 起始候選的索引（從0開始，每次重置時更新）
    int start = 0;

    // 從索引0到陣列末尾逐一遍歷
    for (int i = 0; i < gas.length; i++) {
        // 計算站點i的淨燃料變化
        int net = gas[i] - cost[i];
        // 持續加算到整條路線的燃料收支中（最終用於判定是否能繞行一周）
        totalBalance += net;
        // 加算到從當前起始候選開始的累積燃料餘量中（相當於到達站點i時的燃料餘量）
        currentBalance += net;

        // 若累積燃料餘量變為負數，則從start到i的任何站點都不可能成為起始地點
        if (currentBalance < 0) {
            // 重置累積燃料餘量，並將下一個站點設為新的起始候選
            currentBalance = 0;
            start = i + 1;
        }
    }
    // 若整條路線的燃料收支為非負數，則能繞行一周，返回start；若為負數則無法繞行，返回-1
    return totalBalance >= 0 ? start : -1;
}
```
