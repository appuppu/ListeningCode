# Dividing Cards Into Consecutive Groups — 判定能否将卡牌分割为指定大小的连续组

## 问题的本质

给定一个整数数组 `hand`（卡牌的值）和一个整数 `groupSize`。返回一个 `boolean` 值，表示能否将所有卡牌分割为若干组，使得每组恰好包含 `groupSize` 张**连续值**的卡牌。所有卡牌必须不多不少地全部使用。

## 核心思路

如果从最小的值开始贪心地处理卡牌，那么每张卡牌所属的组是唯一确定的。从最小的卡牌开始构建连续组，移除已使用的卡牌，重复此过程，如果能用完所有卡牌，则分割是可行的。

## 思考过程

1. **确认前提条件**：由于需要将卡牌分成每组 `groupSize` 张的若干组，如果卡牌总数不能被 `groupSize` 整除，则分割不可能。首先进行此判定可以避免不必要的处理
2. **应从最小的卡牌开始处理的原因**：最小的卡牌只能属于以自身为起始的连续组。例如，如果最小值为3且 `groupSize` 为3，则该卡牌必定属于 [3, 4, 5] 这个组。因此，从最小值开始贪心处理的策略是正确的
3. **需要管理每张卡牌的出现次数**：由于同一值的卡牌可能有多张，需要一个数据结构来记录每个值的出现次数（频率）。此外，为了高效地获取最小值，键按排序顺序维护的TreeMap是合适的选择
4. **构建组的步骤**：从TreeMap中获取最小键 `first`，确认从 `first` 到 `first + groupSize - 1` 的所有连续值是否都存在于TreeMap中。如果存在，则将每个值的频率减1，当频率变为0时，从TreeMap中删除该值
5. **连续值不足的情况**：在构建组的过程中，如果所需的值在TreeMap中不存在，则在该时刻判定为不可分割，返回 `false`
6. **处理完所有卡牌则成功**：重复构建组直到TreeMap为空，如果全部成功则返回 `true`

## 前置知识

### 什么是TreeMap

TreeMap是一种键始终按排序顺序维护的Map数据结构。与HashMap一样可以保存键值对，但基于键的顺序的操作（如获取最小键）可以在O(log n)时间内完成。内部使用红黑树（自平衡二叉搜索树）实现。

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();  // 创建一个空的TreeMap
tm.put(5, 2);           // 将值2存储到键5中
tm.put(3, 1);           // 将值1存储到键3中
tm.firstKey();           // 返回最小的键 → 3
tm.containsKey(5);       // 返回键5是否存在的boolean值 → true
tm.get(5);               // 返回键5对应的值 → 2
tm.remove(3);            // 删除键3及其对应的值
```

### 什么是getOrDefault

getOrDefault是从Map中获取值时，如果键不存在则返回指定默认值的方法。在频率计数中可以省略 `null` 检查。

```java
TreeMap<Integer, Integer> tm = new TreeMap<>();
tm.getOrDefault(10, 0);  // 键10不存在，因此返回默认值0 → 0
tm.put(10, 3);
tm.getOrDefault(10, 0);  // 键10存在，因此返回其对应的值 → 3
```

### 什么是贪心法（Greedy）

贪心法是在每一步选择局部最优解，从而求得全局最优解的方法。在本问题中，"从最小的卡牌开始依次构建组"这一贪心选择能导出全局正确的分割。由于最小的卡牌不可能插入到其他组的中间位置，因此贪心选择与最优解一致。

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n log n) — 向TreeMap的插入和删除各为O(log n)，共处理n张卡牌 |
| Space | O(n) — TreeMap中最多保存n个条目 |

## 代码

```java
// 输入：整数数组 hand（卡牌的值）和整数 groupSize（每组的大小）
// 输出：如果能将所有卡牌分割为连续值的组则返回 true，否则返回 false
public boolean isNStraightHand(int[] hand, int groupSize) {
    // 如果卡牌总数不能被组大小整除，则无法均等分组
    if (hand.length % groupSize != 0)
        return false;

    // 键=卡牌的值，值=剩余张数（频率），保存到TreeMap中
    // 使用TreeMap的原因：可以在O(log n)时间内获取最小的卡牌值
    TreeMap<Integer, Integer> tm = new TreeMap<>();
    // 统计每张卡牌的出现次数，使用getOrDefault将已有频率加1
    for (int card : hand) {
        tm.put(card, tm.getOrDefault(card, 0) + 1);
    }

    // 重复构建组直到TreeMap为空（为空则意味着所有卡牌都已成功分割）
    while (!tm.isEmpty()) {
        // 获取当前最小的卡牌值，将其作为组的起始值
        // 最小值不可能插入到其他组的中间位置，因此它必定成为新组的起始值
        int first = tm.firstKey();

        // 从first开始用groupSize个连续值构建一个组
        for (int i = 0; i < groupSize; i++) {
            int cur = first + i;

            // 如果连续值不存在，则无法构成组，分割不可能
            if (!tm.containsKey(cur))
                return false;

            // 如果频率为1，则该卡牌是最后一张，将其删除；如果为2以上，则将频率减1
            if (tm.get(cur) == 1) {
                tm.remove(cur);
            } else {
                tm.put(cur, tm.get(cur) - 1);
            }
        }
    }

    // 所有卡牌都已成功分割为连续组
    return true;
}
```
