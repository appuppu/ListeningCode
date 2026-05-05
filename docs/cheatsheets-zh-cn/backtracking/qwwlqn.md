# Finding Combinations That Sum to a Target Without Reuse — 从含重复元素的数组中找出所有求和等于目标值的唯一组合

## 问题本质

给定一个整数数组 `candidates`（可能包含重复元素）和一个整数 `target`。从数组中找出所有求和等于 `target` 的数值组合。每个数值在组合中**只能使用一次**，结果中**不能包含重复的组合**。

## 核心思想

通过对数组排序，使相同值的元素相邻，从而在递归的同一层中利用条件 `i > start && cands[i] == cands[i-1]` 跳过重复元素。这样可以从根本上防止生成重复的组合，同时不遗漏地探索所有唯一的组合。

## 思考过程

1. **需要列举所有组合**：问题要求"所有满足条件的组合"，因此需要探索整个解空间，而不是寻找一个最优解。这类"全列举"问题适合使用回溯法
2. **对每个元素进行"使用/不使用"的分支选择**：对数组中的每个元素递归地选择"是否将其加入当前组合"。为了保证每个元素只使用一次，在递归调用时将起始索引推进到 `i + 1`
3. **需要排除重复的组合**：当数组中存在重复元素时，选择不同索引处的相同值会生成相同的组合。例如在 `[1,1,2]` 且 target=3 时，第1个1与2的组合和第2个1与2的组合都会生成相同的 `[1,2]`
4. **排序后跳过重复元素**：对数组排序后，相同的值会相邻。在递归的同一层（同一个for循环内），跳过与前一个值相同的元素，即可防止生成重复的组合。跳过条件为 `i > start && cands[i] == cands[i-1]`。`i > start` 条件允许使用第一个元素，同时跳过第二个及之后的相同值
5. **通过剪枝提高探索效率**：由于数组已排序，当当前元素超过剩余合计 `remain` 时，之后的所有元素也必然超过。通过 `if (cands[i] > remain) break` 终止循环，可以省略不必要的探索
6. **基准情形的判定**：当 `remain` 为0时，意味着当前 `path` 中元素的合计恰好等于 `target`，因此将 `path` 的副本添加到结果列表中

## 前置知识

### 什么是回溯法

回溯法是一种逐步构建候选解，当判定不满足条件时回退到上一个状态（回溯）并尝试其他候选解的搜索方法。通过"选择→递归→撤销选择"的模式来实现。

```java
path.add(element);          // 选择: 将元素添加到组合中
backtrack(next_state);      // 递归: 对下一个元素继续探索
path.remove(path.size()-1); // 撤销: 将元素从组合中移除，恢复到原始状态
```

### 什么是 Arrays.sort

Arrays.sort 是Java的标准方法，用于将数组按升序排序。排序后相同值的元素会相邻，从而便于检测和跳过重复元素。

```java
int[] arr = {2, 1, 2, 3};
Arrays.sort(arr);           // arr 变为 {1, 2, 2, 3}
```

### ArrayList 的拷贝构造函数

`new ArrayList<>(path)` 会创建一个复制了 `path` 内容的新列表。在回溯法中，由于 `path` 在递归过程中不断变化，因此在将其添加到结果中时需要创建副本。

```java
List<Integer> path = new ArrayList<>(Arrays.asList(1, 2));
List<Integer> copy = new ArrayList<>(path);  // 创建 [1, 2] 的副本
path.add(3);        // path 变为 [1, 2, 3]
// copy 仍然保持 [1, 2] 不变
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(2^n) — 由于每个元素都有"使用/不使用"两种选择，最坏情况下需要探索 2^n 种组合 |
| Space | O(n) — 递归深度最大为 n，path 最多也保存 n 个元素 |

## 代码

```java
// 输入: 整数数组 candidates（可能包含重复元素）和整数 target
// 输出: 返回包含所有求和等于 target 的唯一组合的 List<List<Integer>>
private void backtrack(int[] cands, int start, int remain,
        List<Integer> path, List<List<Integer>> result) {
    // 当 remain 为0时，表示发现了 path 的合计恰好等于 target 的组合
    if (remain == 0) {
        // 由于 path 在后续递归中会持续变化，因此创建副本后添加到结果中
        result.add(new ArrayList<>(path));
        return;
    }

    // 从 start 开始，防止重新选择已经使用过的元素（start 之前的元素）
    for (int i = start; i < cands.length; i++) {
        // 在同一递归层中，如果是第二个及之后的元素且与前一个值相同，则跳过以防止重复组合
        // i > start 表示"不是同一递归层中的第一个元素"
        if (i > start && cands[i] == cands[i - 1]) continue;

        // 由于数组已排序，当前值超过 remain 时，之后的元素也全部超过（剪枝）
        if (cands[i] > remain) break;

        path.add(cands[i]);                  // 选择: 将元素添加到组合中
        backtrack(cands, i + 1,              // 递归: 将索引设为 i+1 以防止同一元素被使用两次
            remain - cands[i], path, result); // 从 remain 中减去当前元素以更新剩余合计
        path.remove(path.size() - 1);        // 撤销: 移除元素并恢复状态以尝试其他元素
    }
}

public List<List<Integer>> combinationSum2(
        int[] candidates, int target) {
    // 通过排序使相同值的重复元素相邻，从而使跳过条件的判定成为可能
    Arrays.sort(candidates);
    // 创建存储结果的列表和记录当前组合的空 path
    List<List<Integer>> result = new ArrayList<>();
    // 从索引0和剩余合计 target 开始递归探索
    backtrack(candidates, 0, target, new ArrayList<>(), result);
    // 在所有递归完成后，返回存储的所有唯一组合
    return result;
}
```
