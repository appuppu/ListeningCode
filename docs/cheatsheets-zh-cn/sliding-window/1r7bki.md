# 买卖股票的最佳时机 — 从股价数组中求一次交易能获得的最大利润

## 问题的本质

给定一个整数数组 `prices`，其中每个元素 `prices[i]` 表示第 `i` 天的股价。在只能进行一次"买入→卖出"的条件下，返回能获得的**最大利润**。如果无法获得利润，则返回 `0`。买入日必须在卖出日之前。

## 核心思路

从左到右遍历数组，同时持续记录"迄今为止的最低价"，这样对于每一天，只需用当天价格减去最低价，就能以 O(1) 的时间求出在该天卖出时的最大利润。对所有天取该利润的最大值即为答案。

## 思考过程

1. **利润由"卖价 − 买价"决定**：在某天卖出时，要使利润最大化，就需要尽可能降低买价。也就是说，应该在卖出日之前的所有日期中以最低价买入
2. **需要高效地求出每天之前的最低价**：从左到右遍历数组，同时用变量 `minPrice` 追踪迄今为止的最小价格。每遇到新价格只需更新 `minPrice`，因此不需要额外的数组，空间复杂度为 O(1)
3. **计算每天"卖出时的利润"**：遍历过程中，对于每一天 `i`，`prices[i] - minPrice` 即为在该天卖出时的最大利润。将该值与变量 `maxProfit` 比较，如果更大则更新 `maxProfit`
4. **整理 minPrice 的更新与利润计算的关系**：如果当前价格小于 `minPrice`，则更新 `minPrice`。在该天卖出利润为负，因此无需计算利润。如果当前价格大于等于 `minPrice`，则计算利润并更新 `maxProfit`
5. **无法获得利润时的处理**：当股价单调递减时，`maxProfit` 保持初始值 `0` 不会被更新。无需条件分支，自然返回 `0`
6. **最终返回值**：遍历数组一次结束后，返回 `maxProfit` 的值。这就是一次交易能获得的最大利润

## 前置知识

### 什么是 Integer.MAX_VALUE

Java 中 `int` 类型能取到的最大值（2,147,483,647）。在寻找最小值的算法中用作初始值。由于该值保证大于任何股价，因此第一次比较时必定会被替换为实际的股价。

```java
int minPrice = Integer.MAX_VALUE;  // 将最小值的初始值设为足够大的值
// 如果 prices[0] 为 7，则 7 < Integer.MAX_VALUE，所以 minPrice 会被更新为 7
```

### 什么是 Math.max

接收两个 `int` 值并返回较大值的静态方法。可以用一行代码完成最大值的更新处理。

```java
int a = 5;
int b = 3;
Math.max(a, b);  // → 返回 5

// 用于更新最大利润
maxProfit = Math.max(maxProfit, profit);  // 如果 profit 更大，则更新 maxProfit
```

### 什么是 Running Minimum（遍历过程中的最小值追踪）

在遍历数组的过程中，用一个变量追踪迄今为止所见元素的最小值的技巧。在每一步中将当前元素与该变量比较，用较小的值更新变量。这样就能以 O(1) 的时间获取任意位置之前的最小值。

```java
int minPrice = Integer.MAX_VALUE;
for (int price : prices) {
    if (price < minPrice) {
        minPrice = price;  // 更新迄今为止的最低价
    }
    // 此时 minPrice 保存的是 prices[0] 到 prices[当前] 中的最小值
}
```

## 复杂度

| | 值 |
|---|---|
| Time | O(n) — 只需遍历数组一次 |
| Space | O(1) — 仅使用两个变量（minPrice、maxProfit） |

## 代码

```java
// 输入：整数数组 prices（每个元素为每天的股价）
// 输出：以 int 返回一次交易能获得的最大利润。无法获得利润时返回 0
public int maxProfit(int[] prices) {
    // 追踪迄今为止最低价的变量。用 Integer.MAX_VALUE 初始化，确保与第一个价格比较时必定会更新为实际股价
    int minPrice = Integer.MAX_VALUE;
    // 追踪迄今为止最大利润的变量。用 0 初始化，确保无法获得利润时自然返回 0
    int maxProfit = 0;

    // 使用 for-each 循环从头到尾逐一遍历数组
    for (int price : prices) {
        if (price < minPrice) {
            // 如果当前价格小于最低价，则更新最低价
            // 该天是最低价的更新日，在该天卖出不会产生利润（利润为负）。因此跳过利润计算
            minPrice = price;
        } else {
            // 计算在最低价那天买入、在今天卖出时的利润
            int profit = price - minPrice;
            // 如果利润超过了迄今为止的最大值，则更新最大利润
            maxProfit = Math.max(maxProfit, profit);
        }
    }
    // 循环结束时的 maxProfit 即为整个数组中的最大利润
    return maxProfit;
}
```
