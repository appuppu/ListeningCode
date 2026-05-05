# Finding the Best Time to Buy and Sell a Stock — 從股價陣列中求出一次買賣所能獲得的最大利潤

## 問題的本質

給定一個整數陣列 `prices`。每個元素 `prices[i]` 代表第 `i` 天的股價。在只能進行一次「買入→賣出」的條件下，返回所能獲得的**最大利潤**。如果無法獲得利潤，則返回 `0`。買入日必須在賣出日之前。

## 核心思路

從左到右遍歷陣列，同時持續記錄「目前為止的最低價」，只要將每天的價格減去最低價，就能以 O(1) 求出在該天賣出時的最大利潤。對所有天數取此利潤的最大值即為答案。

## 思考過程

1. **利潤由「賣價 − 買價」決定**：在某天賣出時，要使利潤最大化，買價應盡可能小。也就是說，應在賣出日之前所有天數中以最低價買入
2. **希望高效地求出每天「該天之前的最低價」**：從左到右遍歷陣列，同時用變數 `minPrice` 追蹤目前為止所見價格的最小值。每看到新價格時只需更新 `minPrice`，不需要額外的陣列，空間複雜度為 O(1)
3. **計算每天「賣出時的利潤」**：遍歷中對於每天 `i`，`prices[i] - minPrice` 就是在該天賣出時的最大利潤。將此值與變數 `maxProfit` 比較，若更大則更新 `maxProfit`
4. **整理 minPrice 的更新與利潤計算之間的關係**：若當前價格小於 `minPrice`，則更新 `minPrice`。在這天賣出利潤為負，因此不需要計算利潤。若當前價格大於等於 `minPrice`，則計算利潤並更新 `maxProfit`
5. **無法獲得利潤時的處理**：若股價單調遞減，`maxProfit` 將維持初始值 `0` 而不會被更新。無需條件分支即可自然地返回 `0`
6. **最終返回的內容**：返回遍歷完陣列後 `maxProfit` 的值。這就是一次買賣所能獲得的最大利潤

## 前備知識

### Integer.MAX_VALUE 是什麼

Java `int` 型別可取的最大值（2,147,483,647）。在尋找最小值的演算法中用作初始值。由於保證比任何股價都大，在第一次比較時必定會被替換為實際的股價。

```java
int minPrice = Integer.MAX_VALUE;  // 設定一個足夠大的值作為最小值的初始值
// 如果 prices[0] 為 7，因為 7 < Integer.MAX_VALUE，minPrice 會被更新為 7
```

### Math.max 是什麼

接收兩個 `int` 值並返回較大值的靜態方法。可以用一行完成最大值的更新處理。

```java
int a = 5;
int b = 3;
Math.max(a, b);  // → 返回 5

// 用於更新最大利潤
maxProfit = Math.max(maxProfit, profit);  // 如果 profit 較大，則更新 maxProfit
```

### Running Minimum（遍歷中的最小值追蹤）是什麼

在遍歷陣列的過程中，用變數追蹤目前為止所見元素的最小值的手法。在每一步將當前元素與變數比較，用較小的值更新變數。藉此，可以在任意位置以 O(1) 取得「該位置之前的最小值」。

```java
int minPrice = Integer.MAX_VALUE;
for (int price : prices) {
    if (price < minPrice) {
        minPrice = price;  // 更新目前為止的最低價
    }
    // 此時 minPrice 保持著 prices[0] 到 prices[當前] 中的最小值
}
```

## 計算量

| | 值 |
|---|---|
| Time | O(n) — 只需遍歷陣列一次 |
| Space | O(1) — 僅使用 2 個變數（minPrice、maxProfit） |

## 程式碼

```java
// 輸入：整數陣列 prices（每個元素為每日的股價）
// 輸出：以 int 返回一次買賣所能獲得的最大利潤。無法獲得利潤時返回 0
public int maxProfit(int[] prices) {
    // 追蹤目前為止最低價的變數。以 Integer.MAX_VALUE 初始化，確保在與第一個價格比較時必定更新為實際的股價
    int minPrice = Integer.MAX_VALUE;
    // 追蹤目前為止最大利潤的變數。以 0 初始化，使得在無法獲得利潤的情況下自然地返回 0
    int maxProfit = 0;

    // 使用 for-each 迴圈從頭到尾逐一遍歷陣列
    for (int price : prices) {
        if (price < minPrice) {
            // 若當前價格小於最低價，則更新最低價
            // 這天是最低價的更新日，在這天賣出不會產生利潤（利潤為負）。因此跳過利潤計算
            minPrice = price;
        } else {
            // 計算在最低價當天買入、今天賣出時的利潤
            int profit = price - minPrice;
            // 若利潤超過目前的最大值，則更新最大利潤
            maxProfit = Math.max(maxProfit, profit);
        }
    }
    // 迴圈結束時的 maxProfit 即為整個陣列中的最大利潤
    return maxProfit;
}
```
