# Counting Ways to Assign Signs to Reach a Target Sum — 计算通过分配符号达到目标总和的方法数

## 问题的本质

给定一个整数数组 `nums` 和一个整数 `target`。对 `nums` 的每个元素分配 `+` 或 `-` 符号，返回使所有元素之和等于 `target` 的组合数。

## 核心思路

将每个元素分配 `+` 或 `-` 的问题，等价于将数组划分为"正符号组（P）"和"负符号组（N）"的问题。由 P - N = target 且 P + N = totalSum 可推导出 P = (target + totalSum) / 2，因此问题可以转化为"计算总和为 P 的子集个数"的子集和问题。

## 思考过程

1. **将符号分配视为集合的划分**: 将分配 `+` 的元素之和设为 P，分配 `-` 的元素之和设为 N，则 P - N = target 成立。同时 P + N = totalSum（所有元素之和）也成立。联立这两个方程可得 P = (target + totalSum) / 2
2. **先排除无解的条件**: 当 P = (target + totalSum) / 2 不是整数时（即 `(target + totalSum)` 为奇数时），不存在有效的划分。当 `|target|` 超过 `totalSum` 时也不存在解。首先检查这些条件并返回 0
3. **用DP作为子集和问题求解**: "从数组 `nums` 中选择元素使总和为 `subsetSum`（= P）的组合数"是典型的子集和计数问题。定义DP数组 `dp[j]` 为"总和为 j 的子集个数"，然后针对每个元素进行更新
4. **用一维DP数组优化空间**: 不使用二维表，而是准备一维数组 `dp[0..subsetSum]`，针对每个元素 `num`，将 `j` 从 `subsetSum` 到 `num` 逆序遍历，执行 `dp[j] += dp[j - num]` 更新。逆序遍历的原因是防止同一元素被多次使用
5. **设定初始条件**: 设置 `dp[0] = 1`。这表示"不选择任何元素使总和为 0 的方法有 1 种"
6. **最终返回值**: 处理完所有元素后的 `dp[subsetSum]` 即为总和为 `subsetSum` 的子集个数，也就是原问题的答案

## 前置知识

### 子集和问题（Subset Sum Problem）

从给定集合中选择元素，求其总和等于特定值的组合。子集和问题是背包问题的一种，可以用DP高效求解。

### 一维DP数组的子集和计数

`dp[j]` 表示"总和为 j 的子集个数"。针对每个元素 `num`，通过 `dp[j] += dp[j - num]` 进行更新。

```java
int[] dp = new int[targetSum + 1]; // dp[j] = 总和为j的组合数
dp[0] = 1;                         // 构成总和0的方法有1种（不选择任何元素）
dp[j] += dp[j - num];              // 使用num构成j = 加上不使用num构成j-num的方法数
```

### 逆序循环的原因

内层循环从 `subsetSum` 到 `num` 逆序遍历。如果正序遍历，同一元素 `num` 会在同一次迭代中被多次累加。通过逆序遍历，可以满足每个元素"选或不选"的0-1背包约束。

```java
// 逆序循环: 每个元素最多使用一次（0-1背包）
for (int j = subsetSum; j >= num; j--) {
    dp[j] += dp[j - num];
}
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n × subsetSum) — 针对每个元素遍历DP数组一次 |
| Space | O(subsetSum) — 仅使用一维DP数组 |

## 代码

```java
// 输入: 整数数组 nums 和整数 target
// 输出: 对每个元素分配 +/- 使总和为 target 的组合数，以 int 类型返回
public int findTargetSumWays(int[] nums, int target) {
    // 计算数组 nums 所有元素的总和，并赋值给变量 totalSum
    int totalSum = 0;
    for (int num : nums) {
        totalSum += num;
    }

    // 检查无解条件
    // 当 (target + totalSum) 为奇数时，P = (target + totalSum) / 2 不是整数，
    // 由整数个元素构成的子集无法达到该值，因此返回 0
    // 当 |target| 超过 totalSum 时，无论如何分配符号都无法达到 target，因此返回 0
    if ((target + totalSum) % 2 != 0
        || Math.abs(target) > totalSum)
        return 0;

    // 求正符号组的总和值。该值作为后续处理中需要达到的目标
    int subsetSum = (target + totalSum) / 2;

    // dp[j] = 从 nums 的元素中选择使总和为 j 的组合数
    int[] dp = new int[subsetSum + 1];
    // 基础情况: 不选择任何元素使总和为 0 的方法有 1 种
    dp[0] = 1;

    // 外层循环: 从头到尾依次遍历数组 nums 的每个元素
    for (int num : nums) {
        // 内层循环: 从 subsetSum 到 num 逆序遍历
        // 逆序的原因: 防止同一 num 在同一次迭代中被多次使用（0-1背包约束）
        for (int j = subsetSum; j >= num; j--) {
            // 将不使用 num 构成总和 j - num 的方法数，加到使用 num 构成总和 j 的方法数上
            dp[j] += dp[j - num];
        }
    }

    // dp[subsetSum] 是总和为 subsetSum 的子集个数，即原问题中符号分配方式的总数
    return dp[subsetSum];
}
```
