# Generating All Unique Subsets With Duplicates — 从包含重复元素的数组中生成所有唯一子集

## 问题的本质

给定一个可能包含重复值的整数数组 `nums`。返回所有可能的唯一子集。结果中不能包含重复的子集，每个子集中元素的顺序可以是任意的。

## 核心思想

如果预先对数组进行排序，那么只需在同一递归层级中跳过与前一个元素值相同的元素，就能从根本上防止生成重复的子集。

## 思考过程

1. **子集生成是回溯法的经典问题**: 对每个元素递归地决定"选择还是不选择"，就能枚举所有子集。在递归的每个阶段将当前子集直接添加到结果中，就能获得所有子集
2. **确定重复的原因**: 当数组中存在多个相同值时，例如 `[1,2,2]` 中选择第1个2和选择第2个2会生成相同的子集。重复发生在"同一递归层级中多次选择相同值"的时候
3. **通过排序使重复元素相邻**: 对数组排序后，相同值的元素会彼此相邻。这样就可以通过简单的比较来判定"是否与前一个元素的值相同"
4. **跳过同一递归层级中的重复**: 在for循环中，当满足 `i > start && nums[i] == nums[i-1]` 条件时，跳过该元素。`i > start` 条件表示"同一递归层级中第二个及之后的选项"，这样在不同递归层级中仍然可以选择相同的值（允许子集中包含多个相同的值）
5. **在递归的每个阶段添加到结果中**: 在递归函数的开头将当前子集 `curr` 添加到结果列表中。这样从空集到包含所有元素的集合，所有子集都会包含在结果中
6. **通过回溯恢复原始状态**: 在递归调用之后删除 `curr` 的末尾元素以恢复原始状态，从而正确地探索下一个选项

## 前置知识

### 什么是回溯法

回溯法是一种递归地构建候选解，当不满足条件时撤销上一步的选择并尝试其他选择的搜索方法。常用于枚举子集、排列和组合。

```java
// 回溯法的基本结构
void backtrack(状态, 选项列表) {
    将当前状态添加到结果中;
    for (每个选项) {
        应用选择;
        backtrack(下一个状态, 剩余选项);
        撤销选择;  // ← 回溯
    }
}
```

### 什么是 Arrays.sort

Arrays.sort 是将数组按升序排序的方法。通过使重复元素相邻，便于进行重复判定。

```java
int[] nums = {4, 1, 4, 2};
Arrays.sort(nums);  // nums 变为 {1, 2, 4, 4}
```

### 关于 ArrayList 的复制

`new ArrayList<>(list)` 会创建现有列表的浅拷贝。在将子集添加到结果中时，如果添加的是引用而不是拷贝，后续的回溯操作会修改其内容。

```java
List<Integer> curr = new ArrayList<>();
curr.add(1);
curr.add(2);
List<Integer> copy = new ArrayList<>(curr);  // 创建 [1, 2] 的拷贝
curr.remove(curr.size() - 1);               // curr 恢复为 [1]，但 copy 仍然是 [1, 2]
```

### 删除 List 的末尾元素

`list.remove(list.size() - 1)` 用于删除列表的末尾元素。在回溯法中用于撤销上一步添加的元素。

```java
List<Integer> curr = new ArrayList<>();
curr.add(5);        // curr = [5]
curr.add(3);        // curr = [5, 3]
curr.remove(curr.size() - 1);  // curr 恢复为 [5]
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n × 2^n) — 最多存在 2^n 个子集，复制每个子集最多需要 O(n) |
| Space | O(n) — 递归深度最大为 n，工作列表 `curr` 的长度也最大为 n（不包含结果列表） |

## 代码

```java
// 输入: 可能包含重复元素的整数数组 nums
// 输出: 返回包含所有唯一子集的 List<List<Integer>>
void backtrack(int[] nums, int start, List<Integer> curr, List<List<Integer>> result) {
    // 将当前子集的拷贝添加到结果中
    // 使用 new ArrayList<>(curr) 创建拷贝的原因: curr 在后续递归中内容会发生变化，因此需要保存当前时刻的状态而非引用
    result.add(new ArrayList<>(curr));

    // 从 start 开始遍历，不选择自身之前的元素，从而保持子集中元素的顺序
    for (int i = start; i < nums.length; i++) {
        // 在同一递归层级中，如果与前一个元素的值相同则跳过，以防止重复
        // i > start: 不是该层级的第一个选项（在不同层级中可以选择相同的值）
        // nums[i] == nums[i-1]: 与前一个元素的值相同
        // 当这两个条件同时成立时，意味着在同一层级中两次选择了相同的值，从而产生重复子集
        if (i > start && nums[i] == nums[i - 1]) continue;

        // 将当前元素添加到子集中，然后进入下一层级
        curr.add(nums[i]);
        // 传入 i + 1，使下一递归层级只能选择当前元素之后的元素
        backtrack(nums, i + 1, curr, result);

        // 回溯: 删除末尾元素以恢复原始状态，使下一次迭代能够选择其他元素
        curr.remove(curr.size() - 1);
    }
}

public List<List<Integer>> subsetsWithDup(int[] nums) {
    // 排序使相同值的元素相邻。这样就可以通过 nums[i] == nums[i-1] 的简单比较来进行重复判定
    Arrays.sort(nums);
    List<List<Integer>> result = new ArrayList<>();
    // 0 表示"从数组的开头开始探索"
    backtrack(nums, 0, new ArrayList<>(), result);
    // 所有递归完成后，result 中存储了所有唯一子集
    return result;
}
```
