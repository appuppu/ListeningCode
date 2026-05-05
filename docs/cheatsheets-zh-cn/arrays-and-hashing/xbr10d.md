# Finding the K Most Frequent Elements — 从数组中返回出现频率最高的K个元素

## 问题的本质

给定一个整数数组 `nums` 和一个整数 `k`。从 `nums` 中选出出现次数最多的前 `k` 个元素，以数组形式返回。返回的顺序不限。题目保证答案是唯一的。

## 核心思路

在统计每个元素的出现频率之后，创建一个以频率为索引的桶数组，就可以不使用排序（O(n log n)），而以O(n)的时间复杂度按频率顺序取出元素。由于频率的最大值不超过数组的长度 `n`，所以桶数组的大小是有限的。

## 思考过程

1. **首先需要统计每个元素的出现次数**: 要求出频率最高的K个元素，就需要知道每个元素出现了多少次。使用HashMap，以"数值"为键、"出现次数"为值，可以在O(n)时间内统计所有元素的频率
2. **希望按频率排序，但排序需要O(n log n)**: 频率映射构建完成后，需要按频率从高到低取出K个元素。按频率排序的时间复杂度为O(n log n)，但存在更快的方法
3. **使用以频率为索引的桶数组**: 当数组的长度为 `n` 时，任何元素的出现频率最大为 `n`。因此，准备一个大小为 `n+1` 的数组，在索引 `i` 的位置存储"出现频率为 `i` 次的元素列表"。这就是桶排序的思想
4. **从桶数组的末尾开始遍历，收集K个元素**: 桶数组的索引越大，对应的出现频率越高。从末尾（索引 `n`）向开头遍历，如果桶不为空，就将其中的元素添加到结果列表中。当结果列表的大小达到 `k` 时，将该列表转换为数组并返回

## 前置知识

### 什么是 HashMap

HashMap是一种保存键值对的数据结构。通过指定键，可以在O(1)时间内搜索和获取值。在本题中，HashMap被用作统计每个数值出现次数的计数器。

```java
HashMap<Integer, Integer> map = new HashMap<>();  // 创建一个空的HashMap
map.merge(1, 1, Integer::sum);  // 将键1的值加1（如果键不存在则初始化为1）
map.entrySet();                 // 以Set形式返回所有键值对
entry.getKey();                 // 从键值对中获取键
entry.getValue();               // 从键值对中获取值
```

### 什么是 merge 方法

`map.merge(key, value, remappingFunction)` 在键不存在时直接存入 `value`，在键已存在时使用 `remappingFunction` 将已有值与 `value` 进行合并。传入 `Integer::sum` 时，会将 `value` 加到已有值上。该方法可以用一行代码替代 `put` + `getOrDefault` 的组合。

```java
map.merge(5, 1, Integer::sum);  // 如果键5不存在则存入1，如果存在则将已有值加1
// 上述代码等价于以下写法
map.put(5, map.getOrDefault(5, 0) + 1);
```

### 什么是桶排序

桶排序是一种将元素的值本身作为索引分配到数组中的排序方法。与基于比较的排序（O(n log n)）不同，当值的范围有限时，桶排序可以在O(n)时间内完成处理。在本题中，出现频率（最大为 `n`）被用作索引。

```java
List<Integer>[] buckets = new ArrayList[4];  // 创建索引为0到3的桶数组
buckets[2] = new ArrayList<>();              // 初始化索引为2的桶
buckets[2].add(7);                           // 将7作为"频率为2的元素"存入桶中
// buckets = [null, null, [7], null]
```

## 计算复杂度

| | 值 |
|---|---|
| Time | O(n) — 构建频率映射需要O(n)，构建桶数组需要O(n)，收集结果需要O(n)，总体为O(n) |
| Space | O(n) — 频率映射最多包含n个元素，桶数组的大小为n+1，总体为O(n) |

## 代码

```java
// 输入: 整数数组 nums 和整数 k
// 输出: 返回包含出现频率最高的前 k 个元素的 int[]
public int[] topKFrequent(int[] nums, int k) {
    // 步骤1: 使用HashMap统计每个元素的出现频率
    Map<Integer, Integer> freqMap = buildFrequencyMap(nums);
    // 步骤2: 构建以频率为索引的桶数组
    List<Integer>[] buckets = buildBuckets(freqMap, nums.length);
    // 步骤3: 从桶数组的末尾开始遍历，收集前K个元素
    return collectTopK(buckets, k);
}

// 使用HashMap统计每个元素的出现次数并返回
// 键=数值，值=该数值的出现次数
public Map<Integer, Integer> buildFrequencyMap(int[] nums) {
    Map<Integer, Integer> freqMap = new HashMap<>();
    for (int num : nums) {
        // 通过merge方法，如果键不存在则初始化为1，如果存在则将已有值加1
        freqMap.merge(num, 1, Integer::sum);
    }
    // 遍历完成后，HashMap中存储了所有元素的出现频率
    return freqMap;
}

// 构建以频率为索引的桶数组并返回
// buckets[i] 中存储出现频率为i次的元素列表
public List<Integer>[] buildBuckets(Map<Integer, Integer> freqMap, int n) {
    // 大小为n+1是因为某个元素最多可能出现n次，需要使用索引0到n
    List<Integer>[] buckets = new ArrayList[n + 1];
    for (var entry : freqMap.entrySet()) {
        int num = entry.getKey();
        int freq = entry.getValue();
        // 如果桶为null，先创建一个新的ArrayList再添加元素
        if (buckets[freq] == null) {
            buckets[freq] = new ArrayList<>();
        }
        // 以出现频率freq为索引，将数值num添加到对应的桶中
        buckets[freq].add(num);
    }
    return buckets;
}

// 从桶数组的末尾开始遍历，按频率从高到低收集K个元素并返回
// 由于索引越大出现频率越高，所以逆序遍历可以按频率从高到低依次取出元素
public int[] collectTopK(List<Integer>[] buckets, int k) {
    List<Integer> result = new ArrayList<>();
    // 从末尾（索引n）向开头遍历。索引0表示"出现频率为0次"，因此排除
    for (int i = buckets.length - 1; i > 0; i--) {
        if (buckets[i] != null) {
            for (int num : buckets[i]) {
                result.add(num);
                // 收集到K个元素时，将列表转换为数组并返回
                if (result.size() == k) {
                    return result.stream().mapToInt(Integer::intValue).toArray();
                }
            }
        }
    }
    // 根据题目约束，答案一定存在，因此不会执行到这里
    return new int[0];
}
```
