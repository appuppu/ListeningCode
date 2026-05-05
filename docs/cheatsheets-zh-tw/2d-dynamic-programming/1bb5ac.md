# Maximizing Stock Profit With a Cooldown Period — 求解附冷卻期的股票交易最大利益

## 問題的本質

給定一個股價陣列 `prices`，每個索引代表一個日期。可以多次買賣股票，但賣出後的隔天為**冷卻期**，不能進行交易。在此限制條件下，返回能獲得的**最大利益**。

## 核心思路

將每天的狀態分為「持有股票（hold）」「剛賣出（sold）」「休息中（rest）」三種，定義從前一天的三種狀態到當天三種狀態的轉移。由於每天只依賴前一天的狀態，因此不需要陣列，只需三個變數即可管理狀態。

## 思考過程

1. **每天有三種狀態**：在某天結束時，自己處於「持有股票（hold）」「當天賣出（sold）」「什麼都沒做（rest）」其中之一。這三種狀態能涵蓋所有情況
2. **定義狀態之間的轉移**：hold 取「前一天也是 hold 且什麼都不做」或「前一天是 rest 且今天買入」中的較大值。sold 為「前一天是 hold 且今天賣出」。rest 取「前一天也是 rest 且什麼都不做」或「前一天是 sold 且冷卻期結束」中的較大值。冷卻期的限制透過「sold 的隔天不能轉移到 hold」這個規則自然地表達出來
3. **設定初始狀態**：如果在第 0 天買入，則 hold = -prices[0]（利益為負值）。第 0 天還無法賣出或休息，因此 sold = Integer.MIN_VALUE（表示此狀態尚未到達），rest = 0（什麼都不做則利益為 0）
4. **每天只依賴前一天的狀態**：從轉移公式可以看出，當天的每個狀態只需從前一天的三種狀態計算得出。也就是說，不需要保存所有天數的陣列，只需每天更新三個變數即可
5. **需要同時更新**：當天的 hold、sold、rest 全部從前一天的值計算而來，因此需要先將新值存入臨時變數，然後再一起覆寫前一天的變數。如果逐一覆寫，計算時仍需使用的前一天的值會被覆蓋掉
6. **最終返回的值**：在最後一天仍持有股票並非最佳策略，因此 prevSold 和 prevRest 中的較大值即為最大利益

## 前置知識

### 何謂狀態機（State Machine）

狀態機是由有限個狀態和狀態間的轉移規則所構成的模型。在每個時間點必定處於某一個狀態，並根據輸入轉移到另一個狀態。在這道題目中，將交易建模為具有 hold / sold / rest 三種狀態的狀態機。

```
rest ---(買入)---> hold
hold ---(賣出)---> sold
sold ---(等待)---> rest（冷卻期）
hold ---(持續)---> hold
rest ---(持續)---> rest
```

### 何謂 Math.max

Math.max 是返回兩個整數中較大值的方法。在狀態轉移中有多個選項時，用它來選擇利益較大的一方。

```java
Math.max(3, 7);    // → 7（返回較大的值）
Math.max(-5, -2);  // → -2（即使是負數也返回較大的值）
```

### 何謂 Integer.MIN_VALUE

Integer.MIN_VALUE 是 Java 的 int 型別能取的最小值（-2,147,483,648）。用來表示「此狀態尚未到達」。由於與任何值比較時都不會被 Math.max 選中，因此可以安全地忽略尚未到達的狀態。

```java
int x = Integer.MIN_VALUE;  // 表示尚未到達的狀態
Math.max(x, 0);             // → 0（尚未到達的狀態不會被選中）
```

## 計算複雜度

| | 值 |
|---|---|
| Time | O(n) — 只需遍歷陣列一次 |
| Space | O(1) — 僅用三個變數來管理狀態 |

## 程式碼

```java
// 輸入：整數陣列 prices（每個元素為當天的股價）
// 輸出：在冷卻期限制下能獲得的最大利益，以 int 返回
public int maxProfit(int[] prices) {
    int n = prices.length;
    // 買賣股票至少需要2天。若 n < 2 則無法成立交易，返回 0
    if (n < 2) return 0;

    // 初始化第 0 天的各狀態
    int prevHold = -prices[0];          // 在第 0 天買入時的利益（因為是支出所以為負值）
    int prevSold = Integer.MIN_VALUE;   // 第 0 天不可能賣出（表示尚未到達）
    int prevRest = 0;                   // 什麼都不做則利益為 0

    for (int i = 1; i < n; i++) {
        // 從前一天的三種狀態計算當天的三種狀態
        // newHold：取「前一天也持有（prevHold）」或「前一天休息且今天買入（prevRest - prices[i]）」中的較大值
        // 注意：「前一天是 sold 且今天買入」不在選項中。這就是冷卻期限制的體現
        int newHold = Math.max(prevHold,
            prevRest - prices[i]);

        // newSold：將持有的股票在今天賣出。賣出只能從 hold 轉移而來，因此不需要 Math.max
        int newSold = prevHold + prices[i];

        // newRest：取「前一天也休息（prevRest）」或「前一天賣出且冷卻期結束（prevSold）」中的較大值
        int newRest = Math.max(prevRest,
            prevSold);

        // 全部計算完成後再一起更新
        // 為了避免在計算過程中覆寫前一天的值，先求出三個新值後再進行賦值
        prevHold = newHold;
        prevSold = newSold;
        prevRest = newRest;
    }
    // 在最後一天仍持有股票（prevHold）無法實現利益，因此不是最佳策略
    // sold 和 rest 中的較大值即為最大利益
    return Math.max(prevSold, prevRest);
}
```
