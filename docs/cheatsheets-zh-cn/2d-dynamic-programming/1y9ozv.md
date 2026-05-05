# Maximizing Coins From Bursting Balloons — 优化气球爆破顺序以最大化硬币数量

## 问题的本质

给定一个整数数组 `nums`（每个元素代表一个气球的值）。当爆破气球 `i` 时，可以获得 `nums[left] * nums[i] * nums[right]`（left 和 right 是相邻的剩余气球）枚硬币。要求返回爆破所有气球后能获得的最大硬币数量。数组边界外的值视为 `1`。

## 核心思路

不是思考"按什么顺序爆破气球"，而是反向思考：在区间 `[left, right]` 中"哪个气球**最后**被爆破"。一旦固定最后爆破的气球 `k`，左右两个子区间就变得相互独立，可以通过区间DP来合成最优解。

## 思考过程

1. **需要消除爆破顺序的依赖关系**：爆破气球会改变相邻关系，因此不同的爆破顺序会产生不同的硬币数量。穷举所有顺序需要 `n!` 种排列，不切实际。需要找到一种打破这种依赖关系的视角
2. **以"最后爆破"的角度思考可以使区间独立**：在区间 `[left, right]` 中，假设气球 `k` 是最后被爆破的，那么在爆破 `k` 时，`[left, k-1]` 和 `[k+1, right]` 的气球已经全部被爆破。也就是说，`k` 的相邻气球固定为区间外侧的 `arr[left-1]` 和 `arr[right+1]`。左右子问题变得独立，因此可以用DP来合成
3. **简化边界处理**：在原数组的两端各添加一个值为 `1` 的虚拟气球，构成新数组 `arr`。设 `arr[0] = 1`、`arr[n+1] = 1`，这样就无需对边界条件进行特殊处理，可以统一使用 `arr[left-1] * arr[k] * arr[right+1]` 这个公式
4. **DP表的定义**：将 `dp[left][right]` 定义为"爆破区间 `[left, right]` 内所有气球所能获得的最大硬币数量"。最终答案为 `dp[1][n]`（对应原数组的整个区间）
5. **从短区间开始填表**：从长度为1的区间（只有一个气球）开始，依次填充到长度为 `n` 的区间。较长区间的值依赖于较短区间的值，因此从短区间开始计算可以保证引用的值总是已经计算过的
6. **对每个区间穷举最后爆破的气球**：对于区间 `[left, right]`，尝试将每个气球 `k`（从 `left` 到 `right`）作为最后爆破的气球。最后爆破 `k` 时获得的硬币为 `arr[left-1] * arr[k] * arr[right+1] + dp[left][k-1] + dp[k+1][right]`，将该最大值记录到 `dp[left][right]` 中

## 前置知识

### 区间DP（Interval DP）

区间DP是一种以区间 `[left, right]` 为单位构建DP表的方法。通过分割区间，将子区间的最优解组合起来求得整体的最优解。计算顺序是从短区间到长区间，自底向上进行。

```java
// 区间DP的基本结构：按区间长度从短到长的顺序计算
for (int len = 1; len <= n; len++) {        // 区间长度
    for (int left = 1; left <= n - len + 1; left++) {  // 区间左端
        int right = left + len - 1;          // 区间右端
        // 计算 dp[left][right]
    }
}
```

### 哨兵（Sentinel）

哨兵是在数组两端添加虚拟元素，从而消除边界条件特殊处理的技巧。在本问题中，将值为 `1` 的气球放置在两端。

```java
int[] arr = new int[n + 2];   // 创建比原数组大2的数组
arr[0] = 1;                   // 左端哨兵（值为1）
arr[n + 1] = 1;               // 右端哨兵（值为1）
for (int i = 0; i < n; i++)
    arr[i + 1] = nums[i];     // 将原数组元素复制到索引1至n的位置
```

### 二维数组的DP表

用 `dp[i][j]` 记录区间 `[i, j]` 的最优解。在Java中，通过 `new int[n+2][n+2]` 创建数组时，所有元素会被初始化为 `0`。空区间（`left > right`）的值保持为 `0` 即可，因此不需要额外的初始化处理。

```java
int[][] dp = new int[n + 2][n + 2];  // 所有元素被初始化为0
dp[left][right];                      // 存储区间[left, right]的最大硬币数量
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n³) — 区间左端、右端、最后爆破位置的三重循环 |
| Space | O(n²) — 使用DP表 `dp[n+2][n+2]` |

## 代码

```java
// 输入：整数数组 nums（每个气球的值）
// 输出：以 int 类型返回爆破所有气球后能获得的最大硬币数量
public int maxCoins(int[] nums) {
    int n = nums.length;

    // 创建在两端添加了哨兵（值为1）的数组
    // 通过哨兵，在引用区间外侧时无需对边界条件进行特殊处理
    int[] arr = new int[n + 2];
    arr[0] = arr[n + 1] = 1;
    for (int i = 0; i < n; i++)
        arr[i + 1] = nums[i];

    // dp[left][right] = 爆破区间[left, right]内所有气球后能获得的最大硬币数量
    // 数组大小设为n+2是为了包含哨兵的索引（0和n+1）
    // 空区间（left > right）的值保持为0即可
    int[][] dp = new int[n + 2][n + 2];

    // 按区间长度从短到长的顺序计算
    // 从短区间开始计算，可以保证在计算长区间时所需的子区间值总是已经计算完毕
    for (int len = 1; len <= n; len++) {
        // 遍历所有长度为len的区间
        for (int left = 1; left <= n - len + 1; left++) {
            int right = left + len - 1;

            // 穷举区间[left, right]中最后爆破的气球k
            for (int k = left; k <= right; k++) {
                // 确定k为最后爆破时，k的相邻气球固定为区间外的arr[left-1]和arr[right+1]
                int coins = arr[left - 1] * arr[k] * arr[right + 1];
                // 加上左右子区间的硬币数量，求得总和
                int total = coins + dp[left][k - 1] + dp[k + 1][right];
                // 用最大值更新dp[left][right]
                dp[left][right] = Math.max(dp[left][right], total);
            }
        }
    }

    // 返回对应原数组整体（索引1至n）的最大硬币数量
    return dp[1][n];
}
```
