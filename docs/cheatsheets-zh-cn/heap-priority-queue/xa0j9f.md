# Tracking the Kth Largest Element in a Stream — 从流中持续获取第K大的元素

## 问题本质

设计一个类，该类接收整数 `k` 和一个初始数值列表。每次调用 `add` 方法时，将新数值添加到流中，并返回当前整个流中**第K大的元素**。

## 核心思路

由于只需要第K大的元素，因此只需用Min-Heap保留前K个最大的元素，堆的根（最小值）就始终是第K大的元素。

## 思考过程

1. **只需要第K大的元素**: 无需对整个流进行排序，只要掌握前K个最大的元素，就能确定第K大的元素
2. **希望高效管理前K个元素**: 元素的添加和最小值的取出都能在O(log n)内完成的Min-Heap（最小堆）非常适合。Min-Heap的根始终保持堆内的最小值，因此将堆的大小维持在K，根就是第K大的元素
3. **将堆的大小限制为K的方法**: 添加新元素后，如果堆的大小超过K，则通过 `poll()` 移除根（最小值）。这样，比第K大的元素更小的值会被自动排除，始终只保留前K个最大的元素
4. **获取第K大元素的方法**: 当堆的大小恰好为K时，根的值就是第K大的元素。通过 `peek()` 可以在O(1)内获取
5. **初始化时也复用add方法**: 在构造函数中对初始列表的每个元素调用 `add`，就能用相同的逻辑构建堆。初始化和添加可以共用同一套代码

## 前置知识

### 什么是Min-Heap（最小堆）

堆是一种具有完全二叉树结构的数据结构。在Min-Heap中，父节点的值始终小于或等于子节点的值。因此，根（Root）始终存放堆内的最小值。元素的添加和最小值的取出都能在O(log n)内完成。

### 什么是PriorityQueue

PriorityQueue是Java中Min-Heap的实现类。默认按升序（从小到大）对元素进行优先级排序。

```java
PriorityQueue<Integer> heap = new PriorityQueue<>();  // 创建一个空的Min-Heap
heap.offer(5);        // 将元素5添加到堆中
heap.offer(3);        // 将元素3添加到堆中
heap.offer(8);        // 将元素8添加到堆中
heap.peek();          // 不删除地返回堆的根（最小值） → 3
heap.poll();          // 删除并返回堆的根（最小值） → 3
heap.size();          // 返回堆中的元素数量 → 2
```

### 为什么Min-Heap能确定第K大的元素

大小为K的Min-Heap中存放着前K个最大的元素。堆的根是其中最小的值，即"前K个中的最小值"="整体中第K大的元素"。
例: k=3，堆的内容为 [4, 5, 8] 时，根为4。这就是整体中第3大的元素。

## 计算复杂度

| | 值 |
|---|---|
| Time | O(log k) — 每次调用add方法时，对大小为K的堆进行插入和删除各需O(log k) |
| Space | O(k) — 堆中始终最多只保留K个元素 |

## 代码

```java
// 输入: 整数 k、初始整数数组 nums、以及传递给 add 方法的整数 val
// 输出: add 方法以 int 形式返回整个流中第K大的元素
class KthLargest {
    // K作为堆的大小上限持续使用，因此保存为字段
    int k;
    // PriorityQueue默认作为Min-Heap（最小值在根）运行
    PriorityQueue<Integer> heap;

    // 构造函数: 接收k和初始数组，构建堆
    KthLargest(int k, int[] nums) {
        this.k = k;
        heap = new PriorityQueue<>();
        // 由于add方法内会执行堆的大小限制，因此不需要专门的初始化逻辑
        for (int n : nums) {
            add(n);
        }
    }

    // 添加新值，并返回第K大的元素
    int add(int val) {
        // 将元素插入堆的末尾，并向父节点方向移动以维持堆的性质（O(log k)）
        heap.offer(val);

        // 如果大小超过K，说明存在一个比第K大的元素更小的多余元素
        if (heap.size() > k) {
            // Min-Heap的根始终是最小值，因此被删除的是比第K大的元素更小的值
            heap.poll();
        }

        // 当堆的大小恰好为K时，根是堆内的最小值 = 整体中第K大的元素
        return heap.peek();
    }
}
```
