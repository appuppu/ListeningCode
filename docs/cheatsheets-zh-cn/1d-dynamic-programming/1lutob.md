# Determining if a String Can Be Segmented Into Dictionary Words — 判断字符串能否被分割为字典中的单词

## 问题的本质

给定一个字符串 `s` 和一个字典单词列表 `wordDict`。判断 `s` 是否可以被分割为字典中单词的连接形式，并返回 **boolean** 值。字典中的每个单词可以重复使用任意次数。

## 核心思路

如果从字符串的开头逐步记录到每个位置 `i` 的子字符串"是否可以被分割"，那么位置 `i` 的判断就可以归结为：是否存在某个分割点 `j`，使得"到 `j` 为止的部分可以被分割"，并且"从 `j` 到 `i` 的子字符串存在于字典中"。

## 思考过程

1. **可以分解为子问题**：要判断字符串 `s` 的前 `i` 个字符是否可以被分割，只需在某个位置 `j` 将其一分为二，满足"前 `j` 个字符可以被分割"且"从 `j` 到 `i` 的部分是字典中的单词"即可。这种结构适合使用动态规划
2. **确定DP的定义**：将 `dp[i]` 定义为一个boolean值，表示"字符串 `s` 的前 `i` 个字符是否可以仅用字典中的单词来分割"。最终 `dp[n]`（`n` 为字符串的长度）就是答案
3. **设定基础条件**：空字符串始终可以被分割，因此设定 `dp[0] = true`。有了这个基础条件，才能检测到从字符串开头开始的字典单词
4. **思考状态转移方程**：`dp[i]` 为 `true` 的条件是，在 `0 ≤ j < i` 的某个 `j` 上，同时满足"`dp[j]` 为 `true`"且"`s.substring(j, i)` 存在于字典中"。遍历所有的 `j` 即可完成判断
5. **加速字典查找**：将单词列表预先转换为HashSet，就可以用 `contains` 在O(1)时间内判断子字符串是否包含在字典中。这比在列表中进行线性搜索更高效
6. **通过提前终止减少无用计算**：一旦某个 `j` 使 `dp[i] = true` 成立，就不需要再尝试其他的 `j`。用 `break` 跳出内层循环，进入下一个 `i` 的处理

## 前置知识

### 什么是HashSet

HashSet是一种保存不重复元素的数据结构。判断某个元素是否包含在其中的时间复杂度为O(1)。用于对字典单词列表进行高速查找。

```java
Set<String> set = new HashSet<>();       // 创建一个空的HashSet
set.add("apple");                        // 添加元素
set.contains("apple");                   // 以boolean值返回元素是否存在 → true
```

### 通过构造函数将List转换为Set

将List传入 `HashSet` 的构造函数，可以将List的所有元素转换为Set。用于一行代码将字典转换为HashSet。

```java
List<String> list = Arrays.asList("a", "b", "c");
Set<String> set = new HashSet<>(list);   // 将List的所有元素转换为Set
```

### 什么是substring

substring是截取字符串一部分的方法。`s.substring(j, i)` 返回从索引 `j` 到 `i - 1` 的字符。在DP的状态转移中，用于获取"从位置 `j` 到位置 `i` 的子字符串"。

```java
String s = "leetcode";
s.substring(0, 4);                       // 返回 "leet"（索引0〜3）
s.substring(4, 8);                       // 返回 "code"（索引4〜7）
```

### 什么是DP数组（boolean数组）

DP数组是在动态规划中保存子问题结果的数组。通过 `boolean[] dp = new boolean[n + 1]` 创建时，所有元素会被初始化为 `false`。通过将 `dp[i]` 赋值为 `true`，来记录"前 `i` 个字符可以被分割"这一结果。

```java
boolean[] dp = new boolean[5];           // 初始化为 [false, false, false, false, false]
dp[0] = true;                           // 设定基础条件
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n^2) — 外层循环执行n次，内层循环最多执行n次，如果每步生成substring需要O(n)，严格来说是O(n^3)，但平均情况下按O(n^2)处理 |
| Space | O(n) — 大小为n+1的DP数组，以及将字典单词保存到HashSet中 |

## 代码

```java
// 输入: 字符串 s 和字典单词列表 wordDict
// 输出: 如果 s 可以仅用字典中的单词来分割则返回 true，否则返回 false
public boolean wordBreak(String s, List<String> wordDict) {
    // 将字典单词列表转换为HashSet，使查找时间复杂度为O(1)
    Set<String> set = new HashSet<>(wordDict);
    // 将字符串的长度保存到变量中
    int n = s.length();

    // dp[i] = 前i个字符是否可以仅用字典中的单词来分割
    // 大小为n+1是因为dp[n]表示整个字符串的可分割性
    boolean[] dp = new boolean[n + 1];

    // 空字符串始终可以被分割（基础条件）
    // 如果没有这个设定，就无法检测到从字符串开头开始的字典单词
    dp[0] = true;

    // 外层循环: i表示"考虑前多少个字符"
    for (int i = 1; i <= n; i++) {
        // 内层循环: j是分割点的候选位置。表示将字符串分为"前j个字符"和"从j到i的子字符串"的位置
        for (int j = 0; j < i; j++) {
            // 如果前j个字符可以被分割，且从j到i的部分是字典中的单词，则前i个字符可以被分割
            // 两个条件同时成立 = 可以分为"可分割的部分 + 字典中的单词"
            if (dp[j] && set.contains(s.substring(j, i))) {
                dp[i] = true;
                break;  // 已确认可以分割，无需再尝试其他的j
            }
        }
    }

    // dp[n]表示整个字符串s是否可以被分割
    return dp[n];
}
```
