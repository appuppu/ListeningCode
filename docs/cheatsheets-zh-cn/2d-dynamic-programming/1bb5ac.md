# Maximizing Stock Profit With a Cooldown Period — 带冷却期的股票交易求最大利润

## 问题的本质

给定一个股价数组 `prices`，每个索引表示一天。可以多次买卖股票，但卖出后的第二天是**冷却期**，不能进行交易。在此约束下返回能获得的**最大利润**。

## 核心思路

将每天的状态分为「持有股票（hold）」「刚卖出（sold）」「休息中（rest）」三种，定义从前一天的3种状态到当天3种状态的转移。由于每天仅依赖前一天，因此不需要数组，只用3个变量即可管理状态。

## 思考过程

1. **每天有3种状态**: 某天结束时，自己处于「持有股票（hold）」「当天卖出了（sold）」「什么都没做（rest）」三者之一。这3种状态可以覆盖所有情况
2. **定义状态间的转移**: hold 取「前一天也是 hold 且不操作」与「前一天是 rest 且今天买入」中的较大值。sold 为「前一天是 hold 且今天卖出」。rest 取「前一天也是 rest 且不操作」与「前一天是 sold 且冷却期结束」中的较大值。冷却期的约束通过「sold 的下一天不能转移到 hold」这一规则自然地表达出来
3. **设定初始状态**: 若第0天买入则 hold = -prices[0]（利润为负）。第0天既不能卖出也无法休息，因此 sold = Integer.MIN_VALUE（表示该状态尚未到达），rest = 0（什么都不做则利润为0）
4. **每天仅依赖前一天的状态**: 观察转移式可知，当天的每个状态仅由前一天的3个状态计算得出。即不需要保存所有天数的数组，只需每天更新3个变量即可
5. **需要同时更新**: 当天的 hold、sold、rest 全部由前一天的值计算，因此需要先将新值存入临时变量，再统一覆盖前一天的变量。若逐个覆盖，尚需用于计算的前一天的值会丢失
6. **最终返回什么**: 最后一天仍持有股票不是最优解，因此 prevSold 和 prevRest 中的较大值即为最大利润

## 前置知识

### 什么是状态机（State Machine）

由有限个状态和状态间的转移规则构成的模型。每个时刻必定处于某一个状态，根据输入转移到另一个状态。在本题中，将交易建模为具有 hold / sold / rest 三种状态的状态机。

```
rest ---(买入)---> hold
hold ---(卖出)---> sold
sold ---(等待)---> rest（冷却期）
hold ---(保持)---> hold
rest ---(保持)---> rest
```

### 什么是 Math.max

返回两个整数中较大值的方法。当状态转移有多个选择时，用它来选取利润较大的那个。

```java
Math.max(3, 7);    // → 7（返回较大值）
Math.max(-5, -2);  // → -2（负数也返回较大值）
```

### 什么是 Integer.MIN_VALUE

Java 中 int 类型能取的最小值（-2,147,483,648）。用于表示「该状态尚未到达」。与任何值比较时都不会被 Math.max 选中，因此可以安全地忽略未到达的状态。

```java
int x = Integer.MIN_VALUE;  // 表示尚未到达的状态
Math.max(x, 0);             // → 0（未到达的状态不会被选中）
```

## 复杂度

| | 值 |
|---|---|
| Time | O(n) — 只需遍历数组一次 |
| Space | O(1) — 仅用3个变量管理状态 |

## 代码

```java
// 输入: 整数数组 prices（每个元素为当天的股价）
// 输出: 在冷却期约束下能获得的最大利润，以 int 返回
public int maxProfit(int[] prices) {
    int n = prices.length;
    // 买卖股票至少需要2天。若 n < 2 则无法完成交易，返回 0
    if (n < 2) return 0;

    // 初始化第0天的各状态
    int prevHold = -prices[0];          // 第0天买入时的利润（支出所以为负）
    int prevSold = Integer.MIN_VALUE;   // 第0天不可能卖出（表示未到达）
    int prevRest = 0;                   // 什么都不做则利润为0

    for (int i = 1; i < n; i++) {
        // 由前一天的3种状态计算当天的3种状态
        // newHold: 取「前一天也持有（prevHold）」与「前一天休息且今天买入（prevRest - prices[i]）」中的较大值
        // 注意:「前一天是 sold 且今天买入」不是可选项。这正是冷却期约束的体现
        int newHold = Math.max(prevHold,
            prevRest - prices[i]);

        // newSold: 将持有的股票今天卖出。卖出只能从 hold 转移而来，因此不需要 Math.max
        int newSold = prevHold + prices[i];

        // newRest: 取「前一天也休息（prevRest）」与「前一天卖出后冷却期结束（prevSold）」中的较大值
        int newRest = Math.max(prevRest,
            prevSold);

        // 全部计算完成后统一更新
        // 为了不在计算过程中覆盖前一天的值，先求出3个新值再一起赋值
        prevHold = newHold;
        prevSold = newSold;
        prevRest = newRest;
    }
    // 最后一天仍持有股票（prevHold）意味着利润未确定，不是最优解
    // sold 和 rest 中的较大值即为最大利润
    return Math.max(prevSold, prevRest);
}
```
