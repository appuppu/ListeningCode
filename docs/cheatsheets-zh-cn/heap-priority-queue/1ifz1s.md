# Finding the Median From a Data Stream — 从数据流中实时求取中位数

## 问题的本质

在整数从数据流中不断追加的情况下，设计一个支持两种操作的数据结构。`addNum(int num)` 添加一个整数，`findMedian()` 返回到目前为止所有已添加整数的**中位数**。当元素个数为奇数时返回中间的值，当元素个数为偶数时返回中间两个值的平均值。

## 核心思路

将所有元素分为「较小的一半」和「较大的一半」，分别用max-heap和min-heap进行管理，这样中位数始终可以从两个堆的堆顶以 O(1) 获取。

## 思考过程

1. **中位数位于「正中间」**: 要求中位数，需要将所有元素保持在排序状态下，并访问中间的元素。但是每次添加元素都进行排序会消耗 O(n log n) 的时间
2. **不需要全部元素的排序顺序，只需知道中间位置即可**: 将所有元素二分为「较小的一半（lower half）」和「较大的一半（upper half）」，那么lower half的最大值和upper half的最小值就是中位数的候选
3. **需要快速获取每一半的极值**: 要以 O(1) 获取lower half的最大值需要使用max-heap，要以 O(1) 获取upper half的最小值需要使用min-heap。向堆中添加元素只需 O(log n)
4. **保持两个堆的大小平衡**: 要正确求取中位数，需要将两个堆的大小差保持在最大为1。维持 lo（max-heap）的大小始终大于等于 hi（min-heap）的大小
5. **添加元素时的平衡调整步骤**: 先将新元素添加到 lo 中，然后将 lo 的最大值移到 hi 中。这样可以始终保证 lo 的最大值 ≤ hi 的最小值。之后如果 hi 的大小超过 lo，则将 hi 的最小值移回 lo
6. **获取中位数**: 如果 lo 的大小大于 hi，则元素总数为奇数，lo 的堆顶（最大值）即为中位数。如果大小相等，则元素总数为偶数，lo 的堆顶与 hi 的堆顶的平均值即为中位数

## 前置知识

### PriorityQueue（堆）是什么

PriorityQueue是按优先级顺序管理元素的数据结构。默认情况下作为min-heap（最小值在堆顶）运行。获取堆顶元素为 O(1)，添加和删除元素为 O(log n)。

```java
// min-heap（默认）: 最小值在堆顶
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.offer(5);       // 添加元素5
minHeap.offer(3);       // 添加元素3
minHeap.peek();          // 获取堆顶最小值 → 3（不删除）
minHeap.poll();          // 取出堆顶最小值 → 3（删除）

// max-heap: 最大值在堆顶（指定Collections.reverseOrder()）
PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
maxHeap.offer(5);       // 添加元素5
maxHeap.offer(3);       // 添加元素3
maxHeap.peek();          // 获取堆顶最大值 → 5
```

### offer / poll / peek 的区别

| 方法 | 行为 | 返回值 |
|---|---|---|
| `offer(e)` | 将元素 `e` 添加到堆中 | `boolean`（成功时返回true） |
| `poll()` | 取出堆顶元素并**删除** | 取出的元素（为空时返回 `null`） |
| `peek()` | **不删除**地查看堆顶元素 | 堆顶元素（为空时返回 `null`） |

### 中位数（median）是什么

中位数是排序后列表的正中间的值。当元素个数为奇数时取中间的1个，当元素个数为偶数时取中间2个的平均值。
例: `[1, 2, 3]` → 中位数为 `2`。`[1, 2, 3, 4]` → 中位数为 `(2 + 3) / 2.0 = 2.5`。

## 计算复杂度

| | 值 |
|---|---|
| Time | O(log n) — `addNum` 中向堆的添加和取出最多发生3次，每次操作为 O(log n)。`findMedian` 为 O(1) |
| Space | O(n) — 两个堆保存所有元素 |

## 代码

```java
// 输入: 通过 addNum(int num) 以流的形式逐个传入整数
// 输出: findMedian() 以 double 形式返回到目前为止所有已添加整数的中位数
class MedianFinder {
    // 管理较小一半的max-heap（堆顶为最大值）
    PriorityQueue<Integer> lo;
    // 管理较大一半的min-heap（堆顶为最小值）
    PriorityQueue<Integer> hi;

    MedianFinder() {
        // max-heap通过Collections.reverseOrder()设为降序
        lo = new PriorityQueue<>(Collections.reverseOrder());
        // min-heap保持默认（升序）
        hi = new PriorityQueue<>();
    }

    void addNum(int num) {
        // 所有元素首先放入较小的一半（lo）
        lo.offer(num);
        // 将lo的最大值移到hi中，从而始终维持 lo的所有元素 ≤ hi的所有元素 这一大小关系
        hi.offer(lo.poll());

        // 如果hi的大小超过lo，将hi的最小值移回lo以保持平衡
        // 通过此操作，lo的大小始终大于等于hi的大小（差值最大为1）
        if (hi.size() > lo.size())
            lo.offer(hi.poll());
    }

    double findMedian() {
        // lo的大小更大 = 元素总数为奇数 → lo的堆顶（较小一半的最大值）即为中位数
        if (lo.size() > hi.size())
            return lo.peek();

        // 大小相等 = 元素总数为偶数 → 返回中间两个值的平均
        // 除以2.0以执行浮点除法而非整数除法
        return (lo.peek() + hi.peek()) / 2.0;
    }
}
```
