# Two Sum — 找出两个数之和等于目标值的数对

## 问题的本质

给定一个整数数组 `nums` 和一个整数 `target`。从 `nums` 中找出两个元素，使它们的和等于 `target`，并以数组形式返回这两个元素的**索引**。题目保证解唯一存在，且同一个元素不能使用两次。

## 核心思路

遍历数组时，对于每个元素 `nums[i]`，其"配对元素（target - nums[i]）"是唯一确定的。如果将之前遍历过的元素记录在HashMap中，就可以用O(1)的时间确认配对元素是否存在，从而只需一次遍历即可找到答案。

## 思考过程

1. **配对元素可以通过计算得出**: 因为要找和等于 `target` 的数对，所以对于当前元素 `nums[i]`，另一个值 `complement = target - nums[i]` 是唯一确定的
2. **需要快速判断配对元素是否已经出现过**: 在遍历数组的过程中，将之前遇到的数值记录下来，就可以用O(1)的时间判断complement是否已被记录。HashMap适合用于这种记录
3. **HashMap中保存什么**: 因为题目要求返回索引，所以HashMap的键存储"数值"，值存储"该数值的索引"。这样就可以同时完成配对元素的存在性检查和索引获取
4. **边遍历边构建HashMap**: 从数组头部开始依次遍历，对每个元素判断"complement是否在HashMap中"。如果存在则找到数对，如果不存在则将当前元素注册到HashMap中，然后继续下一个
5. **注册操作必须在判断之后进行**: 如果在判断之前就将元素注册到HashMap中，`nums[i]` 自身就会作为complement被匹配到。因此必须遵守先判断、后注册的顺序
6. **最终返回的内容**: 当在HashMap中找到complement时，将 `map.get(complement)`（配对元素的索引）和 `i`（当前元素的索引）以 `int[]` 的形式返回

## 前置知识

### HashMap 是什么

HashMap是一种保存键值对的数据结构。通过指定键，可以用O(1)的时间进行值的查找和获取。它类似于一个字典，能够以与数组索引访问相同的速度，通过任意键来访问数据。

```java
HashMap<Integer, Integer> map = new HashMap<>();  // 创建一个空的HashMap
map.put(10, 0);           // 将值0存储到键10中
map.containsKey(10);      // 返回boolean值，表示键10是否存在 → true
map.get(10);              // 返回键10对应的值 → 0
```

### complement（补数）是什么

complement是用 `target` 减去当前元素所得到的值，即配对元素对应的数。通过 `complement = target - nums[i]` 计算。
例：当target=9，nums[i]=2时，complement=7。如果数组中存在7，则数对成立。

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n) — 只需遍历数组一次 |
| Space | O(n) — HashMap最多保存n个元素 |

## 代码

```java
// 输入: 整数数组 nums 和整数 target
// 输出: 以 int[] 形式返回和等于 target 的两个元素的索引
public int[] twoSum(int[] nums, int target) {
    // 键=数值，值=该数值的索引 的HashMap
    // 因为题目要求返回的是索引而不是值，所以在值中保存索引
    HashMap<Integer, Integer> map = new HashMap<>();

    for (int i = 0; i < nums.length; i++) {
        // 计算配对元素，存入变量以便在 containsKey 和 get 中复用
        int complement = target - nums[i];

        // 如果complement已经注册在HashMap中，则找到了数对
        if (map.containsKey(complement)) {
            // map.get(complement) 是配对元素的索引，i 是当前元素的索引
            return new int[]{map.get(complement), i};
        }

        // 注意: 注册操作必须在判断之后进行。如果先注册，nums[i] 自身就会被匹配到
        map.put(nums[i], i);
    }
    // 根据题目约束，解一定存在，因此不会执行到这里
    return new int[]{};
}
```
