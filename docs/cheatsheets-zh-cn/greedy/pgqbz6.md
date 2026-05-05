# Merging Triplets to Form a Target Triplet — 判断能否通过三元组的逐元素最大值构成目标三元组

## 问题的本质

给定一个由三个整数组成的三元组二维数组 `triplets` 和一个目标三元组 `target`。从 `triplets` 中选择任意子集，取逐元素最大值（element-wise maximum），判断其结果是否与 `target` 完全一致，并返回 **boolean**。

## 核心思路

如果某个三元组的任意一个元素超过了目标的对应元素，那么将该三元组纳入合并后，该位置的值就会超过目标，因此绝对不能使用。反之，只合并所有元素都不超过目标的三元组，就无需担心超过目标，只需不断累积最大值，最终确认结果是否与目标一致即可。

## 思考过程

1. **识别不可用的三元组**：如果三元组 `t` 的任意一个元素超过了 `target` 的对应元素，将 `t` 纳入合并会导致最大值超过目标。由于最大值一旦增大就无法降低，这样的三元组绝对不能选择
2. **所有可用的三元组都可以使用**：所有元素都不超过 `target` 的三元组，即使纳入合并也不会超过目标。使用它们不会产生负面影响，因此可以贪心地全部采用
3. **如何累积合并结果**：用 `[0, 0, 0]` 初始化结果数组 `result`，对每个可用三元组的各元素与 `result` 的各元素取最大值并更新。通过 `Math.max` 逐元素更新，即可得到所有选中三元组的 element-wise maximum
4. **最终判定**：处理完所有三元组后，如果 `result` 与 `target` 完全一致则返回 `true`，否则返回 `false`。可以使用 `Arrays.equals` 来比较数组的所有元素

## 前置知识

### 什么是 element-wise maximum（逐元素最大值）

对两个或多个数组中相同位置的元素进行比较，取每个位置上的最大值的操作。例如 `[2, 5, 3]` 和 `[5, 1, 6]` 的 element-wise maximum 为 `[5, 5, 6]`。

```java
int[] a = {2, 5, 3};
int[] b = {5, 1, 6};
int[] merged = new int[3];
merged[0] = Math.max(a[0], b[0]);  // max(2, 5) → 5
merged[1] = Math.max(a[1], b[1]);  // max(5, 1) → 5
merged[2] = Math.max(a[2], b[2]);  // max(3, 6) → 6
// merged = [5, 5, 6]
```

### 什么是 Math.max

返回两个值中较大值的方法。用于累积合并结果。

```java
Math.max(3, 7);   // → 7
Math.max(5, 5);   // → 5
Math.max(0, 4);   // → 4（用于与初始值0比较并更新）
```

### 什么是 Arrays.equals

判断两个数组的长度和所有元素是否一致，并返回 boolean 的方法。由于 `==` 运算符比较的是引用，要比较数组的内容需要使用该方法。

```java
int[] a = {2, 5, 3};
int[] b = {2, 5, 3};
a == b;              // → false（因为引用不同）
Arrays.equals(a, b); // → true（因为所有元素一致）
```

## 复杂度

| | 值 |
|---|---|
| Time | O(n) — 只需遍历三元组数组一次（每个三元组的处理为 O(1)） |
| Space | O(1) — 仅使用长度为3的固定大小数组 `result` |

## 代码

```java
// 输入：二维整数数组 triplets（每个元素是长度为3的三元组）和长度为3的整数数组 target
// 输出：如果能通过三元组子集的 element-wise maximum 构成 target 则返回 true，否则返回 false
public boolean mergeTriplets(int[][] triplets, int[] target) {
    // 用 [0, 0, 0] 初始化用于累积可用三元组的 element-wise maximum 的数组
    int[] result = new int[3];

    // 从头到尾逐个遍历 triplets 中的每个三元组 t
    for (int[] t : triplets) {
        // 如果任意一个元素超过目标，将该三元组纳入合并会导致最大值超过目标且无法修正，因此跳过
        if (t[0] > target[0] ||
            t[1] > target[1] ||
            t[2] > target[2])
            continue;

        // 所有元素都不超过目标，因此此次更新不会导致 result 超过目标
        // 用各元素的最大值更新结果
        result[0] = Math.max(result[0], t[0]);
        result[1] = Math.max(result[1], t[1]);
        result[2] = Math.max(result[2], t[2]);
    }

    // 判断累积的结果是否与目标完全一致并返回
    return Arrays.equals(result, target);
}
```
